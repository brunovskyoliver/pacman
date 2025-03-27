local config = require('config')
local NameInput = {}
NameInput.window_width = config.window.width
NameInput.window_height = config.window.height
NameInput.font_height = 30
NameInput.images = {}
NameInput.player_name = ""
NameInput.cursor_visible = true
NameInput.cursor_timer = 0
NameInput.cursor_interval = 0.5

function NameInput.load()
    NameInput.window_width, NameInput.window_height = love.graphics.getDimensions()
    local font = love.graphics.setNewFont(30)
    NameInput.font_height = font:getHeight()
    NameInput.images = { cancel = love.graphics.newImage('assets/cancel.png') }

    local success, content = pcall(function()
        local file = io.open("data/player_name.txt", "r")
        if file then
            local content = file:read("*all")
            file:close()
            return content
        end
        return ""
    end)

    if success and content and content ~= "" then
        NameInput.player_name = content
    end
end

function NameInput.save_name()
    pcall(function()
        local file = io.open("data/player_name.txt", "w")
        if file then
            file:write(NameInput.player_name)
            file:close()
        end
    end)
end

function NameInput.draw(Menu)
    love.graphics.setBackgroundColor(134 / 255, 45 / 255, 89 / 255)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(NameInput.images.cancel, 20, 20, 0, 2, 2)
    love.graphics.setColor(1, 1, 1, 1)
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
    love.graphics.printf("ENTER YOUR NAME", 0, 100, NameInput.window_width, 'center')
    love.graphics.setNewFont(40)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", NameInput.window_width / 2 - 205, 250 - 5, 410, 60)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("fill", NameInput.window_width / 2 - 200, 250, 400, 50)
    love.graphics.setColor(0, 0, 0, 1)
    local display_text = NameInput.player_name
    if NameInput.cursor_visible then
        display_text = display_text .. "|"
    end
    love.graphics.printf(display_text, NameInput.window_width / 2 - 190, 255, 380, 'left')

    love.graphics.setNewFont(30)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", NameInput.window_width / 2 - 105, 350 - 5, 210, 60)
    love.graphics.setColor(153 / 255, 102 / 255, 51 / 255, 1)
    love.graphics.rectangle("fill", NameInput.window_width / 2 - 100, 350, 200, 50)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf("OK", 0, 360, NameInput.window_width, 'center')
end

function NameInput.update(dt, Menu)
    NameInput.cursor_timer = NameInput.cursor_timer + dt
    if NameInput.cursor_timer > NameInput.cursor_interval then
        NameInput.cursor_visible = not NameInput.cursor_visible
        NameInput.cursor_timer = 0
    end
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

function NameInput.textinput(text)
    if #NameInput.player_name < 20 then
        NameInput.player_name = NameInput.player_name .. text
    end
end

function NameInput.keypressed(key, confirm_callback, go_back_callback)
    if key == 'escape' then
        go_back_callback()
    elseif key == 'return' or key == 'kpenter' then
        if NameInput.player_name ~= "" then
            NameInput.save_name()
            confirm_callback(NameInput.player_name)
        end
    elseif key == 'backspace' then
        NameInput.player_name = string.sub(NameInput.player_name, 1, -2)
    end
end

function NameInput.mousepressed(x, y, confirm_callback, go_back_callback)
    if x > 20 and x < 20 + NameInput.images.cancel:getWidth() * 2 and
        y > 20 and y < 20 + NameInput.images.cancel:getHeight() * 2 then
        go_back_callback()
        return
    end

    if x > NameInput.window_width / 2 - 100 and x < NameInput.window_width / 2 + 100 and
        y > 350 and y < 400 then
        if NameInput.player_name ~= "" then
            NameInput.save_name()
            confirm_callback(NameInput.player_name)
        end
    end
end

return NameInput

