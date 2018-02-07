local vector = require "src.vector"
local TextBox = require "src.TextBox"
local WorldObject = require "src.WorldObject"
local LevelExit = WorldObject:extend()

local ok_message = "Press enter to exit level"
local keys_message = "You need to collect all the keys to move to the next level"

function LevelExit.init(self, x, y, w, h)
    self.islevelexitobject = true
    self.pos = vector(x,y)

    self.w = w
    self.h = h

    self.player_is_fully_contained = false

    self.textbox = TextBox(ok_message, self.pos.x - self.w/2, self.pos.y - 20)

    self.colour = game_colours.bright_blue


end


function LevelExit.update(self, player, level_keys)
    self.player_is_fully_contained = rectContains(self.pos.x, self.pos.y, self.w, self.h,  player.pos.x, player.pos.y, player.w, player.h)
    local player_collected_all_keys = #level_keys == #player.keys

    if (not player_collected_all_keys) then
        self.textbox.text = keys_message
    else
        self.textbox.text = ok_message
    end


    if (keys["return"] and self.player_is_fully_contained and player_collected_all_keys) then
        return true
    end
    return false
end

function LevelExit.draw(self, player)
    assert(player, "You need to pass the player object to the level exit")
    assert(player.isplayerobject, "The object you passed is not a Player object")

    self.colour:push()
    love.graphics.rectangle("line", self.pos.x, self.pos.y, self.w, self.h)
    if (self.player_is_fully_contained) then
        self.textbox:draw()
    end
    self.colour:pop()

    local max, min = math.max, math.min
    if (checkCollision(self.pos.x, self.pos.y, self.w, self.h,  player.pos.x, player.pos.y, player.w, player.h)) then
        local biggest_left   = max(self.pos.x, player.pos.x)
        local biggest_top    = max(self.pos.y, player.pos.y)
        local smallest_right = min(self.pos.x + self.w, player.pos.x + player.w)
        local smallest_bottom = min(self.pos.y + self.h, player.pos.y + player.h)
        local width = smallest_right - biggest_left
        local height = smallest_bottom - biggest_top



        player.colour:push()
        love.graphics.rectangle("fill", biggest_left - 1, biggest_top - 1, width + 2, height)
        player.colour:pop()

    end
end

return LevelExit
