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

local directory = "/tests/"
--get all the files in the directory where the tests are
local file_table = scandir(directory)

--these files should be ignored
local ignore = {["runtests.lua"] = true, ["luaunit.lua"] = true}

--counts how may tests have run
local counter = 1

--holds the index of the last test that failed
local fail = 0

--gets which environment the tests run
--either localy or on the CI server
local env = os.getenv("TRAVIS")

--a table to hold the name of all the tests that failed
local failed_tests = {}

--for every file
for i,fname in ipairs(file_table) do

    --assume the test will succeed
    failed_tests[#failed_tests + 1] = false

    --if this is a lua file and it shouldn't be ignored
    if (string.sub(fname, -3) == "lua" and not ignore[fname]) then
        --print the name of the file
        print("\n" .. fname)

        --run the test and strore the result (exit status)
        --this can vary from machine to machine
        --on the server it is the first result, on my machine it is the third
        local res_server, _, res_mylaptop = os.execute("lua " ..  directory .. fname)


        local test_failed
        if (env == "true") then
            test_failed = res_server ~= 0
        else
            test_failed = res_mylaptop ~= 0
        end


        --if the test failed
        if (test_failed) then
            --store the index
            fail = counter
            --set that file as failed in the appropriate table
            failed_tests[fname] = true
        end
        counter = counter + 1
    end
end

print("\n")
if (fail == 0) then
    print("All tests run successfully")
else
    print("The following tests failed: ")
    for k,v in pairs(failed_tests) do
        if (v) then
            print(k:sub(0, - 5))
        end
    end
end
os.exit(fail)
