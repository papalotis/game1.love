local class = require "src.class"
local Colour = class()

local colour_stack = {}

--https://love2d.org/wiki/HSV_color
local function HSV(h, s, v)
    if s <= 0 then return v,v,v end
    h, s, v = h/256*6, s/255, v/255
    local c = v*s
    local x = (1-math.abs((h%2)-1))*c
    local m,r,g,b = (v-c), 0,0,0
    if h < 1     then r,g,b = c,x,0
    elseif h < 2 then r,g,b = x,c,0
    elseif h < 3 then r,g,b = 0,c,x
    elseif h < 4 then r,g,b = 0,x,c
    elseif h < 5 then r,g,b = x,0,c
    else              r,g,b = c,0,x
    end return (r+m)*255,(g+m)*255,(b+m)*255
end

function Colour.init(self,r,g,b,a, mode)
    self.iscolourobject = true

    mode = mode or "rgb"

    if (mode == "hsv") then r,g,b = HSV(r,g,b) end

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

function Colour.fromHSV(self, h, s, v, a)
    return Colour(h, s, v, a, "hsv")
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

function Colour.setAlpha(self, a)
    self.alpha = a or self.alpha
end

function Colour.setRed(self, r)
    self.red = r or self.red
end

function Colour.setGreen(self, g)
    self.green = g or self.green
end

function Colour.setBlue(self, b)
    self.blue = b or self.blue
end

function Colour.clone(self)
    local r,g,b,a = self.red, self.green, self.blue, self.alpha

    return Colour(r,g,b,a)
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
