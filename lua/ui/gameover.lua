local config = require('config')
local GameOver = {}
GameOver.menus = { 'Play again?!', 'Quit' }
GameOver.selected_menu_item = 1
GameOver.font_height = 30
GameOver.window_width = 800
GameOver.window_height = 800 + config.offset

function GameOver.load()
    GameOver.window_width, GameOver.window_height = love.graphics.getDimensions()
    local font = love.graphics.setNewFont(30)
    GameOver.font_height = font:getHeight()
end

function GameOver.draw()
    local horizontal_center = GameOver.window_width / 2
    local vertical_center = GameOver.window_height / 2
    local start_y = vertical_center - (GameOver.font_height * (#GameOver.menus / 2))

    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.setNewFont(50)
    love.graphics.printf("Prehral si!", 0, 150, GameOver.window_width, 'center')
    love.graphics.setNewFont(30)
    for i = 1, #GameOver.menus do
        if i == GameOver.selected_menu_item then
            love.graphics.setColor(1, 1, 0, 1)
        else
            love.graphics.setColor(1, 1, 1, 1)
        end
        love.graphics.printf(GameOver.menus[i], 0, start_y + GameOver.font_height * (i - 1), GameOver.window_width,
            'center')
    end
end

function GameOver.keypressed(key, start_game_callback)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'up' then
        GameOver.selected_menu_item = GameOver.selected_menu_item - 1
        if GameOver.selected_menu_item < 1 then
            GameOver.selected_menu_item = #GameOver.menus
        end
    elseif key == 'down' then
        GameOver.selected_menu_item = GameOver.selected_menu_item + 1
        if GameOver.selected_menu_item > #GameOver.menus then
            GameOver.selected_menu_item = 1
        end
    elseif key == 'return' or key == 'kpenter' then
        if GameOver.menus[GameOver.selected_menu_item] == 'Play again?!' then
            start_game_callback()
        elseif GameOver.menus[GameOver.selected_menu_item] == 'Quit' then
            love.event.quit()
        end
    end
end

return GameOver
