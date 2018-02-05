local WorldObject = require "src.WorldObject"
local vector = require "src.vector"



local TextBox = WorldObject:extend();

function TextBox.init(self, txt, x, y, other)
    self.istextboxobject = true
    self.text = txt or ""
    self.x, self.y = x or 0, y or 0
    self.options = {}
    if (other) then
        for k,v in pairs(other) do
            self.options[k] = v
        end
    end
end

function TextBox.draw(self)
    local r = self.options.r or 0
    local sx, sy = self.options.sx or 1, self.options.sy or 1
    local ox, oy = self.options.ox or 0, self.options.sy or 0
    local kx, ky = self.options.kx or 0, self.options.ky or 0

    love.graphics.print(self.text, self.x, self.y, r, sx, sy, ox, oy, kx, ky)
end

return TextBox
