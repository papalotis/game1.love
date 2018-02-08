local WorldObject = require "src.WorldObject"
local vector = require "src.vector"



local TextBox = WorldObject:extend();

function TextBox.init(self, txt, x, y, show_file)
    self.istextboxobject = true
    self.text = txt or ""
    self.x, self.y = x or 0, y or 0
    self.options = {}

    local fun = nil
    if (show_file) then
        local path = love.filesystem.getSource() .. "/levels/conditions/" ..show_file .. ".lua"
        fun = dofile (path)
    end

    self.show_when = fun or function() return true end

end


function TextBox.draw(self)

    if (self.show_when(self)) then
        local r = self.options.r or 0
        local sx, sy = self.options.sx or 1, self.options.sy or 1
        local ox, oy = self.options.ox or 0, self.options.sy or 0
        local kx, ky = self.options.kx or 0, self.options.ky or 0

        love.graphics.print(self.text, self.x, self.y, r, sx, sy, ox, oy, kx, ky)
    end
end

return TextBox
