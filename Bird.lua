--[[
    Bird Class.
    It is the main character that we control in our game using
    space bar or clicking; whenever we press either, the bird will
    flap and go up a little but, where it will then be affected by 
    gravity. If the bird hits the ground or a pipe, the game is over.
]]

Bird = Class{}

function Bird:init()
    self.image = love.graphics.newImage('bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    --position bird in the middle of the screen
    self.x = VIRTUAL_WIDTH/2 - (self.width/2)
    self.y = VIRTUAL_HEIGHT/2 - (self.height/2)
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end