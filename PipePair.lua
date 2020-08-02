--[[
    Pipepair Class.

    It is used to represent a pair of pipes that stck together as they scroll,
    providing an opening for the player to jump through in order to score a point.
]]

PipePair = Class{}

--size of the gap between pipes
local GAP_HEIGHT = 90

function PipePair:init(y)
    --initialize pipes past the end of the screen
    self.x = VIRTUAL_WIDTH + 32

    --y value is for the topmost pipe;
    --gap is a vertical shift of the second lower pipe
    self.y = y
    
    --instantiate two pipes that belong to this pair
    self.pipes = {
        ['upper'] = Pipe('top', self.y),
        ['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + GAP_HEIGHT)
    }

    --whether this pipe is ready to be removed from the scene
    self.remove = false
end