CameraFollower = WorldObject:extend();

function CameraFollower.init(self, x, y)
    self.iscamerafollowerobject = true
    x = x or 100
    y = y or 100
    self.pos = vector(x, y)
    self.speed_factor = 10 / 100
    self.max_speed = 10
    self.player_inactive_timer = 0
    self.inactivity_time_threshhold = 120
    self.inactivity_threshhold = 3 --3 pixels
    self.player_pos = self.pos:clone()
end

local phi, dist
local counter = 0

function CameraFollower.update(self, player)
    counter = counter + 0.005
    if (player) then
        assert(player.isplayerobject, "Player Object expected")

        --assess how much the player moved
        local player_movement = self.player_pos - player.pos
        self.player_pos = player.pos:clone()

        if (player_movement:len() < self.inactivity_threshhold) then
            self.player_inactive_timer = self.player_inactive_timer + 1
        else
            self.player_inactive_timer = 0
        end


        local nx,ny = 0,0

        if (self.player_inactive_timer > self.inactivity_time_threshhold) then
            -- print("player inactive")
            nx = (love.math.noise(counter ) - 0.5) * math.min(0.4 *self.player_inactive_timer/self.inactivity_threshhold - 1,2)
            ny = (love.math.noise(counter + 1001 ) - 0.5) * math.min( 0.4 *self.player_inactive_timer/self.inactivity_threshhold - 1,2)
            -- ny = 0
            print(ny)
        end

        local noise = vector(nx,ny)
        -- print(noise)

        if (self.pos:dist(player.pos) < 2) then
            self.pos = player.pos:clone()
        else
            local px, py = player.pos.x + player.w/2, player.pos.y + player.h/2

            phi  = math.atan2(py - self.pos.y, px - self.pos.x)
            dist = self.pos:dist(vector(px, py)) * self.speed_factor
            local spd = vector.fromPolar(phi, dist)

            if (spd:len() > self.max_speed) then
                spd:setLen(self.max_speed)
            end


            self.pos = self.pos + spd + noise
        end
    end
end

function CameraFollower.draw(self)
    love.graphics.circle("fill", self.pos.x, self.pos.y, 4, 10)

end
