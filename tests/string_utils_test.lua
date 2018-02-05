-- #!/usr/bin/env lua


local lu = require('tests.luaunit')
local mystring = loadfile("./utils/string_utils.lua")()


--tests to check if unit library works correctly
function testPass()
    lu.assertEquals(1, 1)
    lu.assertEquals("string","string")
end

function testSplit()
    local split = mystring.mysplit
    lu.assertEquals(split("This is a string"), {"This", "is", "a", "string"})

    lu.assertEquals(split("This, is a, string", ","), {"This", " is a", " string"})
end

function testTrim()
    local trim = mystring.trim
    lu.assertEquals(trim("string"), "string")

    lu.assertEquals(trim("   string"), "string")
    lu.assertEquals(trim("string  "), "string")
    lu.assertEquals(trim("   string  "), "string")

    lu.assertNotEquals(trim("   string  "), " string")

end

local runner = lu.LuaUnit.new()
runner:setOutputType("tap")
return runner:runSuite()
