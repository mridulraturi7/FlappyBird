--[[
    Flappy Bird.
    It is a game developed by Dong Nguyen that went viral in 2013, utilizing a very simple
    but effective gameplay mechanicof avoiding pipes indefinitely by just tapping the screen,
    making the player's bird avatar flap its wings and move upwards slightly.
]]

--import virtual resolution handling library
push = require 'push'

--physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

--virtual resolution dimensions
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

--background and foreground images to render on screen
local backgorund = love.graphics.newImage('background.png')
local ground = love.graphics.newImage('ground.png')

function love.load()
    --nearest neighbour filter to avoid blurring.
    love.graphics.setDefaultFilter('nearest', 'nearest')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.draw()
    push:start()

    --draw background image at top left(0, 0)
    love.graphics.draw(backgorund, 0, 0)

    --draw ground image(in front of background) at bootom of screen
    love.graphics.draw(ground, 0, VIRTUAL_HEIGHT - 16)

    push:finish()
end