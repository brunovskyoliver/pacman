local maze = require("ui.maze")
local player = {}

function player.new()
    local self = {}
    self.grid_x = 0
    self.grid_y = 0
    self.cellWidth = 0
    self.cellHeight = 0
    self.objWidth = 0
    self.objHeight = 0

    function self.load()
        self.cellWidth = love.graphics.getWidth() / 13
        self.cellHeight = love.graphics.getHeight() / 13
        self.objWidth = self.cellWidth * 0.6
        self.objHeight = self.cellHeight * 0.6
        self.grid_x = love.math.random(0, 12)
        self.grid_y = love.math.random(0, 12)
        while maze.grid[self.grid_y + 1][self.grid_x + 1] == 1 do
            self.grid_x = love.math.random(0, 12)
            self.grid_y = love.math.random(0, 12)
        end
    end

    function self.draw()
        local draw_x = self.grid_x * self.cellWidth + (self.cellWidth - self.objWidth) / 2
        local draw_y = self.grid_y * self.cellHeight + (self.cellHeight - self.objHeight) / 2
        love.graphics.setColor(1, 0, 0)
        love.graphics.ellipse("fill", draw_x + self.objWidth / 2, draw_y + self.objHeight / 2, self.objWidth / 2,
            self.objHeight / 2)
    end

    return self
end

return player
