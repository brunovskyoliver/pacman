local Maze = require("ui.maze")
local config = require("config")
local Player = {}

function Player.new()
    local self = {}
    self.img = {}
    self.img.scale = 0.5
    self.grid_x = 0
    self.grid_y = 0
    self.ballsTouched = 0
    self.image = love.graphics.newImage("assets/metodej.png")
    self.img.width = self.image:getWidth() * self.img.scale
    self.img.height = self.image:getHeight() * self.img.scale

    function self.load()
        self.grid_x = love.math.random(0, config.grid.width - 1)
        self.grid_y = love.math.random(0, config.grid.height - 1)
        while Maze.grid[self.grid_y + 1][self.grid_x + 1] == 1 do
            self.grid_x = love.math.random(0, config.grid.width - 1)
            self.grid_y = love.math.random(0, config.grid.height - 1)
        end
    end

    function self.draw()
        local cellSize = Maze.getCellSize()
        local offsetX, offsetY = Maze.getMazeOffset()

        local draw_x = offsetX + self.grid_x * cellSize + (cellSize - self.img.width) / 2
        local draw_y = offsetY + self.grid_y * cellSize + (cellSize - self.img.height) / 2

        love.graphics.draw(self.image,
            draw_x + self.img.width / 4,
            draw_y + self.img.height / 4,
            0,
            self.img.scale,
            self.img.scale,
            self.img.width / 2,
            self.img.height / 2)
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
