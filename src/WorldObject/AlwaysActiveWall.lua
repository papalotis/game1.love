local Wall = require "src.WorldObject.Wall"

--Wall class, that is not affected by the user changing the active group
--in the game
local AlwaysActiveWall = Wall:extend()

function AlwaysActiveWall.childinit (self)
    self.isalwaysactivewallobject = true
end

function AlwaysActiveWall.update(self)
    self.copied = self.copied or false
    if (not self.copied) then
        self.copied = true
        self.colour = game_colours.light_gray:clone()

    end
    self.active = true
end

return AlwaysActiveWall
