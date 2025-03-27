local Maze = require("ui.maze")
local enet = require "enet"
local Config = require("config")
local Player = require("ui.player")
local Menu = require("ui.menu")
local Ball = require("ui.ball")
local Enemy = require("ui.enemy")
local GameOver = require("ui.gameover")
local EnemySelection = require("ui.enemy_selection")
local Leaderboard = require("ui.leaderboard")
local NameInput = require("ui.name_input")

local clientpeer = nil
local enetclient = nil

local player
local startGame
local ClientSend
local ballTouch
local enemyTouch
local balls = {}
local enemies = {}
local gameState = 'menu'
local timer = 0
local interval = 0.5
local initialWait = 1
local initialTimer = 0
local animateTimer = 0
local animateInterval = 0.3
local cursor = {}
local enemyName
local playerName = ""
local initialHelloSent = false

function ClientSend(message)
    clientpeer:send(message)
end

function startGame()
    gameState = 'name_input'
    NameInput.load()
end

function love.load()
    enetclient = enet.host_create()
    clientpeer = enetclient:connect("127.0.0.1:6969")
    love.window.setMode(Config.window.width, Config.window.height)
    love.window.setTitle("Bazman")
    love.mouse.setVisible(false)
    cursor.image = love.graphics.newImage("assets/cursor.png")
    Menu.load()
    GameOver.load()
    Leaderboard.load()
    NameInput.load()
end

function love.update(dt)
    local event = enetclient:service()
    if event then
        if event.type == "connect" then
            print("con")
            if gameState == 'menu' and not initialHelloSent then
                ClientSend("hello")
                initialHelloSent = true
            end
        elseif event.type == "receive" then
            local data = event.data
            print("packet: " .. data)

            if string.find(data, "highscore:") then
                local parts = {}
                for part in string.gmatch(data:sub(11), "[^;]+") do
                    table.insert(parts, part)
                end
                if #parts >= 3 then
                    Leaderboard.setScore(parts[1], parts[2], parts[3])
                end
            end
        end
    end
    cursor.x, cursor.y = love.mouse.getPosition()
    if gameState == 'game' then
        timer = timer + dt
        initialTimer = initialTimer + dt
        animateTimer = animateTimer + dt
        if ballTouch() then
            player.ballsTouched = player.ballsTouched + 1
            interval = interval * 0.95
        end
        if enemyTouch() then
            gameState = 'gameover'
        end
        if timer >= interval and initialTimer > initialWait then
            for i = 1, Config.enemies do
                enemies[i].move()
            end
            timer = 0
        end
        if animateTimer >= animateInterval then
            for i = 1, Config.enemies do
                if enemies[i].current_img == 1 then
                    enemies[i].current_img = 2
                else
                    enemies[i].current_img = 1
                end
            end
            animateTimer = 0
        end
    end
    if gameState == 'menu' then
        Menu.update(dt)
    end
    if gameState == 'enemy_selection' then
        EnemySelection.update(dt, Menu)
    end
    if gameState == 'gameover' then
        GameOver.update(dt, Menu)
    end
    if gameState == 'leaderboard' then
        Leaderboard.update(dt, Menu)
    end
    if gameState == 'name_input' then
        NameInput.update(dt, Menu)
    end
end

function love.draw()
    if gameState == 'menu' then
        Menu.draw()
    elseif gameState == 'game' then
        Maze.draw()
        player.draw()
        for i = 1, Config.balls do
            balls[i].draw()
        end
        for i = 1, Config.enemies do
            enemies[i].draw()
        end
        love.graphics.setColor(1, 0, 0)
        love.graphics.print("Balls touched: " .. player.ballsTouched,
            love.graphics.getWidth() / 2 - love.graphics.getFont():getWidth("Balls touched: " .. player.ballsTouched) / 2,
            30)
    elseif gameState == 'gameover' then
        GameOver.draw(player, enemyName, Menu)
    elseif gameState == 'enemy_selection' then
        EnemySelection.draw(Menu)
    elseif gameState == 'leaderboard' then
        Leaderboard.draw(Menu)
    elseif gameState == 'name_input' then
        NameInput.draw(Menu)
    end
    love.graphics.draw(cursor.image, cursor.x, cursor.y)
end

function ballTouch()
    for i = 1, Config.balls do
        if player.grid_x == balls[i].grid_x and player.grid_y == balls[i].grid_y then
            balls[i].respawn(balls, Config.balls)
            return true
        end
    end
    return false
end

function enemyTouch()
    for i = 1, Config.enemies do
        if player.grid_x == enemies[i].grid_x and player.grid_y == enemies[i].grid_y then
            ClientSend("gameover: " .. player.ballsTouched .. ";" .. playerName)
            return true
        end
    end
    return false
end

function love.textinput(text)
    if gameState == 'name_input' then
        NameInput.textinput(text)
    end
end

function love.keypressed(key, scancode, isrepeat)
    if gameState == 'menu' then
        Menu.keypressed(key, startGame, function()
            gameState = 'leaderboard'
            ClientSend("get_highscore")
            Leaderboard.load()
        end)
    elseif gameState == 'game' then
        player.keypressed(key, function()
            gameState = 'menu'
        end)
    elseif gameState == 'enemy_selection' then
        EnemySelection.keypressed(key, function() gameState = 'menu' end)
    elseif gameState == 'leaderboard' then
        Leaderboard.keypressed(key, function() gameState = 'menu' end)
    elseif gameState == 'name_input' then
        NameInput.keypressed(key,
            function(name)
                playerName = name
                gameState = 'enemy_selection'
                EnemySelection.load()
            end,
            function()
                gameState = 'menu'
            end
        )
    elseif gameState == 'gameover' then
        if key == 'return' or key == 'kpenter' or key == 'space' then
            gameState = 'enemy_selection'
            EnemySelection.load()
        elseif key == 'escape' then
            gameState = 'menu'
        end
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if gameState == 'menu' then
        Menu.mousepressed(x, y, startGame, function()
            gameState = 'leaderboard'
            ClientSend("get_highscore")
            Leaderboard.load()
        end)
    elseif gameState == 'gameover' then
        GameOver.mousepressed(x, y, function()
            gameState = 'enemy_selection'
            EnemySelection.load()
        end, function()
            gameState = 'menu'
        end)
    elseif gameState == 'enemy_selection' then
        EnemySelection.mousepressed(x, y, function(selectedEnemy)
            gameState = 'game'
            player = Player.new()
            player.load()
            enemyName = selectedEnemy
            for i = 1, Config.balls do
                balls[i] = Ball.new()
                balls[i].load(balls, i - 1)
            end
            for i = 1, Config.enemies do
                enemies[i] = Enemy.new(selectedEnemy)
                enemies[i].load()
            end
        end, function()
            gameState = 'menu'
        end)
    elseif gameState == 'leaderboard' then
        Leaderboard.mousepressed(x, y, function()
            gameState = 'menu'
        end)
    elseif gameState == 'name_input' then
        NameInput.mousepressed(x, y,
            function(name)
                playerName = name
                gameState = 'enemy_selection'
                EnemySelection.load()
            end,
            function()
                gameState = 'menu'
            end
        )
    end
end
