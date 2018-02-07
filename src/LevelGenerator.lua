local class = require "src.class"
local vector = require "src.vector"

-- class that generates a random level
local LevelGenerator = class()

--constructor for Level class
function LevelGenerator.init(self, width, height, seed)
    self.islevelgeneratorobject = true

    self.width = (type(width) == "number") and width or 600
    self.height = (type(height) == "number") and height or 600
    self.seed = (type(seed) == "number") and seed or os.clock()

    math.randomseed(self.seed)

    -- self:generate()

end


function LevelGenerator.generate(self)
    self:generatePath()
    --putObstacles
end

function LevelGenerator.generatePath(self)
    local rand = math.random

    local start = vector(50,200)
    local finish = vector(500,400)
    local angle = math.atan2(finish.y - start.y, finish.x - start.x)

    local length = (finish - start):len()
    local step_size = 70

    local cur_pos = start:clone()

    local path = {cur_pos}
    --create a line from start to finish
    for i=1,length,step_size do
        -- local vari = chooseRandomFromTable({-math.pi/6, math.pi/6, 0})
        -- print(vari)
        local v = vector.fromPolar(angle, step_size)
        cur_pos = cur_pos + v
        table.insert(path, cur_pos)
    end

    local deviation = 20
    --add variation
    for i,v in ipairs(path) do
        if (rand() < 0.4 and i ~= 0 and i ~= #path) then
            path[i] = path[i] + vector(0,choose(0,0,0,0,20,-20,30,-30))
        end
    end

    return path
end


return LevelGenerator
