-- #!/usr/bin/env lua


local lu = require('tests.luaunit')
local mytable = loadfile("./utils/table_utils.lua")()


--tests to check if unit library works correctly
function testPass()
    lu.assertEquals(1, 1)
    lu.assertEquals("string","string")
end

function testRemoveEmptyLines()
    local rel = mytable.removeEmptyLines
    local l = {"sad", "", "line", ""}
    lu.assertEquals(rel(l), {"sad", "line"})

    l = {"line a", "line b", "line c"}
    lu.assertEquals(rel(l), l)
end

function testChoose()
    local c = mytable.choose

    local choice = c(0,1)
    lu.assertEquals(choice == 1 or choice == 0, true)
    lu.assertEquals(choice ~= 2, true)
end

function testChooseRandomFromTable()
    local crft = mytable.chooseRandomFromTable

    local tbl = {1,2,3,4,5,6,7,8,9}
    local choice = crft(tbl)
    local res = false
    for k,v in pairs(tbl) do
        if (choice == v) then
            res = true
        end
    end
    lu.assertEquals(res, true)

end

function testsetAll()
    local sa = mytable.setAll

    local tbl = {1,2,3,4,5}
    lu.assertEquals(sa(tbl,2), {2,2,2,2,2})

end

local runner = lu.LuaUnit.new()
runner:setOutputType("tap")
return runner:runSuite()
