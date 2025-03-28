local config = require('config')
local Settings = {}
Settings.menus = { 'Toggle Music', 'Toggle Fullscreen' }
Settings.font_height = 30
Settings.font_padding = 15
Settings.window_width = config.window.width
Settings.window_height = config.window.height
Settings.pacman = {}
Settings.settings = {}

function Settings.load()
    Settings.window_width, Settings.window_height = love.graphics.getDimensions()
    local font = love.graphics.setNewFont(30)
    Settings.font_height = font:getHeight()
    Settings.pacman.image = love.graphics.newImage('assets/pacman.png')
    Settings.pacman.scale = 0.1
    Settings.pacman.width = Settings.pacman.image:getWidth() * Settings.pacman.scale
    Settings.pacman.height = Settings.pacman.image:getHeight() * Settings.pacman.scale
    Settings.pacman.x = love.math.random() * Settings.window_width
    Settings.pacman.y = love.math.random() * Settings.window_height
    Settings.pacman.angle = love.math.random() * 2 * math.pi
    Settings.pacman.speed = 200
    Settings.images = { cancel = love.graphics.newImage('assets/cancel.png') }
end

function Settings.draw(Menu)
    love.graphics.setBackgroundColor(134 / 255, 45 / 255, 89 / 255)
    local horizontal_center = Settings.window_width / 2
    local vertical_center = Settings.window_height / 2
    local start_y = vertical_center - (Settings.font_height * (#Settings.menus / 2))
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(Settings.images.cancel, 20, 20, 0, 2, 2)
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
    love.graphics.setNewFont(50)
    love.graphics.printf("Settings", 0, 150, Settings.window_width, 'center')

    love.graphics.setNewFont(30)
    local buttonFont = love.graphics.getFont()
    local maxTextWidth = 0

    for i = 1, #Settings.menus do
        local textWidth = buttonFont:getWidth(Settings.menus[i])
        if textWidth > maxTextWidth then
            maxTextWidth = textWidth
        end
    end

    local buttonPadding = 40
    local buttonWidth = maxTextWidth + buttonPadding * 2

    for i = 1, #Settings.menus do
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.rectangle("fill",
            horizontal_center - buttonWidth / 2 - 5,
            start_y + Settings.font_height * (i - 1) + Settings.font_padding * (i - 1) - 5,
            buttonWidth + 10, Settings.font_height + 10)

        love.graphics.setColor(153 / 255, 102 / 255, 51 / 255, 1)
        love.graphics.rectangle("fill",
            horizontal_center - buttonWidth / 2,
            start_y + Settings.font_height * (i - 1) + Settings.font_padding * (i - 1),
            buttonWidth, Settings.font_height)

        love.graphics.setColor(1, 1, 1, 1)

        love.graphics.printf(Settings.menus[i], 0,
            start_y + Settings.font_height * (i - 1) + Settings.font_padding * (i - 1),
            Settings.window_width, 'center')
    end
end

function Settings.update(dt, Menu)
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

function Settings.keypressed(key, go_back_callback)
    if key == 'escape' then
        go_back_callback()
    end
end

function Settings.mousepressed(x, y, go_back_callback)
    local horizontal_center = Settings.window_width / 2
    local vertical_center = Settings.window_height / 2
    local start_y = vertical_center - (Settings.font_height * (#Settings.menus / 2))

    if x > 20 and x < 20 + Settings.images.cancel:getWidth() * 2 and
        y > 20 and y < 20 + Settings.images.cancel:getHeight() * 2 then
        go_back_callback()
        return
    end

    local buttonFont = love.graphics.newFont(30)
    local maxTextWidth = 0

    for i = 1, #Settings.menus do
        local textWidth = buttonFont:getWidth(Settings.menus[i])
        if textWidth > maxTextWidth then
            maxTextWidth = textWidth
        end
    end

    local buttonPadding = 40
    local buttonWidth = maxTextWidth + buttonPadding * 2

    for i = 1, #Settings.menus do
        if x > horizontal_center - buttonWidth / 2 and
            x < horizontal_center + buttonWidth / 2 and
            y > start_y + Settings.font_height * (i - 1) + Settings.font_padding * (i - 1) and
            y < start_y + Settings.font_height * (i - 1) + Settings.font_padding * (i - 1) + Settings.font_height then
            if Settings.menus[i] == 'Toggle Music' then
                love.audio.setVolume(love.audio.getVolume() == 0 and 1 or 0)
            elseif Settings.menus[i] == 'Toggle Fullscreen' then
                local fullscreen = not love.window.getFullscreen()

                if fullscreen then
                    Settings.previousWidth = love.graphics.getWidth()
                    Settings.previousHeight = love.graphics.getHeight()

                    love.window.setFullscreen(true, "desktop")
                else
                    love.window.setFullscreen(false)
                    if Settings.previousWidth and Settings.previousHeight then
                        love.window.setMode(Settings.previousWidth, Settings.previousHeight)
                    end
                end

                local w, h = love.graphics.getDimensions()
                love.resize(w, h)
            end

            return
        end
    end
end

return Settings
