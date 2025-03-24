local Maze = require("ui.maze")
local config = require("config")
local Player = require("ui.player")
local Enemy = {}

function Enemy.new()
    local self = {}
    self.grid_x = 0
    self.grid_y = 0
    self.cellWidth = 0
    self.cellHeight = 0
    self.objWidth = 0
    self.objHeight = 0
    self.size = 0.5
    self.visited = {}

    function self.load()
        self.cellWidth = love.graphics.getWidth() / config.grid.width
        self.cellHeight = (love.graphics.getHeight() - config.offset) / config.grid.height
        self.objWidth = self.cellWidth * self.size
        self.objHeight = self.cellHeight * self.size

        repeat
            self.grid_x = love.math.random(0, config.grid.width - 1)
            self.grid_y = love.math.random(0, config.grid.height - 1)
        until Maze.grid[self.grid_y + 1][self.grid_x + 1] ~= 1
            and (self.grid_x ~= Player.grid_x or self.grid_y ~= Player.grid_y)
    end

    function self.draw()
        local draw_x = self.grid_x * self.cellWidth + (self.cellWidth - self.objWidth) / 2
        local draw_y = self.grid_y * self.cellHeight + (self.cellHeight - self.objHeight) / 2
        love.graphics.setColor(1, 0, 0)
        love.graphics.ellipse("fill", draw_x + self.objWidth / 2, draw_y + self.objHeight / 2 + config.offset,
            self.objWidth / 2,
            self.objHeight / 2)
    end

    function self.move()
        local dirs = { { 0, -1 }, { 0, 1 }, { -1, 0 }, { 1, 0 } }
        while #dirs > 0 do
            local index = love.math.random(1, #dirs)
            local dir = dirs[index]
            local target_x = self.grid_x + dir[1]
            local target_y = self.grid_y + dir[2]
            if Maze.grid[target_y + 1][target_x + 1] ~= 1
                and not self.visited[target_y .. "," .. target_x] then
                self.grid_x, self.grid_y = target_x, target_y
                self.visited[self.grid_y .. "," .. self.grid_x] = true
                return
            else
                table.remove(dirs, index)
            end
        end
        self.visited = {}
    end

    return self
end

return Enemy
