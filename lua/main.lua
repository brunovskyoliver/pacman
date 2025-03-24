local Maze = require("ui.maze")
local Player = require("ui.player")

local player

function love.load()
    love.window.setMode(800, 800)
    love.window.setTitle("Maze")

    love.math.setRandomSeed(os.time())
    player = Player.new()
    player.load()
end

function love.draw()
    Maze.draw()
    player.draw()
end

function love.keypressed(key)
    if key == "up" then
        local target_y = player.grid_y - 1
        if target_y >= 0 and Maze.grid[target_y + 1][player.grid_x + 1] == 0 then
            player.grid_y = target_y
        end
    elseif key == "down" then
        local target_y = player.grid_y + 1
        if target_y <= 12 and Maze.grid[target_y + 1][player.grid_x + 1] == 0 then
            player.grid_y = target_y
        end
    elseif key == "left" then
        local target_x = player.grid_x - 1
        if target_x >= 0 and Maze.grid[player.grid_y + 1][target_x + 1] == 0 then
            player.grid_x = target_x
        end
    elseif key == "right" then
        local target_x = player.grid_x + 1
        if target_x <= 12 and Maze.grid[player.grid_y + 1][target_x + 1] == 0 then
            player.grid_x = target_x
        end
    end
    print(player.grid_x, player.grid_y)
end
