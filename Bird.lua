--[[
    Bird Class.
    It is the main character that we control in our game using
    space bar or clicking; whenever we press either, the bird will
    flap and go up a little but, where it will then be affected by 
    gravity. If the bird hits the ground or a pipe, the game is over.
]]

Bird = Class{}

local GRAVITY = 20

function Bird:init()
    self.image = love.graphics.newImage('bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    --position bird in the middle of the screen
    self.x = VIRTUAL_WIDTH/2 - (self.width/2)
    self.y = VIRTUAL_HEIGHT/2 - (self.height/2)

    --velocity in Y direction
    self.dy = 0
end

--[[
    AABB collision that expects a pipe, which will have an X and Y and reference
    global pipe width and height values. 
]]
function Bird:collides(pipe)
    
end

function Bird:update(dt)
    --apply gravity to velocity
    self.dy = self.dy + GRAVITY * dt

    if love.keyboard.wasPressed('space') then
        self.dy = -5
    end

    --apply current velocity to Y position
    self.y = self.y + self.dy
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end