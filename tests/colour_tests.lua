-- #!/usr/bin/env lua


local lu = require "tests.luaunit"
local Colour = require "src.Colour"

local assertEquals = lu.assertEquals
local assertNotEquals = lu.assertNotEquals

--tests to check if unit library works correctly
function testPass()
    assertEquals(1, 1)
    assertNotEquals(0.1 + 0.2, 0.3)
    lu.assertEquals("string","string")
end


function testConstructor()

    local c = Colour(100, 100, 100, 100)
    lu.assertEquals(c.red, 100)
    lu.assertEquals(c.green, 100)
    lu.assertEquals(c.blue, 100)
    lu.assertEquals(c.alpha, 100)

end

function testConstructorOneArgument()

    local c = Colour( 0xffffff)
    lu.assertEquals(c.red, 255)
    lu.assertEquals(c.green, 255)
    lu.assertEquals(c.blue, 255)
    lu.assertEquals(c.alpha, 255)

end

function testAdd()

    local c = Colour( 0x234567)
    c:add(10,10,10)
    lu.assertEquals(c.red, 0x23 + 10)
    lu.assertEquals(c.green, 0x45 + 10)
    lu.assertEquals(c.blue, 0x67 + 10)
    lu.assertEquals(c.alpha, 255)

end



local runner = lu.LuaUnit.new()
runner:setOutputType("tap")
os.exit( runner:runSuite() )
