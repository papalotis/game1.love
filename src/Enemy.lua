local WorldObject = require "src.WorldObject"
local vector = require "src.vector"

--the generic enemy class
local Enemy = WorldObject:extend()

function Enemy.init(self, x, y, r, xspd, yspd)
    self.isenemyobject = true

    --the maximum horizontal speed
    self.max_speed = (xspd and xspd > 2) and xspd or 2

    --the radius of the circle
    self.r = r or 30
    self.distToCenter = self.r

    --positiion is the top left corner of the squere that
    --has width r
    local posx = x - r
    local posy = y - r
    self.w = 2 * self.r
    self.h = self.w
    self.pos = vector(posx, posy)


    self.speed = vector(xspd or self.max_speed, yspd or 0)

    self.colour = game_colours.bright_green

    --whether the enemy is on a moving platform/wall
    self.onplatform = nil

    --variable that is used for moving on platform
    self.outside_speed = vector(0,0)

    --the angle at which the enemy is at, used for drawing
    self.angle = - math.pi / 2
end

function Enemy.makeDecisions(self)

end



function Enemy.update(self, player, gravity)

    --if the enemy is on a moving platform, then
    --we don't want gravity to affect, just go with the platform
    if (self.onplatform) then
        self.pos.y = self.onplatform.pos.y - self.h

    --otherwise apply gravity
    else
        self:applyGravity(gravity)
    end

    local speedPrev = self.speed:clone()

    --apply the horizontal speed by possible moving platforms
    self.speed = self.speed + self.outside_speed

    --where we want to go, is wherer we are + our speed
    local oldpos = self.pos:clone()
    local newpos = self.pos + self.speed
    --move there, and find how much we actually moved
    local applied_speed = self:moveToPos(newpos.x, newpos.y)
    --and remove the outside speed, it is only used for affecting the position
    self.speed  = self.speed - self.outside_speed
    --also adjust the applied speed
    applied_speed = applied_speed - self.outside_speed

    --calculate the angle difference : delta_theta = delta_sigma / radius
    local delta_angle = (oldpos.x - self.pos.x)/self.r

    --rotate and cap at 360deg/ 2pi
    self.angle = (self.angle - delta_angle) % (2 * math.pi)

    --check if there is a wall to the right of us
    if (collidesWithAnyWall(self.pos.x + 1, self.pos.y, self.w, self.h)) then
        --if so move tp the left
        self.speed.x = -math.abs(speedPrev.x)
    end
    --same for left to us
    if (collidesWithAnyWall(self.pos.x - 1, self.pos.y, self.w, self.h)) then
        self.speed.x = math.abs(speedPrev.x)
    end

    --assume that the next tick we won't be on a platform
    self.onplatform = nil
    --so the outside speed can be 0
    self.outside_speed = vector(0,0)

    --check if we collide with the player, only if there is a player to collide with
    local collision = false
    if (player) then
        collision = self:collideWithPlayer(player)
    end

    --tell the game if we collided or not
    return collision



end

--method that attempts to move an enemy from \
--one position to another. if the enemy hits a wall while
--moving then it stops moving
function Enemy.moveToPos(self, x, y)

    local min, cos, sin = math.min, math.cos, math.sin

    --move horizontaly pixel for pixel while checking for collisions
    local speedCopy = self.speed:clone():toPolar()
    --get the lenght of the speed
    local speedLen = speedCopy.y
    --get at which angle we should move
    local phi = speedCopy.x
    --while we haven't moved all the way we can

    --store where we were before moving
    local start_pos_x = self.pos.x

    --while we should still move
    while (speedLen > 0) do
        --get by how much we will move
        --at most it should be one (1) pixel
        local move_part = min(speedLen, 1)

        --decrease how much we still need to move
        --by how much we will move this iteration
        speedLen = speedLen - move_part

        --get how much we should move horizontaly
        --by multiplying with sin
        local move_part_x = move_part * sin(phi)

        local newcx, newcy = self.pos.x + self.r + move_part_x, self.pos.y + self.r

        --check if we would collide in the new position
        local wall = collidesWithAnyWallCircle(newcx, newcy, self.r)

        --we collided horizontaly with a wall
        if (wall) then
            --kill our horizontal speed and break out of the move loop
            self.speed.x = 0
            --we won't move anymore so we can exit the loop
            break

        --otherwise move by how much we have calculated
        else
            self.pos.x = self.pos.x + move_part_x
        end

    end

    --get how much we moved by subtracting our old pos from the new one
    local moved_x = self.pos.x - start_pos_x

    --vertical movement (similar to horizontal only on the y axis)
    --get how much we should move
    speedLen = speedCopy.y
    --store where we are
    local start_pos_y = self.pos.y
    while (speedLen > 0) do
        local move_part = min(speedLen, 1)

        speedLen = speedLen - move_part

        --get how much we should mpve vertically by
        --multiplying with cos
        local move_part_y = move_part * cos(phi)

        local newcx, newcy = self.pos.x + self.r, self.pos.y + self.r + move_part_y

        --check if we would collide in the new position
        local wall = collidesWithAnyWallCircle(newcx, newcy, self.r)
        --we collided vertically with a wall
        if (wall) then
            --kill our vertical speed and break out of the move loop
            self.speed.y = 0
            break
        else
            self.pos.y = self.pos.y + move_part_y
        end

    end

    local moved_y = self.pos.y - start_pos_y

    return vector(moved_x, moved_y)

end

--this method retruns true if the argument player
--is inside the cicle of the enemy
function Enemy.collideWithPlayer(self, player)

    if (not player) then return false end

    local r = self.r
    local center_x = self.pos.x + r
    local center_y = self.pos.y + r

    return circleCollidesWithRectanle(center_x, center_y, r, player.pos.x, player.pos.y, player.w, player.h)

end


function Enemy.applyGravity(self, grav)
    self.speed.y = self.speed.y + grav
end

--draws the enemy
function Enemy.draw(self)
    local circle = love.graphics.circle
    local line = love.graphics.line
    local setWidth = love.graphics.setLineWidth
    local sin, cos = math.sin, math.cos

    local r = self.r
    local center_x = self.pos.x + r
    local center_y = self.pos.y + r



    self.colour:push()

    local prev_width = love.graphics.getLineWidth()
    local line_width = 3/50 * r
    --there is a bug in love and a circle of line_width 0.6 is not drawn
    line_width = line_width ~= 0.6 and line_width or 0.61

    setWidth(line_width)

    --calculate a smaller radius so that the outer edge
    --of the drawn line matches with the outer collision edge
    local radius_to_draw = r - line_width

    circle("line",center_x, center_y, radius_to_draw, r)

    --draw a line with the rotation angle so that it is obvious that
    --the enemy is rotating
    line(center_x, center_y, center_x + cos(self.angle) * radius_to_draw, center_y + sin(self.angle) * radius_to_draw)


    setWidth(prev_width)

    -- love.graphics.rectangle("line", self.pos.x, self.pos.y, self.w, self.h)

    self.colour.pop()

end

return Enemy
