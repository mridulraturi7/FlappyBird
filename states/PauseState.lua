--[[
    PauseState Class.

    It is used to pause the game while playing.
]]

PauseState = Class{__includes = BaseState}

function PauseState:update(dt)
    if love.keyboard.wasPressed('p') then
        gStateMachine:change('play')
    end
end

function PauseState:render()
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Game Paused', 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
end