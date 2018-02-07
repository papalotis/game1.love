local enemy = nil
local time = 0

local function findEnemy(world)
    for k,v in pairs(l.world) do
        if (v.isenemyobject) then
            return v
        end
    end
end

local function show(self)


    if (not enemy) then
        enemy = findEnemy(l.world)
    else

        time = (time + 1)
        if (time == 100) then
            self.text = "If they touch you, you DIE"
        elseif (time >= 200 and (keys["right"] or keys["left"])) then
            self.text = ""
        end


        self.x = enemy.pos.x - 20
        self.y = enemy.pos.y - 20 + 4 * math.sin(time / 10)
    end

    return true

end



return show
