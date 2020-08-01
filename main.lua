--[[
    Flappy Bird.
    It is a game developed by Dong Nguyen that went viral in 2013, utilizing a very simple
    but effective gameplay mechanicof avoiding pipes indefinitely by just tapping the screen,
    making the player's bird avatar flap its wings and move upwards slightly.
]]

--import virtual resolution handling library
push = require 'push'

--classic OOP class library
Class = require 'class'

--import Bird class
require 'Bird'

--physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

--virtual resolution dimensions
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

--background image and starting scroll location (X - axis)
local backgorund = love.graphics.newImage('background.png')
local backgroundScroll = 0

--ground image and starting scroll loaction (X - axis)
local ground = love.graphics.newImage('ground.png')
local groundScroll = 0

--speed at which we should scroll our images, scaled by dt
local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

--point at which we shuld loop our background back to X = 0
local BACKGROUND_LOOPING_POINT = 413

--our Bird sprite (main character)
local bird = Bird()

function love.load()
    --nearest neighbour filter to avoid blurring.
    love.graphics.setDefaultFilter('nearest', 'nearest')

    --set game window title
    love.window.setTitle('Flappy Bird')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    --scroll background by preset speed * dt, looping back to 0 after the looping point
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT

    --scroll ground by preset speed * dt, looping back to 0 after the screen width passes
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH

    bird:update(dt)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.draw()
    push:start()

    --Parallax Scrolling
    --In this, we draw our images shifted to the left by their looping point;
    --eventually, they will revert back to 0 after a certain distance has elapsed,
    --which will make it seem as if they are infinitely scrolling.
    --Choosing a better looping point is key here so as to provide the illusion of looping. 

    --draw background image the negative looping point
    love.graphics.draw(backgorund, -backgroundScroll, 0)

    --draw ground image(in front of background) at bootom of screen
    --at its negative looping point
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    --render bird to the screen using its own render logic
    bird:render();

    push:finish()
end