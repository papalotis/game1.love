local WorldObject = require "src.WorldObject"
local vector = require "src.vector"
local Wall = WorldObject:extend();

function Wall.init(self, x, y, w, h, group)
    self.iswallobject = true
    self.pos = vector(x,y)
    self.w = w
    self.h = h
    self.active = true

    self.group = group or 1
end

function Wall.update(self, globalGroup, colours)

    self.colour = colours[self.group]

    self.active = self.group == globalGroup

end

function Wall.draw(self)
    if (not self.colour) then
        self.colour = game_colours.light_gray
    end
    self.colour:push()
    if (self.active) then
        -- love.graphics.rectangle("line", self.pos.x, self.pos.y, self.w, self.h)
        drawRectangleStripped(self.pos.x, self.pos.y, self.w, self.h, 1000, 0)
    else
        drawRectangleStripped(self.pos.x, self.pos.y, self.w, self.h, 5, 7)
    end
    self.colour:pop()
end

return Wall
