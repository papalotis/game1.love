

--returns a table that contains all the lines of a file
function getLinesFromFile(filename)
    local lines = {}

    if (file_exists(filename)) then
        for line in io.lines(filename) do
            table.insert(lines, line)
        end
    end
    return lines
end

--removes empty lines from a stirng table
function removeEmptyLines(lines)
    for i=#lines,1, -1 do
        if (lines[i] == "") then
            table.remove(lines, i)
        end
    end
end

function choose(...)
    return chooseRandomFromTable({...})
end

function chooseRandomFromTable(tbl)
    assert(type(tbl) == "table", "Table exprected as argument")
    local index = love.math.random(1, #tbl)
    return tbl[index]
end

function setAll(tbl, val)
    for k,v in pairs(tbl) do
        tbl[k] = val
    end
end
