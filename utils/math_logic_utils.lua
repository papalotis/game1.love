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


function sign(n)
    if (n > 0) then return  1 end
    if (n < 0) then return -1 end
    return 0
end

function collidesWithAnyWall(x,y,w,h, walls)
    walls = walls or l.world
    for _,elem in pairs(l.world) do
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
    return nil
end

function curry(f) return function (x) return function (y) return f(x,y) end end end

function compose(f, g) return function(...) return f(g(...)) end end

return {boolToInt = boolToInt,
        checkCollision = checkCollision,
        rectContains = rectContains,
        sign = sign,
        collidesWithAnyWall = collidesWithAnyWall,
        curry = curry,
        compose = compose
       }
