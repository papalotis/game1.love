function scandir(directory)
    local i, t, popen = 0, {}, io.popen
    local pfile = popen('ls -a "'..directory..'"')
    for filename in pfile:lines() do
        i = i + 1
        t[i] = filename
    end
    pfile:close()
    return t
end

local directory = "./tests/"

local file_table = scandir(directory)
local ignore = {["runtests.lua"] = true, ["luaunit.lua"] = true}

local counter = 1
local fail = 0


for i,fname in ipairs(file_table) do
    if (string.sub(fname, -3) == "lua" and not ignore[fname]) then
        print("\n" .. fname)
        local bool = os.execute("lua " ..  directory .. fname)

        -- print("Test exited with status " .. res)
        print(bool)

        if (bool ~= 0) then fail = counter end
        counter = counter + 1
    end
end
print(fail)
os.exit(fail)
