local Maze = require("ui.maze")
local config = require("config")
local Player = require("ui.player")
local Ball = {}

function Ball.new()
    local self = {}
    self.grid_x = 0
    self.grid_y = 0
    self.size = 0.5

    function self.load(balls, ball_count)
        local function ballsCheck(x, y)
            for i = 1, ball_count do
                if balls[i].grid_x == x and balls[i].grid_y == y then
                    return true
                end
            end
            return false
        end
        repeat
            self.grid_x = love.math.random(0, config.grid.width - 1)
            self.grid_y = love.math.random(0, config.grid.height - 1)
        until Maze.grid[self.grid_y + 1][self.grid_x + 1] ~= 1
            and (self.grid_x ~= Player.grid_x or self.grid_y ~= Player.grid_y)
            and not ballsCheck(self.grid_x, self.grid_y)
    end

    function self.respawn(balls, ball_count)
        local function ballCheck(x, y)
            for i = 1, ball_count do
                if balls[i] ~= self and balls[i].grid_x == x and balls[i].grid_y == y then
                    return true
                end
            end
            return false
        end

        repeat
            self.grid_x = love.math.random(0, config.grid.width - 1)
            self.grid_y = love.math.random(0, config.grid.height - 1)
        until Maze.grid[self.grid_y + 1][self.grid_x + 1] ~= 1
            and (self.grid_x ~= Player.grid_x or self.grid_y ~= Player.grid_y)
            and not ballCheck(self.grid_x, self.grid_y)
    end

    function self.draw()
        local cellSize = Maze.getCellSize()
        local offsetX, offsetY = Maze.getMazeOffset()
        local objSize = cellSize * self.size
        local draw_x = offsetX + self.grid_x * cellSize + (cellSize - objSize) / 2
        local draw_y = offsetY + self.grid_y * cellSize + (cellSize - objSize) / 2
        love.graphics.setColor(168 / 255, 164 / 255, 149 / 255)
        love.graphics.ellipse("fill",
            draw_x + objSize / 2,
            draw_y + objSize / 2,
            objSize / 2,
            objSize / 2)
    end

    return self
end

return Ball
