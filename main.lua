--[[
    Flappy Bird.
    It is a game developed by Dong Nguyen that went viral in 2013, utilizing a very simple
    but effective gameplay mechanic of avoiding pipes indefinitely by just tapping the screen
    or using space key making the player's bird avatar flap its wings and move upwards slightly.
]]

--import virtual resolution handling library
push = require 'push'

--classic OOP class library
Class = require 'class'

--import Bird class
require 'Bird'

--import Pipe class
require 'Pipe'

--import PipePair class
require 'PipePair'


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

--point at which we should loop our background back to X = 0
local BACKGROUND_LOOPING_POINT = 413

--point at which we should loop our ground back to X = 0
local GROUND_LOOPING_POINT = 514

--our Bird sprite (main character)
local bird = Bird()

--table of spawning PipePairs
local pipePairs = {}

--timer for spawning pipes
local spawnTimer = 0

--initialize our last recorded Y value for a gap placement to base other gaps off of
local lastY = -PIPE_HEIGHT + math.random(80) + 20

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

    --initialize input table
    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    --scroll background by preset speed * dt, looping back to 0 after the looping point
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT

    --scroll ground by preset speed * dt, looping back to 0 after the looping point
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % GROUND_LOOPING_POINT

    spawnTimer = spawnTimer + dt

    --spawn a new PipePair if the timer is past 2 seconds
    if spawnTimer > 2 then
        --modify the last Y coordinate we placed so pipe gaps aren't too far apart
        --no higher than 10 pixels below the top edge of the screen,
        --and no lower than a gap length (90 pixels) from the bottom
        local y = math.max(-PIPE_HEIGHT + 10,
            math.min(lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
        lastY = y
        
        table.insert(pipePairs, PipePair(y))
        spawnTimer = 0
    end

    --update the bird for input and gravity
    bird:update(dt)

    --for every pipe in the scene
    for k, pair in pairs(pipePairs) do
        pair:update(dt)
    end

    --remove any falgged pipes
    --we need this second loop, rather than deleting in the previous loop, because
    --modifying the table in-place without explicit keys will result in skipping the
    --next pipe, since all implicit keys (numerical indices) are automatically shifted
    --down after a table removal
    for k, pair in pairs(pipePairs) do
        if pair.remove then
            table.remove(pipePairs, k)
        end
    end

    --reset input table
    love.keyboard.keysPressed = {}
end

function love.keypressed(key)
    --add to table of keys pressed this frame
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end

--[[
    New function used to check our global input table for keys we activated during
    this frame, looked up by their string value.
]]
function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.draw()
    push:start()

    --Parallax Scrolling
    --In this, we draw our images shifted to the left by their looping point;
    --eventually, they will revert back to 0 after a certain distance has elapsed,
    --which will make it seem as if they are infinitely scrolling.
    --Choosing a better looping point is key here so as to provide the illusion of looping. 

    --draw background image at the negative looping point
    love.graphics.draw(backgorund, -backgroundScroll, 0)

    --render all the pipe pairs in our scene
    for k, pair in pairs(pipePairs) do
        pair:render()
    end

    --draw ground image(in front of background) at bottom of screen
    --at its negative looping point
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    --render bird to the screen using its own render logic
    bird:render()

    push:finish()
end