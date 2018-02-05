-- #!/usr/bin/env lua


local lu = require('luaunit')
local mymath = loadfile("../utils/math_logic_utils.lua")()


--tests to check if unit library works correctly
function testPass()
    lu.assertEquals(1, 0)
    lu.assertEquals("string","string")
end

function testAddition()
    lu.assertEquals(1 + 2, 3)
end

function testSign()
    lu.assertEquals(mymath.sign(2), 1)
    lu.assertEquals(mymath.sign(0.2), 1)
    lu.assertEquals(mymath.sign(-2), -1)
    lu.assertEquals(mymath.sign(-0.2), -1)
    lu.assertEquals(mymath.sign(0), 0)
    lu.assertEquals(mymath.sign(-0), 0)
end

function testBoolToInt()
    local bti = mymath.boolToInt
    lu.assertEquals(bti(true), 1)
    lu.assertEquals(bti(false), 0)
end

function testCheckCollision()
    local cc = mymath.checkCollision
    lu.assertEquals(cc(0,0,100,100,10,10,10,10), true)
    lu.assertEquals(cc(0,0,100,100,200,200,10,10), false)
end

function testCurry()
    local curry = mymath.curry
    local pow2 = curry(math.pow)(2)
    lu.assertEquals(pow2(10), 1024)
end

function testCompose()
    local comp = mymath.compose
    local curry = mymath.curry

    local fourth_root = comp(math.sqrt, math.sqrt)
    lu.assertEquals(fourth_root(16), 2)
    lu.assertEquals(fourth_root(256), 4)
    -- lu.assertEquals(fourth_root(256), 8)

    local id = comp(math.log10, curry(math.pow)(10))
    lu.assertEquals(id(23), 23)
    lu.assertEquals(id(101), 101)
    lu.assertEquals(id(9), 9)
    lu.assertNotEquals(id(10), 11)

end


local runner = lu.LuaUnit.new()
runner:setOutputType("tap")
return runner:runSuite()
