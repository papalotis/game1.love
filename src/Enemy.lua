local WorldObject = require "src.WorldObject"
local vector = require "src.vector"

Enemy = WorldObject:extend()

function Enemy.init(self, x, y, r, xspd, yspd)
    self.isenemyobject = true
    self.max_speed = (xspd and xspd > 2) and xspd or 2

    self.r = r or 30
    self.distToCenter = self.r --math.sqrt(2) * self.r

    local posx = x - self.distToCenter
    local posy = y - self.distToCenter
    self.w = 2 * self.r
    self.h = self.w
    self.pos = vector(posx, posy)

    self.speed = vector(xspd or self.max_speed, yspd or 0)
    -- self.acc = vector(0,0)
    self.colour = game_colours.bright_green

    self.onplatform = nil
    self.outside_speed = vector(0,0)



    self.angle = - math.pi / 2
end

function Enemy.makeDecisions(self)

end



function Enemy.update(self, player, gravity)

    if (self.onplatform) then
        self.pos.y = self.onplatform.pos.y - self.h
    else
        self:applyGravity(gravity)
    end

    self.speed = self.speed + self.outside_speed

    local newpos = self.pos + self.speed
    local applied_speed = self:moveToPos(newpos.x, newpos.y)
    self.speed  = self.speed - self.outside_speed

    applied_speed = applied_speed - self.outside_speed
    local move_angle = applied_speed:toPolar().x / 30 * self.speed:len()
    self.angle = (self.angle + move_angle) % (2 * math.pi)

    --check if there is a wall to the right of us
    if (collidesWithAnyWall(self.pos.x + 1, self.pos.y, self.w, self.h)) then
        --if so move tp the left
        self.speed.x = - self.speed:len()
    end

    if (collidesWithAnyWall(self.pos.x - 1, self.pos.y, self.w, self.h)) then
        self.speed.x =   self.max_speed
    end

    self.onplatform = nil
    self.outside_speed = vector(0,0)

    local collision = false
    if (player) then
        collision = self:collideWithPlayer(player)
    end

    return collision



end

function Enemy.moveToPos(self, x, y)
    local min, cos, sin = math.min, math.cos, math.sin
    --move horizontaly pixel for pixel while checking for collisions
    local speedCopy = self.speed:clone():toPolar()
    local speedLen = speedCopy.y
    local phi = speedCopy.x
    --while we haven't moved all the way we can
    local moved_x = self.pos.x
    while (speedLen > 0) do
        local move_part = min(speedLen, 1)

        speedLen = speedLen - move_part

        local move_part_x = move_part * sin(phi)

        --check if we would collide in the new position
        local wall = collidesWithAnyWall(self.pos.x + move_part_x, self.pos.y, self.w, self.h)
        --we collided horizontaly with a wall
        if (wall) then
            --kill our horizontal speed and break out of the move loop
            self.speed = vector(0, self.speed.y)
            break
        else
            self.pos.x = self.pos.x + move_part_x
        end

    end

    moved_x = self.pos.x - moved_x

    --vertical movement
    speedLen = speedCopy.y
    local moved_y = self.pos.y
    while (speedLen > 0) do
        local move_part = min(speedLen, 1)

        speedLen = speedLen - move_part

        local move_part_y = move_part * cos(phi)

        --check if we would collide in the new position
        local wall = collidesWithAnyWall(self.pos.x, self.pos.y + move_part_y, self.w, self.h)
        --we collided vertically with a wall
        if (wall) then
            --kill our vertical speed and break out of the move loop
            self.speed = vector(self.speed.x, 0)
            break
        else
            self.pos.y = self.pos.y + move_part_y
        end

    end

    moved_y = self.pos.y - moved_y

    return vector(moved_x, moved_y)

end

function Enemy.collideWithPlayer(self, player)

    local r = self.r
    local center_x = self.pos.x + r
    local center_y = self.pos.y + r

    local circleDistance = vector(0,0)
    circleDistance.x = math.abs(center_x - player.pos.x);
    circleDistance.y = math.abs(center_y - player.pos.y);

    if (circleDistance.x > (player.w + self.r)) then return false end
    if (circleDistance.y > (player.h + self.r)) then return false end

    if (circleDistance.x <= (player.w)) then return true end
    if (circleDistance.y <= (player.h)) then return true end

    local cornerDistance_sq = math.pow(circleDistance.x - player.w , 2) +
                         math.pow(circleDistance.y - player.h , 2);

    return (cornerDistance_sq <= r * r);
end


function Enemy.applyGravity(self, grav)
    self.speed.y = self.speed.y + grav
end

function Enemy.draw(self)
    local circle = love.graphics.circle
    local line = love.graphics.line
    local sin, cos = math.sin, math.cos

    local r = self.r
    local center_x = self.pos.x + r
    local center_y = self.pos.y + r


    self.colour:push()

    local prev_width = love.graphics.getLineWidth()
    local line_width = 3/50 * r
    love.graphics.setLineWidth(line_width)

    local radius_to_draw = r - line_width

    circle("line",center_x, center_y, radius_to_draw, r)


    line(center_x, center_y, center_x + cos(self.angle) * radius_to_draw, center_y + sin(self.angle) * radius_to_draw)


    love.graphics.setLineWidth(prev_width)
    self.colour.pop()
    -- love.graphics.rectangle("line", self.pos.x, self.pos.y, self.w, self.h)

end

return Enemy
