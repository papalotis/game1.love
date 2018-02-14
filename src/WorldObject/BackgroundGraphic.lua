local WorldObject = require "src.WorldObject"
local vector = require "src.vector"
local BackgroundGraphic = WorldObject:extend();

function BackgroundGraphic.init(self, mode, cx, cy, num_sides, side_len, colour, fun)
    self.isbackgroundgraphicobject = true
    self.cx = cx
    self.cy = cy
    self.num_sides = num_sides
    self.side_len = side_len



    self.points = calculatePointsOfPolygon(cx, cy, num_sides, side_len, 0)
    self.colour = colour:clone()
    self.mode = mode or "line"

    if (fun) then
        local path = love.filesystem.getSource() .. "levels/graphics_properties/" ..fun .. ".lua"
        local lf = loadfile(path)
        if (lf) then
            self.update = lf()
        else
            print("didn't find a function")
        end

    end

end

function BackgroundGraphic.draw(self)
    self.colour:push()
    love.graphics.polygon(self.mode, self.points)
    self.colour:pop()
end

return BackgroundGraphic
