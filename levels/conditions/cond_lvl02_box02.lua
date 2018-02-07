local has_passed_obstacle = false

local function show()
    if (l.player.pos.x < 350 and l.player.pos.y > 220) then
        has_passed_obstacle = true
    end
    return not has_passed_obstacle
end


return show
