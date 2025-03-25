local config = require('config')
local GameOver = {}
GameOver.menus = { 'Play again?!', 'Main Menu' }
GameOver.selected_menu_item = 1
GameOver.font_height = 30
GameOver.font_padding = 15
GameOver.window_width = 800
GameOver.window_height = 800 + config.offset

function GameOver.load()
    GameOver.window_width, GameOver.window_height = love.graphics.getDimensions()
    local font = love.graphics.setNewFont(30)
    GameOver.font_height = font:getHeight()
end

function GameOver.draw(player, enemyName, Menu)
    love.graphics.setBackgroundColor(134 / 255, 45 / 255, 89 / 255)
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

    local horizontal_center = GameOver.window_width / 2
    local vertical_center = GameOver.window_height / 2
    local start_y = vertical_center - (GameOver.font_height * (#GameOver.menus / 2))

    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.setNewFont(50)
    love.graphics.printf(enemyName .. " ta chytil!", 0, 150, GameOver.window_width, 'center')
    love.graphics.setNewFont(30)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf("Dotkol si sa " .. player.ballsTouched .. " balls!", 0, 250, GameOver.window_width, 'center')
    for i = 1, #GameOver.menus do
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.rectangle("fill", horizontal_center - 100 - 5,
            start_y + GameOver.font_height * (i - 1) + GameOver.font_padding * (i - 1) - 5,
            210, GameOver.font_height + 10)
        love.graphics.setColor(153 / 255, 102 / 255, 51 / 255, 1)
        love.graphics.rectangle("fill", horizontal_center - 100,
            start_y + GameOver.font_height * (i - 1) + GameOver.font_padding * (i - 1),
            200, GameOver.font_height)
        if i == GameOver.selected_menu_item then
            love.graphics.setColor(153 / 255, 153 / 255, 51 / 255, 1)
        else
            love.graphics.setColor(1, 1, 1, 1)
        end

        love.graphics.printf(GameOver.menus[i], 0,
            start_y + GameOver.font_height * (i - 1) + GameOver.font_padding * (i - 1), GameOver.window_width,
            'center')
    end
end

function GameOver.update(dt, Menu)
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

function GameOver.mousepressed(x, y, start_game_callback, go_to_main_menu_callback)
    local horizontal_center = GameOver.window_width / 2
    local vertical_center = GameOver.window_height / 2
    local start_y = vertical_center - (GameOver.font_height * (#GameOver.menus / 2))
    for i = 1, #GameOver.menus do
        if x > horizontal_center - 100 and x < horizontal_center + 100 and
            y > start_y + GameOver.font_height * (i - 1) + GameOver.font_padding * (i - 1) and
            y < start_y + GameOver.font_height * (i - 1) + GameOver.font_padding * (i - 1) + GameOver.font_height then
            if GameOver.menus[i] == 'Play again?!' then
                start_game_callback()
            elseif GameOver.menus[i] == 'Main Menu' then
                go_to_main_menu_callback()
            end
        end
    end
end

return GameOver
