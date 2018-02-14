local offset = 0

local function update(self)

    self.colour:setAlpha(20)

    self.points = calculatePointsOfPolygon(self.cx, self.cy, self.num_sides, self.side_len, offset)
    offset = offset + 4/1000


end

return update
