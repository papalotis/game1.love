local WorldObject = require "src.WorldObject"
local vector = require "src.vector"

local CameraFollower = WorldObject:extend();

--constructor for CameraFollower class
function CameraFollower.init(self, x, y)
    self.iscamerafollowerobject = true
    --starting position
    x = x or 100
    y = y or 100

    self.pos = vector(x, y)
    --to be multiplied with the distance
    self.speed_factor = 10 / 100

    --the maximum speed the follower can move
    self.max_speed = 10

    --counts for how many ticks the player hasn't moved
    self.player_inactive_timer = 0

    --after how many ticks of non-movement the player is
    --considered inactive
    self.inactivity_time_threshhold = 120

    --if the player moves less than this amount it counts as a non movement
    self.inactivity_threshhold = 3 --3 pixels

    --a copy of the player position
    self.player_pos = self.pos:clone()
end

local phi, dist
local counter = 0

function CameraFollower.update(self, player)
    if (player) then
        assert(player.isplayerobject, "Player Object expected")

        --assess how much the player moved
        local player_movement = self.player_pos - player.pos

        --and store the position so that it can be used in the next tick
        self.player_pos = player.pos:clone()

        --if the player moved very little
        if (player_movement:len() < self.inactivity_threshhold) then

            --add to the inactivity timer
            self.player_inactive_timer = self.player_inactive_timer + 1
        else
            --otherwise set the inactive timer to zero
            self.player_inactive_timer = 0
        end


        local nx,ny = 0,0

        --calculate noise/pan effect
        counter = counter + 0.005
        --only do that if the player has beeen inactive for a while
        if (self.player_inactive_timer > self.inactivity_time_threshhold) then

            nx = (love.math.noise(counter ) - 0.5) * math.min(0.4 *self.player_inactive_timer/self.inactivity_threshhold - 1,2)
            ny = (love.math.noise(counter + 1001 ) - 0.5) * math.min( 0.4 *self.player_inactive_timer/self.inactivity_threshhold - 1,2)

        end

        local noise = vector(nx,ny)

        --this is our target
        local px, py = player.pos.x + player.w/2, player.pos.y + player.h/2

        --if the distance to the player is very small
        --then we can just jump to that position
        if (self.pos:dist(vector(px,py)) < 2) then
            self.pos = vector(px,py)
        else
            --calculate the angle in which we move
            phi  = math.atan2(py - self.pos.y, px - self.pos.x)

            --calculate the speed with which we move
            dist = self.pos:dist(vector(px, py)) * self.speed_factor
            --cap the speed
            dist = math.min(dist, self.max_speed)

            local spd = vector.fromPolar(phi, dist)

            --move along
            self.pos = self.pos + spd + noise
        end
    end
end

function CameraFollower.draw(self)
    love.graphics.circle("fill", self.pos.x, self.pos.y, 4, 10)

end

return CameraFollower
