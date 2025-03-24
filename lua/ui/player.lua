local Maze = require("ui.maze")
local config = require("config")
local Player = {}

function Player.new()
    local self = {}
    self.grid_x = 0
    self.grid_y = 0
    self.cellWidth = 0
    self.cellHeight = 0
    self.objWidth = 0
    self.objHeight = 0
    self.ballsTouched = 0

    function self.load()
        self.cellWidth = love.graphics.getWidth() / config.grid.width
        self.cellHeight = (love.graphics.getHeight() - config.offset) / config.grid.height
        self.objWidth = self.cellWidth * 0.6
        self.objHeight = self.cellHeight * 0.6
        self.grid_x = love.math.random(0, config.grid.width - 1)
        self.grid_y = love.math.random(0, config.grid.height - 1)
        while Maze.grid[self.grid_y + 1][self.grid_x + 1] == 1 do
            self.grid_x = love.math.random(0, config.grid.width - 1)
            self.grid_y = love.math.random(0, config.grid.height - 1)
        end
    end

    function self.draw()
        local draw_x = self.grid_x * self.cellWidth + (self.cellWidth - self.objWidth) / 2
        local draw_y = self.grid_y * self.cellHeight + (self.cellHeight - self.objHeight) / 2 + config.offset
        love.graphics.setColor(1, 218 / 255, 3 / 255)
        love.graphics.ellipse("fill", draw_x + self.objWidth / 2, draw_y + self.objHeight / 2, self.objWidth / 2,
            self.objHeight / 2)
    end

    function self.keypressed(key, callback)
        if key == 'escape' then
            callback()
        end
        if key == "up" then
            local target_y = self.grid_y - 1
            if target_y >= 0 and Maze.grid[target_y + 1][self.grid_x + 1] == 0 then
                self.grid_y = target_y
            end
        elseif key == "down" then
            local target_y = self.grid_y + 1
            if target_y <= config.grid.height - 1 and Maze.grid[target_y + 1][self.grid_x + 1] == 0 then
                self.grid_y = target_y
            end
        elseif key == "left" then
            local target_x = self.grid_x - 1
            if target_x >= 0 and Maze.grid[self.grid_y + 1][target_x + 1] == 0 then
                self.grid_x = target_x
            end
        elseif key == "right" then
            local target_x = self.grid_x + 1
            if target_x <= config.grid.width - 1 and Maze.grid[self.grid_y + 1][target_x + 1] == 0 then
                self.grid_x = target_x
            end
        end
        print(self.grid_x, self.grid_y, self.ballsTouched)
    end

    return self
end

return Player
