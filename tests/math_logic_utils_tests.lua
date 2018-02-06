-- #!/usr/bin/env lua


local lu = require('tests.luaunit')
local mymath = loadfile("./utils/math_logic_utils.lua")()
local assertEquals = lu.assertEquals
local assertNotEquals = lu.assertNotEquals


--tests to check if unit library works correctly
function testPass()
    assertEquals(1, 1)
    assertEquals("string","string")
end

function testAddition()
    assertEquals(1 + 2, 3)
end

function testSign()
    assertEquals(mymath.sign(2), 1)
    assertEquals(mymath.sign(0.2), 1)
    assertEquals(mymath.sign(-2), -1)
    assertEquals(mymath.sign(-0.2), -1)
    assertEquals(mymath.sign(0), 0)
    assertEquals(mymath.sign(-0), 0)
end

function testBoolToInt()
    local bti = mymath.boolToInt
    assertEquals(bti(true), 1)
    assertEquals(bti(false), 0)
end

function testCheckCollision()
    local cc = mymath.checkCollision
    assertEquals(cc(0,0,100,100,10,10,10,10), true)
    assertEquals(cc(0,0,100,100,200,200,10,10), false)
end

function testCurry()
    local curry = mymath.curry
    local pow2 = curry(math.pow)(2)
    assertEquals(pow2(10), 1024)
end

function testCompose()
    local comp = mymath.compose
    local curry = mymath.curry

    local fourth_root = comp(math.sqrt, math.sqrt)
    assertEquals(fourth_root(16), 2)
    assertEquals(fourth_root(256), 4)

    local id = comp(math.log10, curry(math.pow)(10))
    assertEquals(id(23), 23)
    assertEquals(id(101), 101)
    assertEquals(id(9), 9)
    assertNotEquals(id(10), 11)

end

function testcircleRectCollision()
    local ccwr = mymath.circleCollidesWithRectanle
    assertEquals(ccwr(0,0,100,  0,0,10,10), true)
    assertEquals(ccwr(0,0,100,  1000,1000,10,10), false)

    assertEquals(ccwr(0,0,50, -100, -100, 200, 49), false)

    assertEquals(ccwr(0,0,50, -100, -100, 100, 51), true)
end


local runner = lu.LuaUnit.new()
runner:setOutputType("tap")
os.exit( runner:runSuite() )
