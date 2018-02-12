local Wall = require "src.Wall"


--Wall class, that is used to manipulate the path of enemies
--it is invisible and doesnot affect the player
local EnemyWall = Wall:extend()


function EnemyWall.childinit (self)
    self.isenemywallobject = true
end

function EnemyWall.update(self)
    self.active = true
end

--class doesnt draw anything
function EnemyWall.draw(self) return false end

return EnemyWall
