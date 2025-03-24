local config = require('config')
local Menu = {}
Menu.menus = { 'Play', 'Quit' }
Menu.selected_menu_item = 1
Menu.font_height = 30
Menu.window_width = 800
Menu.window_height = 800 + config.offset
Menu.pacman = {}

function Menu.load()
    Menu.window_width, Menu.window_height = love.graphics.getDimensions()
    local font = love.graphics.setNewFont(30)
    Menu.font_height = font:getHeight()
    Menu.pacman.image = love.graphics.newImage('assets/pacman.png')
    Menu.pacman.scale = 0.1
    Menu.pacman.width = Menu.pacman.image:getWidth() * Menu.pacman.scale
    Menu.pacman.height = Menu.pacman.image:getHeight() * Menu.pacman.scale
    Menu.pacman.x = love.math.random() * Menu.window_width
    Menu.pacman.y = love.math.random() * Menu.window_height
    Menu.pacman.angle = love.math.random() * 2 * math.pi
    Menu.pacman.speed = 100
end

function Menu.draw()
    local horizontal_center = Menu.window_width / 2
    local vertical_center = Menu.window_height / 2
    local start_y = vertical_center - (Menu.font_height * (#Menu.menus / 2))

    love.graphics.draw(
        Menu.pacman.image,
        Menu.pacman.x + Menu.pacman.width / 2,
        Menu.pacman.y + Menu.pacman.height / 2,
        Menu.pacman.angle,
        Menu.pacman.scale,
        Menu.pacman.scale,
        Menu.pacman.image:getWidth() / 2,
        Menu.pacman.image:getHeight() / 2
    )
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

function Menu.update(dt)
    Menu.pacman.x = Menu.pacman.x + math.cos(Menu.pacman.angle) * Menu.pacman.speed * dt
    Menu.pacman.y = Menu.pacman.y + math.sin(Menu.pacman.angle) * Menu.pacman.speed * dt
    if Menu.pacman.x < 0 then
        Menu.pacman.x = 0
        Menu.pacman.angle = math.pi - Menu.pacman.angle
    elseif Menu.pacman.x + Menu.pacman.width > Menu.window_width then
        Menu.pacman.x = Menu.window_width - Menu.pacman.width
        Menu.pacman.angle = math.pi - Menu.pacman.angle
    elseif Menu.pacman.y < 0 then
        Menu.pacman.y = 0
        Menu.pacman.angle = -Menu.pacman.angle
    elseif Menu.pacman.y + Menu.pacman.height > Menu.window_height then
        Menu.pacman.y = Menu.window_height - Menu.pacman.height
        Menu.pacman.angle = -Menu.pacman.angle
    end
    Menu.pacman.angle = Menu.pacman.angle % (2 * math.pi)
end

function Menu.keypressed(key, start_game_callback)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'up' then
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
