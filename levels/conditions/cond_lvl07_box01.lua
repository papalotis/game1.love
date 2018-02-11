local alpha = 0
local orig_alpha = -1

local function show(self)

    if (orig_alpha == -1) then
        orig_alpha = self.colour.alpha
    end

    self.text = "This is a key, without it you cannot exit the level"
    if (#l.player.keys > 0) then
        self.text = "You have collected this key"
    end
    if (l.player.pos.y > 200) then
        alpha = alpha + 4
    else
        alpha = alpha - 6
    end

    alpha = constraint(alpha, 0.1, orig_alpha)

    self.colour:setAlpha(alpha)
    return true
end



return show
