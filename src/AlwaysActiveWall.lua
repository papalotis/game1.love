local Wall = require "src.Wall"
local vector = require "src.vector"


local AlwaysActiveWall = Wall:extend()

function AlwaysActiveWall.update(self)
    self.colour = game_colours.light_gray
    self.active = true
end

return AlwaysActiveWall
