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

    --initialize medal table with medal images based on score
    self.medals = {
        ['gold'] = love.graphics.newImage('images/gold.png'),
        ['silver'] = love.graphics.newImage('images/silver.png'),
        ['bronze'] = love.graphics.newImage('images/bronze.png')
    }
end

function ScoreState:update(dt)
    --go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    --simply render the score to the middle of the screen
    love.graphics.setFont(flappyFont)
    love.graphics.printf('OOPS! You Lost!', 0, 24, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 60, VIRTUAL_WIDTH, 'center')

    --display medal as per the score of the player
    if self.score >= 20 then
        love.graphics.draw(self.medals['gold'], 206, 88)
    elseif self.score >= 10 then
        love.graphics.draw(self.medals['silver'], 206, 88)
    else 
        love.graphics.draw(self.medals['bronze'], 206, 88)
    end

    love.graphics.printf('Press Enter to Play Again!', 0, 236, VIRTUAL_WIDTH, 'center')
end