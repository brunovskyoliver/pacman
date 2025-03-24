local Maze = require("ui.maze")
local config = require("config")
local Player = require("ui.player")
local Menu = require("ui.menu")
local Ball = require("ui.ball")

local player
local game_state = 'menu'
local start_game
local ballTouch
local balls = {}

function start_game()
    love.math.setRandomSeed(os.time())
    player = Player.new()
    player.load()
    for i = 1, config.balls do
        balls[i] = Ball.new()
        balls[i].load(balls, i - 1)
    end

    game_state = 'game'
end

function love.load()
    love.window.setMode(800, 900)
    love.window.setTitle("Bazman")
    Menu.load()
end

function love.update(dt)
    if game_state == 'game' then
        if ballTouch() then
            player.ballsTouched = player.ballsTouched + 1
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
        love.graphics.setColor(1, 0, 0)
        love.graphics.print("Balls touched: " .. player.ballsTouched,
            love.graphics.getWidth() / 2 - love.graphics.getFont():getWidth("Balls touched: " .. player.ballsTouched) / 2,
            30)
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

function love.keypressed(key, scancode, isrepeat)
    if game_state == 'menu' then
        Menu.keypressed(key, start_game)
    elseif game_state == 'game' then
        player.keypressed(key)
    end
end
