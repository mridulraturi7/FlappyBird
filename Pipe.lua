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
local PIPE_IMAGE = love.graphics.newImage('images/pipe.png')

--speed at which the pipe should scroll right to left
PIPE_SPEED = 60

--height & width of the pipe image,
--globally accessible
PIPE_HEIGHT = 288
PIPE_WIDTH = 70

function Pipe:init(orientation, y)
    self.x = VIRTUAL_WIDTH
    self.y = y
    
    self.width = PIPE_IMAGE:getWidth()
    self.height = PIPE_HEIGHT

    self.orientation = orientation
end

function Pipe:update(dt)

end

function Pipe:render()
    --draw pipe as per the orientation
    love.graphics.draw(PIPE_IMAGE, self.x,
        (self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y),
        0, -- Image Rotation
        1, -- Scale in X axis
        self.orientation == 'top' and -1 or 1) -- Scale in Y axis, -1 flips the image
end