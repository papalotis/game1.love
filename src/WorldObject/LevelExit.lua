local vector = require "src.vector"
local TextBox = require "src.WorldObject.TextBox"
local WorldObject = require "src.WorldObject"

--class that handles level changes
local LevelExit = WorldObject:extend()

local ok_message = "Press enter to exit level"
local keys_message = "You need to collect all the keys to move to the next level"
--constructor
function LevelExit.init(self, x, y, w, h, next, txt)
    self.islevelexitobject = true
    self.pos = vector(x,y)

    self.w = w
    self.h = h
    --the next level, if it empty then the default level specified in the lvl
    --file will be loaded
    self.next = next or ""

    --what message to be shown when the player can move to the next level
    self.ok_message = txt or ok_message

    self.player_is_fully_contained = false

    --the textbox that will show the message
    self.textbox = TextBox(self.ok_message, self.pos.x - self.w/2, self.pos.y - 20, "cond_level_exit_box")

    --tell the textbox to whom it belongs
    self.textbox.exit = self


    self.colour = game_colours.bright_blue


end


function LevelExit.update(self, player, level_keys)

    --check whether the player is completely within us
    self.player_is_fully_contained = rectContains(self.pos.x, self.pos.y, self.w, self.h,  player.pos.x, player.pos.y, player.w, player.h)

    --check how many keys the player has collected and if they are enough
    local player_collected_all_keys = #level_keys == #player.keys

    --and update the shown message accordinglly
    if (not player_collected_all_keys) then
        self.textbox.text = keys_message
    else
        self.textbox.text = self.ok_message
    end

    --if the player is elligible to move to the next level and the user
    --presses return/enter then tell the level what level to load next
    if (keys["return"] and self.player_is_fully_contained and player_collected_all_keys) then
        return self.next
    end
    return nil
end

function LevelExit.draw(self, player)
    --make sure the player has been given and is valid
    assert(player, "You need to pass the player object to the level exit")
    assert(player.isplayerobject, "The object you passed is not a Player object")

    --draw ourselves and textbox
    self.colour:push()
    love.graphics.rectangle("line", self.pos.x, self.pos.y, self.w, self.h)
    self.colour:pop()
    self.textbox:draw()

    --draw player with fill
    local max, min = math.max, math.min
    --if the player collides with us
    if (checkCollision(self.pos.x, self.pos.y, self.w, self.h,  player.pos.x, player.pos.y, player.w, player.h)) then
        --find right-most left edge
        local biggest_left   = max(self.pos.x, player.pos.x)
        --the bottom-most top edge
        local biggest_top    = max(self.pos.y, player.pos.y)
        --the left-most right edge
        local smallest_right = min(self.pos.x + self.w, player.pos.x + player.w)
        --the top-most bottom edge
        local smallest_bottom = min(self.pos.y + self.h, player.pos.y + player.h)
        --calc width and height of rectangle
        local width = smallest_right - biggest_left
        local height = smallest_bottom - biggest_top


        --draw rectangle with fill and the colour of the player
        player.colour:push()
        love.graphics.rectangle("fill", biggest_left - 1, biggest_top - 1, width + 2, height)
        player.colour:pop()

    end
end

return LevelExit
