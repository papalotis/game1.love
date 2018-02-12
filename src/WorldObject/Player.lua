local WorldObject = require "src.WorldObject"
local vector = require "src.vector"
local Colour = require "src.Colour"
local lmutils = require "utils.math_logic_utils"
local Player = WorldObject:extend()

function Player.init(self, x, y)
    self.isplayerobject = true
    self.pos = vector(x or 20,y or 20)
    self.orig_pos = self.pos:clone()
    self.speed = vector(0,0)
    self.acc = vector(0,0)
    self.w = 30
    self.h = 30

    --physics properties
    self.hor_acc_value = 40/100
    self.hor_dec_value = 35/100
    self.max_fall_speed = 1000/100
    self.max_hor_speed = 300/100
    self.jump_force = 800/100
    self.jump_cap_force = 450/100

    --draw
    if (game_colours) then
        self.colour = game_colours.dark_red:clone()
    else

    end

    self.onplatform = nil
    self.outside_speed = vector(0,0)
    self.stuck_counter = 0

    --other
    self.keys = {}
end

local walls_to_collide = l and l.walls.playerwalls or nil

local function checkIfStuck(self)
    if (collidesWithAnyWall(self.pos.x, self.pos.y, self.w, self.h, walls_to_collide)) then
        self.stuck_counter = self.stuck_counter + 1
    else
        self.stuck_counter = 0
    end

    if (self.stuck_counter > 4 * 60) then
        self.pos = self.orig_pos:clone()
    end
end

function Player.update(self, gravity)
    local abs, min, max = math.abs, math.min, math.max

    checkIfStuck(self)

    --if the player is on a moving wall
    if (self.onplatform) then

        --check if were we want to go vertically is a valid position
        local proposed_y = self.onplatform.pos.y - self.h
        if (not (collidesWithAnyWall(self.pos.x, proposed_y, self.w, self.h))) then
            --if so move there
            self.pos.y = self.onplatform.pos.y - self.h
        else
            --otherwise, force the moving wall to go some pixels down
            self.onplatform.pos.y = self.onplatform.pos.y - sign(self.onplatform.speed.y) * 3
        end
    else
        --we want gravitiy to apply only when we aren't on a moving platform
        self:applyGravity(gravity)
    end
    self:setUserAcceleration()

    --if the user doesnt apply any horizontal movement slow down the player
    --like air friction
    self:applyFriction()

    --cap players hor speed
    self.speed.x = min(abs(self.speed.x), self.max_hor_speed) * sign(self.speed.x)

    --cap players vertical fall speed
    self.speed.y = min(self.speed.y, self.max_fall_speed)

    --if the horizontal speed is a very small number, make it 0
    --in order to avoid jittering
    if (abs(self.speed.x) < 0.4) then self.speed.x = 0 end

    self.speed = self.speed + self.acc
    self.speed = self.speed + self.outside_speed


    local newPos = self.pos + self.speed
    --mpve player to new position step by step
    self:moveToPos(newPos:unpack())

    self.speed = self.speed - self.outside_speed

    if (self.pos.y > l.height) then self.pos.y = 0 end

    self.acc = vector(0,0)
    self.onplatform = nil
    self.outside_speed = vector(0,0)
end

function Player.moveToPos(self, x, y)
    local min, cos, sin = math.min, math.cos, math.sin
    --move horizontaly pixel for pixel while checking for collisions
    local speedCopy = self.speed:clone():toPolar()
    local speedLen = speedCopy.y
    local phi = speedCopy.x



    --while we haven't moved all the way we can
    while (speedLen > 0) do
        local move_part = min(speedLen, 1)

        speedLen = speedLen - move_part

        local move_part_x = move_part * sin(phi)

        --check if we would collide in the new position

        local wall = lmutils.collidesWithAnyWall(self.pos.x + move_part_x, self.pos.y, self.w, self.h, walls_to_collide)
        --we collided horizontaly with a wall
        if (wall) then
            --kill our horizontal speed and break out of the move loop
            self.speed = vector(0, self.speed.y)
            break
        else
            self.pos.x = self.pos.x + move_part_x
        end

    end

    --vertical movement
    speedLen = speedCopy.y

    while (speedLen > 0) do
        local move_part = min(speedLen, 1)

        speedLen = speedLen - move_part

        local move_part_y = move_part * cos(phi)

        --check if we would collide in the new position
        local wall = lmutils.collidesWithAnyWall(self.pos.x, self.pos.y + move_part_y, self.w, self.h, walls_to_collide)
        --we collided vertically with a wall
        if (wall) then
            --kill our vertical speed and break out of the move loop
            self.speed = vector(self.speed.x, 0)
            break
        else
            self.pos.y = self.pos.y + move_part_y
        end

    end

end


function Player.applyGravity(self, grav)
    self.acc.y = self.acc.y + grav
end

function Player.applyFriction(self)
    if (self.acc.x == 0) then
        self.acc.x = -sign(self.speed.x) * self.hor_dec_value
    end
end

function Player.setUserAcceleration(self)
    local bti, keypressed = boolToInt, love.keyboard.isDown

    --horizontal movement
    local hor_acc = self.hor_acc_value * (bti(keys["right"]) - bti(keys["left"]))
    self.acc.x = self.acc.x + hor_acc

    --jumping
    if (keys["up"]) then
        --if we are just over a wall
        if (collidesWithAnyWall(self.pos.x, self.pos.y + 1, self.w, self.h)) then
            --override all the vertical acceleration and move upwards fast
            local ver_acc = - self.jump_force
            self.acc.y = ver_acc
        end
    end

    if (keysreleased["up"]) then
        if (self.speed.y < 0) then
            self.speed.y = - math.min(-self.speed.y, self.jump_cap_force)
        end
        -- if (self.speed.y < -self.jump_cap_force) then
        --     self.speed
    end
end

function Player.draw(self)
    -- r,g,b,a = love.graphics.getColor()
    -- love.graphics.setColor(self.colour.red, self.colour.green, self.colour.blue, self.colour.alpha)
    self.colour:push()
    love.graphics.rectangle("line", self.pos.x, self.pos.y, self.w, self.h - 1)
    Colour.pop(nil)
    -- love.graphics.setColor(r,g,b,a)
end

return Player
