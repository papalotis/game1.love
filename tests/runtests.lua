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

local file_table = scandir("./")
local ignore = {["runtests.lua"] = true, ["luaunit.lua"] = true}

local counter = 1
for i,fname in ipairs(file_table) do
    if (string.sub(fname, -3) == "lua" and not ignore[fname]) then
        print("\n" .. fname)
        res = os.execute("lua " .. fname)

        if (not res) then os.exit(counter) end
        counter = counter + 1
    end
end
