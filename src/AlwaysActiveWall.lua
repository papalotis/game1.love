local Wall = require "src.Wall"
local vector = require "src.vector"

--Wall class, that is not affected by the user changing the active group
--in the game
local AlwaysActiveWall = Wall:extend()

function AlwaysActiveWall.update(self)
    self.colour = game_colours.light_gray
    self.active = true
end

return AlwaysActiveWall
