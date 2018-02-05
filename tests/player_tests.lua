-- #!/usr/bin/env lua


local lu = require "tests.luaunit"
local vector = require "src.vector"
local Player = require "src.Player"


--tests to check if unit library works correctly
function testPass()
    lu.assertEquals(2, 1)
    lu.assertEquals("string","string")
end
--
--
-- function testConstructor()
--     local p = Player(100, 100)
--     lu.assertEquals(p.pos.x, 100)
--     lu.assertEquals(p.pos.y, 100)
--     lu.assertEquals(p.w, 30)
--     lu.assertEquals(p.h, 30)
-- end
--
-- function testMoveToPos()
--     local p = Player(100,100)
--     p.speed = vector(2,0)
--     p:moveToPos(102,100)
--     lu.assertEquals(p.pos.x, 102)
--     lu.assertEquals(p.pos.y, 100)
-- end
--
-- -- function testMoveToPos()
--     local p = Player(100,100)
--     p.speed = vector(2,0)
--     p:moveToPos(102,100)
--     lu.assertEquals(p.pos.x, 102)
--     lu.assertEquals(p.pos.y, 100)
-- end


local runner = lu.LuaUnit.new()
runner:setOutputType("tap")
os.exit( runner:runSuite() )
