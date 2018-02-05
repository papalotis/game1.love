Player = WorldObject:extend()

function Player.init(self, x, y)
    self.isplayerobject = true
    self.pos = vector(x or 20,y or 20)
    self.orig_pos = self.pos:clone()
    self.speed = vector(0,0)
    self.acc = vector(0,0)
    self.w = 30
    self.h = 30

    self.hor_acc_value = 0.5
    self.hor_dec_value = 0.7
    self.max_fall_speed = 10
    self.max_hor_speed = 3
    self.jump_force = 8
    self.jump_cap_force = 4.5

    self.colour = game_colours.dark_red

    self.onplatform = nil
    self.outside_speed = vector(0,0)

    self.stuck_counter = 0
end

function Player.update(self, gravity)
    local abs, min, max = math.abs, math.min, math.max

    self:checkIfStuck()

    if (self.onplatform) then
        self.pos.y = self.onplatform.pos.y - self.h
    else
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

    --vertical movement
    speedLen = speedCopy.y

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

end

function Player.checkIfStuck(self)
    if (collidesWithAnyWall(self.pos.x, self.pos.y, self.w, self.h)) then
        self.stuck_counter = self.stuck_counter + 1
    else
        self.stuck_counter = 0
    end

    if (self.stuck_counter > 4 * 60) then
        self.pos = self.orig_pos:clone()
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
