local Maze = require("ui.maze")
local Config = require("config")
local Player = require("ui.player")
local Menu = require("ui.menu")
local Ball = require("ui.ball")
local Enemy = require("ui.enemy")
local GameOver = require("ui.gameover")
local EnemySelection = require("ui.enemy_selection")

local player
local startGame
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

function startGame()
    -- love.math.setRandomSeed(os.time())
    -- player = Player.new()
    -- player.load()
    -- for i = 1, Config.balls do
    --     balls[i] = Ball.new()
    --     balls[i].load(balls, i - 1)
    -- end
    -- for i = 1, Config.enemies do
    --     enemies[i] = Enemy.new()
    --     enemies[i].load()
    -- end
    -- gameState = 'game'
    -- interval = 0.5
    gameState = 'enemy_selection'
    EnemySelection.load()
    EnemySelection.draw()
    interval = 0.5
    initialTimer = 0
end

function love.load()
    love.window.setMode(Config.window.width, Config.window.height)
    love.window.setTitle("Bazman")
    love.mouse.setVisible(false)
    cursor.image = love.graphics.newImage("assets/cursor.png")
    Menu.load()
    GameOver.load()
end

function love.update(dt)
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
        -- print(love.mouse.getX())
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
        GameOver.draw(player, enemyName)
    elseif gameState == 'enemy_selection' then
        EnemySelection.draw()
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
            return true
        end
    end
    return false
end

function love.keypressed(key, scancode, isrepeat)
    if gameState == 'menu' then
        Menu.keypressed(key, startGame)
    elseif gameState == 'game' then
        player.keypressed(key, function()
            gameState = 'menu'
        end)
    elseif gameState == 'enemy_selection' then
        EnemySelection.keypressed(key, function() gameState = 'menu' end)
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if gameState == 'menu' then
        Menu.mousepressed(x, y, startGame)
    elseif gameState == 'gameover' then
        GameOver.mousepressed(x, y, startGame, function()
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
    end
end
