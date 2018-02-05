function drawLineStripped(x1,y1, x2, y2, line_len, skip_len)
    local min, sin, cos = math.min, math.sin, math.cos
    local v = (vector(x2,y2) - vector(x1,y1)):toPolar()
    -- love.graphics.line(x1,y1,x2,y2)
    local len = v.y
    local phi = v.x

    local xx, yy = x1, y1

    local counter = 0
    while (len > 0) do
        local move_part = min(len, line_len)

        len = len - move_part - skip_len

        local move_part_x = move_part * sin(phi)
        local move_part_y = move_part * cos(phi)

        next_x = xx + move_part_x
        next_y = yy + move_part_y

        if (counter < 2 or true) then
            love.graphics.line(xx, yy, next_x, next_y)
        end
        xx = next_x + skip_len * sin(phi)
        yy = next_y + skip_len * cos(phi)

        counter = counter + 1

    end

end

function drawRectangleStripped(x,y,w,h,line_len, skip)
    local l = drawLineStripped
    if (w ~= 0) then
        l(x  , y  , x+w, y  , line_len, skip)
        if (h~= 0) then
            l(x+w, y+h, x  , y+h, line_len, skip)
        end
    end
    if (h ~= 0) then
        l(x+w, y  , x+w, y+h, line_len, skip)
        if (w ~= 0) then
            l(x  , y+h, x  , y  , line_len, skip)
        end
    end
end
