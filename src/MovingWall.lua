local Wall = require "src.Wall"
local vector = require "src.vector"

local MovingWall = Wall:extend()

function MovingWall.init(self, x, y, w, h, xdest,ydest, spd, wait)

    self.iswallobject = true
    self.ismovingwallobject = true
    self.pos = vector(x,y)

    self.orig_pos = self.pos:clone()
    self.w = w
    self.h = h
    self.active = true
    xdest = xdest or self.x
    ydest = ydest or self.y - 100
    self.dest = vector(xdest, ydest)
    self.orig_dest = self.dest:clone()

    self.spd = spd or 1
    self.speed = vector(0,0)

    self.group = group or 1

    self.colour = game_colours.light_gray

    self.wait = wait or 60
    self.stop = 0
    self.colour = game_colours.bright_orange

end

function MovingWall.update(self, moving_objects)

    self.stop = self.stop - 1

    local speed = self.dest - self.pos

    local dist = speed:len()

    speed:trimInplace(self.spd)
    self.speed = speed:clone()


    for _,v in pairs(moving_objects) do
        local object_is_touching_from_above = checkCollision(self.pos.x, self.pos.y - 4, self.w ,self.h, v.pos.x, v.pos.y, v.w ,v.h)
        local object_is_touching_from_below = checkCollision(self.pos.x, self.pos.y + 4, self.w ,self.h, v.pos.x, v.pos.y, v.w ,v.h) and speed.y > 0
        local object_is_touching_from_the_left = checkCollision(self.pos.x - 2, self.pos.y, self.w,self.h, v.pos.x, v.pos.y, v.w ,v.h) and speed.x < 0
        local object_is_touching_from_the_right = checkCollision(self.pos.x + 2, self.pos.y, self.w ,self.h, v.pos.x, v.pos.y, v.w ,v.h) and speed.x > 0

        if (object_is_touching_from_below) then
            speed = vector(0,0)
        end


        if (object_is_touching_from_the_left or
            object_is_touching_from_the_right) then
            v.pos.x = v.pos.x + speed.x
        end


        if (object_is_touching_from_above) then

            v.outside_speed = v.outside_speed + vector(speed.x,0)
            v.onplatform = self
        end

    end

    if (self.stop > 0) then return end

    if (dist < self.spd) then
        --swap origin and destination
        --in order to move back to the other
        self.pos = self.dest:clone()
        tmp = self.orig_dest:clone()
        self.orig_dest = self.orig_pos:clone()
        self.orig_pos = tmp:clone()
        self.dest = self.orig_dest:clone()

        --set the timer to as much time as the constructor specified
        self.stop = self.wait
    else

        self.pos = self.pos + speed
    end


end

return MovingWall
