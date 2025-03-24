local config = require("config")
local M = {}

M.grid = {
    { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
    { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
    { 1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1 },
    { 1, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 1 },
    { 1, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0, 1 },
    { 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1 },
    { 1, 0, 1, 0, 1, 1, 0, 1, 1, 0, 1, 0, 1 },
    { 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1 },
    { 1, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0, 1 },
    { 1, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 1 },
    { 1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1 },
    { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
    { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
}

local mazeWidth = config.grid.width
local mazeHeight = config.grid.height

function M.draw()
    local cellWidth = love.graphics.getWidth() / mazeWidth
    local cellHeight = (love.graphics.getHeight() - config.offset) / mazeHeight

    for row = 1, mazeHeight do
        for col = 1, mazeWidth do
            if M.grid[row][col] == 1 then
                love.graphics.setColor(0, 0, 0)
            else
                love.graphics.setColor(1, 1, 1) -- normalized color
            end
            love.graphics.rectangle("fill", (col - 1) * cellWidth, (row - 1) * cellHeight + config.offset, cellWidth,
                cellHeight)
            love.graphics.setColor(0.6, 0.6, 0.6) -- grid lines
            love.graphics.rectangle("line", (col - 1) * cellWidth, (row - 1) * cellHeight + config.offset, cellWidth,
                cellHeight)
        end
    end
end

return M
