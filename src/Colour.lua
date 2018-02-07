local class = require "src.class"
local Colour = class()

local colour_stack = {}

function Colour.init(self,r,g,b,a)
    self.iscolourobject = true

    if (r and not g and not b and not a) then
        local newr = math.floor(r / 0x10000)
        local newg = math.floor((r % 0x10000) / 0x100)
        local newb = ((r % 0x10000) % 0x100)
        local newa = 0xff
        r, g, b, a = newr, newg, newb, newa
    end


    self.red = r or 0
    self.green = g or 0
    self.blue = b or 0
    self.alpha = a or 255
end

function Colour.push(self)
    if (colour_stack) then
        table.insert(colour_stack,self)
        self:apply()
    end
end

function Colour.pop(self)
    local cs = colour_stack

    assert(#cs > 1, "Attempted to pop the default colour")

    table.remove(cs)
    if (cs[#cs]) then
        cs[#cs]:apply()
    else
        --something if stack is empty
    end

end

function Colour.clone(self)
    local c = Colour()
    for k,v in pairs(self) do
        c[k] = self[k]
    end
end

function Colour.add(self,red,green,blue,alpha)
    self.red = (self.red + (red or 0)) % 256
    self.green = (self.green + (green or 0)) % 256
    self.blue = (self.blue + (blue or 0)) % 256
    self.alpha = (self.alpha + (alpha or 0)) % 256
end

function Colour.inverse(self)
    self.red = 0xff - self.red
    self.green = 0xff - self.green
    self.blue = 0xff - self.blue
end

function Colour.apply(self)
    if (love) then
        love.graphics.setColor(self.red, self.green, self.blue, self.alpha)
    end
end

return Colour
