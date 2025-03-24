local game_state = 'menu'
local Maze = require("ui.maze")
local config = require("config")
local Player = require("ui.player")
local Menu = require("ui.menu")

local player

function start_game()
    love.math.setRandomSeed(os.time())
    player = Player.new()
    player.load()
    game_state = 'game'
end

function love.load()
    love.window.setMode(800, 800)
    love.window.setTitle("Bazman")
    Menu.load()
end

function love.update(dt)
    -- Any game update logic
end

function love.draw()
    if game_state == 'menu' then
        Menu.draw()
    elseif game_state == 'game' then
        Maze.draw()
        player.draw()
    end
end

function love.keypressed(key, scancode, isrepeat)
    if game_state == 'menu' then
        Menu.keypressed(key, start_game)
    elseif game_state == 'game' then
        player.keypressed(key)
    end
end

function game_keypressed(key)
    if key == 'escape' then
        game_state = 'menu'
    end
    if key == "up" then
        local target_y = player.grid_y - 1
        if target_y >= 0 and Maze.grid[target_y + 1][player.grid_x + 1] == 0 then
            player.grid_y = target_y
        end
    elseif key == "down" then
        local target_y = player.grid_y + 1
        if target_y <= config.grid.height - 1 and Maze.grid[target_y + 1][player.grid_x + 1] == 0 then
            player.grid_y = target_y
        end
    elseif key == "left" then
        local target_x = player.grid_x - 1
        if target_x >= 0 and Maze.grid[player.grid_y + 1][target_x + 1] == 0 then
            player.grid_x = target_x
        end
    elseif key == "right" then
        local target_x = player.grid_x + 1
        if target_x <= config.grid.width - 1 and Maze.grid[player.grid_y + 1][target_x + 1] == 0 then
            player.grid_x = target_x
        end
    end
    print(player.grid_x, player.grid_y)
end
