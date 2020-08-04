--[[
    ScoreState Class.

    A simple state used to display the player's score before they
    transition back into the play state. Transitioned to Score State
    from the Play State when they collide with a Pipe.
]]

ScoreState = Class{__includes = BaseState}

--[[
    When we enter the score state, we expect to receive the score from
    the play state so we know what to render to the state.
]]
function ScoreState:enter(params)
    self.score = params.score

    self.medals = {
        ['gold'] = love.graphics.newImage('images/gold.png'),
        ['silver'] = love.graphics.newImage('images/silver.png'),
        ['bronze'] = love.graphics.newImage('images/bronze.png')
    }
end

function ScoreState:update(dt)
    --go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play')
    end
end

function ScoreState:render()
    --simply render the score to the middle of the screen
    love.graphics.setFont(flappyFont)
    love.graphics.printf('OOPS! You Lost!', 0, 24, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 60, VIRTUAL_WIDTH, 'center')

    love.graphics.printf('Press Enter to Play Again!', 0, 236, VIRTUAL_WIDTH, 'center')
end