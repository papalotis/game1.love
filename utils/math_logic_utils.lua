function boolToInt(b)
    if (b) then return 1 end
    return 0
end



--returns true if twp rectangles overlap
function checkCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

--returns true if rect2 is completely contained within
--rect1 (no overlap)
function rectContains(x1, y1, w1, h1,  x2, y2, w2, h2)
    return x2 + w2 < x1 + w1 and x2 > x1 and y2 > y1 and y2 + h2 < y1 + h1
end

function circleCollidesWithRectanle(cx,cy,cr,rl,rt,rw,rh)

        local rect_center_x = rl + rw/2
        local rect_center_y = rt + rh/2

        --get the distance from the center of the circle to the
        --top left edge of te player
        circleDistance_x = math.abs(cx - rect_center_x)
        circleDistance_y = math.abs(cy - rect_center_y)

        --if the distance is more than the width of the player + the radius
        --then there is not an overlap
        if (circleDistance_x > (rw/2 + cr)) then return false end
        --same for y axis
        if (circleDistance_y > (rh/2 + cr)) then return false end

        --if the distance from the center to the
        if (circleDistance_x <= (rw)) then return true end
        if (circleDistance_y <= (rh)) then return true end

        local cornerDistance_sq = math.pow(circleDistance_x - rw , 2) +
                             math.pow(circleDistance_y - rh , 2);

        return (cornerDistance_sq <= cr * cr);

end

function calculatePointsOfPolygon (cx, cy, num, len, offset)
    local points = {}

    local inc = 2 * math.pi / num
    for i = 0, 2 * math.pi, inc do
        table.insert(points, cx + math.cos(i + offset) * len)
        table.insert(points, cy + math.sin(i + offset) * len)
    end

    return points
end


function sign(n)
    if (n > 0) then return  1 end
    if (n < 0) then return -1 end
    return 0
end

function collidesWithAnyWall(x,y,w,h, walls)
    walls = walls or (l and l.world or nil)

    if (walls) then
        for _,elem in pairs(walls) do
            if (elem.iswallobject and elem.active) then
                local r = nil
                --wall properties
                wx, wy, ww, wh =  elem.pos.x, elem.pos.y, elem.w, elem.h
                --if we overlap with a wall
                if (checkCollision(x,y,w,h, wx, wy, ww, wh)) then
                        r = elem
                        --if we are completely inside
                        if (rectContains(wx, wy, ww, wh, x,y,w,h)) then
                            r = nil
                        end
                end
                if (r) then return r end
            end
        end
    end
    return nil
end

function collidesWithAnyWallCircle(cx,cy,cr, walls)
    walls = walls or (l and l.world or nil)

    if (walls) then
        for _,elem in pairs(walls) do
            if (elem.iswallobject and elem.active) then
                local r = nil
                --wall properties
                wx, wy, ww, wh =  elem.pos.x, elem.pos.y, elem.w, elem.h
                --if we overlap with a wall
                if (circleCollidesWithRectanle(cx,cy,cr, wx, wy, ww, wh)) then
                        r = elem
                        --if we are completely inside
                        if (rectContains(wx, wy, ww, wh, cx - cr,cy - cr,cr,cr)) then
                            r = nil
                        end
                end
                if (r) then return r end
            end
        end
    end
    return nil
end

function constraint(val, min, max)
    return math.max(min, math.min(val, max))
end

function curry(f) return function (x) return function (y) return f(x,y) end end end

function compose(f, g) return function(...) return f(g(...)) end end

return {boolToInt = boolToInt,
        checkCollision = checkCollision,
        rectContains = rectContains,
        sign = sign,
        circleCollidesWithRectanle = circleCollidesWithRectanle,
        collidesWithAnyWall = collidesWithAnyWall,
        constraint = constraint,
        curry = curry,
        compose = compose
       }
