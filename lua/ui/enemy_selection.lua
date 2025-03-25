local config = require('config')
local EnemySelection = {}
EnemySelection.menus = { 'Bazman', 'Lukasko' }
EnemySelection.selected_menu_item = 1
EnemySelection.font_height = 30
EnemySelection.font_padding = 15
EnemySelection.window_width = config.window.width
EnemySelection.window_height = config.window.height
EnemySelection.pacman = {}
EnemySelection.logo = {}
EnemySelection.logo.holder = {}
EnemySelection.images = {}

function EnemySelection.load()
    EnemySelection.window_width, EnemySelection.window_height = love.graphics.getDimensions()
    local font = love.graphics.setNewFont(30)
    EnemySelection.font_height = font:getHeight()
    EnemySelection.images = { cancel = love.graphics.newImage('assets/cancel.png') }
end

function EnemySelection.draw()
    love.graphics.setBackgroundColor(134 / 255, 45 / 255, 89 / 255)
    love.graphics.draw(EnemySelection.images.cancel, 20, 20, 0, 2, 2)
    local button_width = 200
    local button_height = 300
    local total_width = (#EnemySelection.menus * button_width) +
        ((#EnemySelection.menus - 1) * EnemySelection.font_padding)
    local start_x = (EnemySelection.window_width - total_width) / 2
    local y = EnemySelection.window_height / 2 - (button_height / 2)

    love.graphics.printf('Vyber si protivnika', 0, y - 50, EnemySelection.window_width, 'center')
    for i = 1, #EnemySelection.menus do
        local x = start_x + (i - 1) * (button_width + EnemySelection.font_padding)

        if i == EnemySelection.selected_menu_item then
            love.graphics.setColor(153 / 255, 153 / 255, 51 / 255, 1)
        else
            love.graphics.setColor(153 / 255, 102 / 255, 51 / 255, 1)
        end

        love.graphics.rectangle("fill", x, y, button_width, button_height)

        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf(EnemySelection.menus[i], x, y + (button_height / 2) - (EnemySelection.font_height / 2),
            button_width, 'center')
    end
end

function EnemySelection.update(dt)
end

function EnemySelection.keypressed(key, go_back_callback)
    if key == 'escape' then
        go_back_callback()
    end
end

function EnemySelection.mousepressed(x, y, start_game_callback, go_back_callback)
    local button_width = 200
    local button_height = 300
    local total_width = (#EnemySelection.menus * button_width) +
        ((#EnemySelection.menus - 1) * EnemySelection.font_padding)
    local start_x = (EnemySelection.window_width - total_width) / 2
    for i = 1, #EnemySelection.menus do
        local button_x = start_x + (i - 1) * (button_width + EnemySelection.font_padding)
        local button_y = EnemySelection.window_height / 2 - (button_height / 2)
        if x > button_x and x < button_x + button_width and y > button_y and y < button_y + button_height then
            local selected = EnemySelection.menus[i]
            if selected == 'Bazman' then
                print('Bazman')
            end
            if selected == 'Lukasko' then
                print('Lukasko')
            end
            start_game_callback(selected)
        end
    end
    if x > 20 and x < 20 + EnemySelection.images.cancel:getWidth() * 2 and y > 20 and y < 20 + EnemySelection.images.cancel:getHeight() * 2 then
        go_back_callback()
    end
end

return EnemySelection
