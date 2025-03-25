local Maze = require("ui.maze")
local config = require("config")
local Player = require("ui.player")
local Enemy = {}

function Enemy.new(selectedEnemy)
    local self = {}
    self.img = {}
    self.imgs_bazger = { love.graphics.newImage("assets/bazger.png"), love.graphics.newImage(
        "assets/bazger_open_rotate.png") }
    self.imgs_lukasko = { love.graphics.newImage("assets/lukasko.png"), love.graphics.newImage("assets/lukasko_open.png") }
    if selectedEnemy == "Bazman" then
        self.imgs = self.imgs_bazger
    elseif selectedEnemy == "Lukasko" then
        self.imgs = self.imgs_lukasko
    end
    self.current_img = 1
    self.img_open = {}
    self.img.scale = 0.5
    self.grid_x = 0
    self.grid_y = 0
    self.cellWidth = 0
    self.cellHeight = 0
    self.objWidth = 0
    self.objHeight = 0
    self.size = 0.5
    self.visited = {}
    self.image = love.graphics.newImage("assets/bazger.png")
    self.img.width = self.image:getWidth() * self.img.scale
    self.img.height = self.image:getHeight() * self.img.scale

    function self.load()
        self.cellWidth = love.graphics.getWidth() / config.grid.width
        self.cellHeight = (love.graphics.getHeight() - config.offset) / config.grid.height
        self.objWidth = self.cellWidth * self.size
        self.objHeight = self.cellHeight * self.size
        self.color = { math.random(), math.random(), math.random() }

        repeat
            self.grid_x = love.math.random(0, config.grid.width - 1)
            self.grid_y = love.math.random(0, config.grid.height - 1)
        until Maze.grid[self.grid_y + 1][self.grid_x + 1] ~= 1
            and (self.grid_x ~= Player.grid_x or self.grid_y ~= Player.grid_y)
    end

    function self.draw()
        -- local draw_x = self.grid_x * self.cellWidth + (self.cellWidth - self.objWidth) / 2
        -- local draw_y = self.grid_y * self.cellHeight + (self.cellHeight - self.objHeight) / 2
        -- love.graphics.setColor(1, 0, 0)
        -- love.graphics.ellipse("fill", draw_x + self.objWidth / 2, draw_y + self.objHeight / 2 + config.offset,
        --     self.objWidth / 2,
        --     self.objHeight / 2)
        --     feat: draw bazger
        local draw_x = self.grid_x * self.cellWidth + (self.cellWidth - self.img.width) / 2
        local draw_y = self.grid_y * self.cellHeight + (self.cellHeight - self.img.height) / 2 + config.offset
        love.graphics.setColor(self.color)
        love.graphics.draw(self.imgs[self.current_img], draw_x + self.img.width / 4, draw_y + self.img.height / 4, 0,
            self.img.scale,
            self.img.scale,
            self.img.width / 2, self.img.height / 2)
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
