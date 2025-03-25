local Maze = require("ui.maze")
local Config = require("config")
local Player = require("ui.player")
local Menu = require("ui.menu")
local Ball = require("ui.ball")
local Enemy = require("ui.enemy")
local GameOver = require("ui.gameover")

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

function startGame()
    love.math.setRandomSeed(os.time())
    player = Player.new()
    player.load()
    for i = 1, Config.balls do
        balls[i] = Ball.new()
        balls[i].load(balls, i - 1)
    end
    for i = 1, Config.enemies do
        enemies[i] = Enemy.new()
        enemies[i].load()
    end
    gameState = 'game'
end

function love.load()
    love.window.setMode(Config.window.width, Config.window.height)
    love.window.setTitle("Bazman")
    Menu.load()
    GameOver.load()
end

function love.update(dt)
    if gameState == 'game' then
        timer = timer + dt
        initialTimer = initialTimer + dt
        if ballTouch() then
            player.ballsTouched = player.ballsTouched + 1
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
    end
    if gameState == 'menu' then
        Menu.update(dt)
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
        GameOver.draw()
    end
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
    elseif gameState == 'gameover' then
        GameOver.keypressed(key, startGame)
    end
end
