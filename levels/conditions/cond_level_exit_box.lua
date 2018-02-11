local alpha = 0
local orig_alpha = -1

local function show(self)
    --this only runs once
    if (orig_alpha == -1) then
        self.colour = self.exit.colour:clone()
        orig_alpha = self.colour.alpha
    end

    if (self.exit.player_is_fully_contained) then
        alpha = alpha + 4
    else
        alpha = alpha - 6
    end

    alpha = math.min(orig_alpha, alpha)
    alpha = math.max(0.1, alpha)

    self.colour:setAlpha(alpha)
    return true
end



return show
