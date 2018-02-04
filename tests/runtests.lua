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

for k,fname in pairs(file_table) do
    if (string.sub(fname, -3) == "lua" and not ignore[fname]) then
        print("\n" .. fname)
        os.execute("lua " .. fname)
    end
end
