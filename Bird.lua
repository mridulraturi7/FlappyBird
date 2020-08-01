--[[
    Bird Class.
    It is the main character that we control in our game using
    space bar or clicking; whenever we press either, the bird will
    flap and go up a little but, where it will then be affected by 
    gravity. If the bird hits the ground or a pipe, the game is over.
]]

Bird = Class{}

function Bird:init()
    self.image = love.graphics.newImage('')
end