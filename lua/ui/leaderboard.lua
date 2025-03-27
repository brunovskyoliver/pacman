local config = require('config')
local Leaderboard = {}
Leaderboard.window_width = config.window.width
Leaderboard.window_height = config.window.height
Leaderboard.font_height = 30
Leaderboard.score = "0"
Leaderboard.player_name = ""
Leaderboard.player_ip = ""
Leaderboard.images = {}

function Leaderboard.load()
    Leaderboard.window_width, Leaderboard.window_height = love.graphics.getDimensions()
    local font = love.graphics.setNewFont(30)
    Leaderboard.font_height = font:getHeight()
    Leaderboard.images = { cancel = love.graphics.newImage('assets/cancel.png') }

    local success = pcall(function()
        local file = io.open("data/highscore.txt", "r")
        if file then
            local content = file:read("*all")
            file:close()
            local parts = {}
            for part in string.gmatch(content, "[^;]+") do
                table.insert(parts, part)
            end
            if #parts >= 3 then
                Leaderboard.score = parts[1]
                Leaderboard.player_name = parts[2]
                Leaderboard.player_ip = parts[3]
            end
        end
    end)

    if not success then
        print("Unable to read highscore file directly, using default values")
    end
end

function Leaderboard.setScore(score, player_name, player_ip)
    Leaderboard.score = score
    Leaderboard.player_name = player_name
    Leaderboard.player_ip = player_ip
end

function Leaderboard.draw(Menu)
    love.graphics.setBackgroundColor(134 / 255, 45 / 255, 89 / 255)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(Leaderboard.images.cancel, 20, 20, 0, 2, 2)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setNewFont(50)
    love.graphics.printf("LEADERBOARD", 0, 100, Leaderboard.window_width, 'center')
    love.graphics.setNewFont(40)
    love.graphics.printf("TOP SCORE", 0, 200, Leaderboard.window_width, 'center')
    love.graphics.setNewFont(60)
    love.graphics.printf(Leaderboard.score, 0, 260, Leaderboard.window_width, 'center')
    love.graphics.setNewFont(30)
    love.graphics.printf("Player: " .. Leaderboard.player_name, 0, 340, Leaderboard.window_width, 'center')
    love.graphics.setNewFont(20)
    love.graphics.printf("IP: " .. Leaderboard.player_ip, 0, 380, Leaderboard.window_width, 'center')
end

function Leaderboard.update(dt, Menu)
end

function Leaderboard.mousepressed(x, y, back_callback)
    if x > 20 and x < 20 + Leaderboard.images.cancel:getWidth() * 2 and
        y > 20 and y < 20 + Leaderboard.images.cancel:getHeight() * 2 then
        back_callback()
    end
end

function Leaderboard.keypressed(key, back_callback)
    if key == 'escape' then
        back_callback()
    end
end

return Leaderboard

