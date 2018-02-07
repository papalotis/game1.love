local WorldObject = require "src.WorldObject"
local vector = require "src.vector"

--the generic enemy class
local LevelKey = WorldObject:extend()

function LevelKey.init(self, x, y)
    self.islevelkeyobject = true

    self.pos = vector(x,y)

    self.w = 12
    self.h = self.w
    self.colour = game_colours.dark_blue
    self.collected = false
    self.carrier = nil

end

function LevelKey.update(self, player)
    assert(player and player.isplayerobject, "player must be Player object")

    if (not self.collected) then

        local playerContainsUs = rectContains(player.pos.x, player.pos.y, player.w, player.h, self.pos.x, self.pos.y,self.w,self.h)
        if (playerContainsUs) then
            self.collected = true
            self.carrier = player
            table.insert(player.keys, self)
        end
    else
        -- self.pos = self.carrier.pos:clone() + vector(self.carrier.w/2, self.carrier.h/2) - vector(self.w/2, self.h/2)
    end
end


function LevelKey.draw(self)
    self.colour:push()

    local mode = self.collected and "fill" or "line"

    love.graphics.rectangle(mode, self.pos.x, self.pos.y, self.w, self.h)
    self.colour:pop()
end

return LevelKey
