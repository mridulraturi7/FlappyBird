--[[
    Flappy Bird.
    It is a game developed by Dong Nguyen that went viral in 2013, utilizing a very simple
    but effective gameplay mechanic of avoiding pipes indefinitely by just tapping the screen
    or using space key making the player's bird avatar flap its wings and move upwards slightly.
]]

--[[
    push is a library that allows us to draw our game at a
    virtual resolution, instead of however large our window is;
    It is used to provide a more retro look and feel to the game.
    import virtual resolution handling library (push.lua).
]]
push = require 'push'

--[[
    class is a library that will allow us to represent anything in
    our game as code, rather than keeping track of many disparate 
    variables and methods.
    import classic OOP class library (class.lua).
]]
Class = require 'class'

--import Bird class
require 'Bird'

--import Pipe class
require 'Pipe'

--import PipePair class
require 'PipePair'

--all code related to game state and state machines
require 'StateMachine'
require 'states/BaseState'
require 'states/CountdownState'
require 'states/PlayState'
require 'states/ScoreState'
require 'states/TitleScreenState'


--physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

--virtual resolution dimensions
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

--background image and starting scroll location (X - axis)
local backgorund = love.graphics.newImage('images/background.png')
local backgroundScroll = 0

--ground image and starting scroll loaction (X - axis)
local ground = love.graphics.newImage('images/ground.png')
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

--scrolling variable to pause the game when we collide with a pipe
local scrolling = true

function love.load()
    --nearest neighbour filter to avoid blurring.
    love.graphics.setDefaultFilter('nearest', 'nearest')

    --seed the RNG
    math.randomseed(os.time())

    --set game window title
    love.window.setTitle('Flappy Bird')

    --initialize the fonts
    smallFont = love.graphics.newFont('fonts/font.ttf', 8)
    mediumFont = love.graphics.newFont('fonts/flappy.ttf', 14)
    flappyFont = love.graphics.newFont('fonts/flappy.ttf', 28)
    hugeFont = love.graphics.newFont('fonts/flappy.ttf', 56)
    
    love.graphics.setFont(flappyFont)

    --initialize our table of sounds
    sounds = {
        ['jump'] = love.audio.newSource('sounds/jump.wav', 'static'),
        ['explosion'] = love.audio.newSource('sounds/explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('sounds/hurt.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['music'] = love.audio.newSource('sounds/marios_way.mp3', 'static'),

        --https://freesound.org/people/Mrthenoronha/sounds/509856/
        ['pause'] = love.audio.newSource('sounds/pause_music.wav', 'static')
    }

    --play theme music
    sounds['music']:setLooping(true)
    sounds['music']:play()

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    --initialize state machine with all state-returning functions
    gStateMachine = StateMachine{
        ['title'] = function() return TitleScreenState() end,
        ['countdown'] = function() return CountdownState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end
    }
    gStateMachine:change('title')

    --initialize input table
    love.keyboard.keysPressed = {}

    --initialize mouse input table
    love.mouse.buttonsPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    --scroll background by preset speed * dt, looping back to 0 after the looping point
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT

    --scroll ground by preset speed * dt, looping back to 0 after the looping point
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % GROUND_LOOPING_POINT

    --now, we just update the state machine, which defers to the right state
    gStateMachine:update(dt)

    --reset input table
    love.keyboard.keysPressed = {}

    --reset mouse input table
    love.mouse.buttonsPressed = {}
end

function love.keypressed(key)
    --add to table of keys pressed this frame
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end

--[[
    LOVE2D callback function fired each time a mouse button is pressed; gives us the
    X and Y coordinate of the mouse, as well as the button.
]]
function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
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

--[[
    Equivalent to our Keyboard function from before, but foe the mouse buttons.
]]
function love.mouse.wasPressed(button)
    return love.mouse.buttonsPressed[button]
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

    --draw state machine between background and ground, which defers
    --render logic to the currently active state
    gStateMachine:render()

    --draw ground image(in front of background) at bottom of screen
    --at its negative looping point
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    push:finish()
end