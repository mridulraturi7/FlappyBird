--[[
    Pipe Class.
    The Pipe class represents the pipes that randomly spawn
    in our game, which acts as our primary obstacles. The pipes
    can stick out a random distance from top and bottom of the screen.
    When the player collides with one of them, its game over. Rather
    than our bird atually moving through the screen horizontally, the
    pipes themselves scroll through the game to give the illusion of
    player movement. 
]]

Pipe = Class{}

--since we only want the image loaded once, not per instantiation, define it externally
local PIPE_IMAGE = love.graphics.newImage('pipe.png')

local PIPE_SCROLL = -60

function Pipe:init()
    self.x = VIRTUAL_WIDTH
    
    --set the Y to a random value halfway below the screen
    self.y = math.random(VIRTUAL_HEIGHT/4, VIRTUAL_HEIGHT - 10)

    self.width = PIPE_IMAGE:getWidth()
end

function Pipe:update(dt)
    self.x = self.x + PIPE_SCROLL * dt
end

function Pipe:render()
    love.graphics.render(PIPE_IMAGE, math.floor(self.x + 0.5), math.floor(self.y))
end