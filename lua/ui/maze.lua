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
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight() - config.offset
    local mazeSize = math.min(screenWidth, screenHeight)
    local cellSize = mazeSize / mazeWidth

    local offsetX = (screenWidth - mazeSize) / 2
    local offsetY = config.offset

    for row = 1, mazeHeight do
        for col = 1, mazeWidth do
            if M.grid[row][col] == 1 then
                love.graphics.setColor(0, 0, 0)
            else
                love.graphics.setColor(1, 1, 1)
            end
            love.graphics.rectangle("fill",
                offsetX + (col - 1) * cellSize,
                offsetY + (row - 1) * cellSize,
                cellSize, cellSize)

            love.graphics.setColor(0.6, 0.6, 0.6)
            love.graphics.rectangle("line",
                offsetX + (col - 1) * cellSize,
                offsetY + (row - 1) * cellSize,
                cellSize, cellSize)
        end
    end
end

function M.getCellSize()
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight() - config.offset
    local mazeSize = math.min(screenWidth, screenHeight)
    return mazeSize / mazeWidth
end

function M.getMazeOffset()
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight() - config.offset
    local mazeSize = math.min(screenWidth, screenHeight)
    return (screenWidth - mazeSize) / 2, config.offset
end

return M
