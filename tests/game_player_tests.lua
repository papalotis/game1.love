-- #!/usr/bin/env lua


local lu = require('tests.luaunit')
-- love = require "love"
-- local m = require "main"
local vector = require "src.vector"
local c = require "src.class"
local w = require "src.WorldObject"
local Player = require "src.Player"
-- localPlayer = Player(100,100)


--tests to check if unit library works correctly
function testPass()
    lu.assertEquals(1, 1)
    lu.assertEquals("string","string")
end

local TestClass = {}


function testConstructor()
    local p = Player(100,100)
    lu.assertEquals(p.pos.x, 100)
end



local runner = lu.LuaUnit.new()
runner:setOutputType("tap")
return runner:runSuite()
