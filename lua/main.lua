local Maze = require("ui.maze")
local config = require("config")
local Player = require("ui.player")
local Menu = require("ui.menu")
local Ball = require("ui.ball")
local Enemy = require("ui.enemy")
local GameOver = require("ui.gameover")

local player
local game_state = 'menu'
local start_game
local ballTouch
local enemyTouch
local balls = {}
local enemies = {}
local timer = 0
local interval = 0.5
local initial_wait = 1
local initial_timer = 0

function start_game()
    love.math.setRandomSeed(os.time())
    player = Player.new()
    player.load()
    for i = 1, config.balls do
        balls[i] = Ball.new()
        balls[i].load(balls, i - 1)
    end
    for i = 1, config.enemies do
        enemies[i] = Enemy.new()
        enemies[i].load()
    end
    game_state = 'game'
end

function love.load()
    love.window.setMode(800, 900)
    love.window.setTitle("Bazman")
    Menu.load()
    GameOver.load()
end

function love.update(dt)
    if game_state == 'game' then
        timer = timer + dt
        initial_timer = initial_timer + dt
        if ballTouch() then
            player.ballsTouched = player.ballsTouched + 1
        end
        if enemyTouch() then
            game_state = 'gameover'
        end
        if timer >= interval and initial_timer > initial_wait then
            for i = 1, config.enemies do
                enemies[i].move()
            end
            timer = 0
        end
    end
end

function love.draw()
    if game_state == 'menu' then
        Menu.draw()
    elseif game_state == 'game' then
        Maze.draw()
        player.draw()
        for i = 1, config.balls do
            balls[i].draw()
        end
        for i = 1, config.enemies do
            enemies[i].draw()
        end
        love.graphics.setColor(1, 0, 0)
        love.graphics.print("Balls touched: " .. player.ballsTouched,
            love.graphics.getWidth() / 2 - love.graphics.getFont():getWidth("Balls touched: " .. player.ballsTouched) / 2,
            30)
    elseif game_state == 'gameover' then
        GameOver.draw()
    end
end

function ballTouch()
    for i = 1, config.balls do
        if player.grid_x == balls[i].grid_x and player.grid_y == balls[i].grid_y then
            balls[i].respawn(balls, config.balls)
            return true
        end
    end
    return false
end

function enemyTouch()
    for i = 1, config.enemies do
        if player.grid_x == enemies[i].grid_x and player.grid_y == enemies[i].grid_y then
            return true
        end
    end
    return false
end

function love.keypressed(key, scancode, isrepeat)
    if game_state == 'menu' then
        Menu.keypressed(key, start_game)
    elseif game_state == 'game' then
        player.keypressed(key, function()
            game_state = 'menu'
        end)
    elseif game_state == 'gameover' then
        GameOver.keypressed(key, start_game)
    end
end
