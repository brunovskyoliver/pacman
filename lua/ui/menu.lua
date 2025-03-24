local Menu = {}
Menu.menus = { 'Play', 'Quit' }
Menu.selected_menu_item = 1
Menu.font_height = 30
Menu.window_width = 800
Menu.window_height = 800

function Menu.load()
    Menu.window_width, Menu.window_height = love.graphics.getDimensions()
    local font = love.graphics.setNewFont(30)
    Menu.font_height = font:getHeight()
end

function Menu.draw()
    local horizontal_center = Menu.window_width / 2
    local vertical_center = Menu.window_height / 2
    local start_y = vertical_center - (Menu.font_height * (#Menu.menus / 2))

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf("Bazman", 0, 150, Menu.window_width, 'center')

    for i = 1, #Menu.menus do
        if i == Menu.selected_menu_item then
            love.graphics.setColor(1, 1, 0, 1)
        else
            love.graphics.setColor(1, 1, 1, 1)
        end
        love.graphics.printf(Menu.menus[i], 0, start_y + Menu.font_height * (i - 1), Menu.window_width, 'center')
    end
end

function Menu.keypressed(key, start_game_callback)
    -- if key == 'escape' then
    --     love.event.quit()
    if key == 'up' then
        Menu.selected_menu_item = Menu.selected_menu_item - 1
        if Menu.selected_menu_item < 1 then
            Menu.selected_menu_item = #Menu.menus
        end
    elseif key == 'down' then
        Menu.selected_menu_item = Menu.selected_menu_item + 1
        if Menu.selected_menu_item > #Menu.menus then
            Menu.selected_menu_item = 1
        end
    elseif key == 'return' or key == 'kpenter' then
        if Menu.menus[Menu.selected_menu_item] == 'Play' then
            start_game_callback()
        elseif Menu.menus[Menu.selected_menu_item] == 'Quit' then
            love.event.quit()
        end
    end
end

return Menu
