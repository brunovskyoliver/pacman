local config = require('config')
local Settings = {}
Settings.menus = { 'Bazger', 'Lukasko' }
Settings.selected_menu_item = 1
Settings.font_height = 30
Settings.font_padding = 15
Settings.window_width = config.window.width
Settings.window_height = config.window.height
Settings.pacman = {}
Settings.logo = {}
Settings.logo.holder = {}
Settings.images = {}

function Settings.load()
    Settings.window_width, Settings.window_height = love.graphics.getDimensions()
    local font = love.graphics.setNewFont(30)
    Settings.font_height = font:getHeight()
    Settings.images = { cancel = love.graphics.newImage('assets/cancel.png') }
end

function Settings.draw()
    love.graphics.setBackgroundColor(134 / 255, 45 / 255, 89 / 255)
    love.graphics.draw(Settings.images.cancel, 20, 20, 0, 2, 2)
    local button_width = 200
    local button_height = 300
    local total_width = (#Settings.menus * button_width) +
        ((#Settings.menus - 1) * Settings.font_padding)
    local start_x = (Settings.window_width - total_width) / 2
    local y = Settings.window_height / 2 - (button_height / 2)

    for i = 1, #Settings.menus do
        local x = start_x + (i - 1) * (button_width + Settings.font_padding)

        if i == Settings.selected_menu_item then
            love.graphics.setColor(153 / 255, 153 / 255, 51 / 255, 1)
        else
            love.graphics.setColor(153 / 255, 102 / 255, 51 / 255, 1)
        end

        love.graphics.rectangle("fill", x, y, button_width, button_height)

        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf(Settings.menus[i], x, y + (button_height / 2) - (Settings.font_height / 2),
            button_width, 'center')
    end
end

function Settings.update(dt)
end

function Settings.keypressed(key, go_back_callback)
    if key == 'escape' then
        go_back_callback()
    end
end

function Settings.mousepressed(x, y, start_game_callback, go_back_callback)
    local horizontal_center = Settings.window_width / 2
    local vertical_center = Settings.window_height / 2
    local start_y = vertical_center - (Settings.font_height * (#Settings.menus / 2))
    for i = 1, #Settings.menus do
        if x > horizontal_center - 100 and x < horizontal_center + 100 and
            y > start_y + Settings.font_height * (i - 1) + Settings.font_padding * (i - 1) and
            y < start_y + Settings.font_height * (i - 1) + Settings.font_padding * (i - 1) + Settings.font_height then
            local selected = Settings.menus[i]
            -- if EnemySelection.menus[i] == 'Play' then
            --     start_game_callback()
            start_game_callback(selected)
        end
    end
    if x > 20 and x < 20 + Settings.images.cancel:getWidth() * 2 and y > 20 and y < 20 + Settings.images.cancel:getHeight() * 2 then
        go_back_callback()
    end
end

return Settings
