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
        str = lines[i]
        if (str == "") then
            table.remove(lines, i)
        end
    end
    return lines
end

function choose(...)
    return chooseRandomFromTable({...})
end

function chooseRandomFromTable(tbl)
    assert(type(tbl) == "table", "Table exprected as argument")
    local rand = love and love.math.random or math.random
    local index = rand(1, #tbl)
    return tbl[index]
end

function setAll(tbl, val)
    for k,v in pairs(tbl) do
        tbl[k] = val
    end
    return tbl
end

return {
    getLinesFromFile = getLinesFromFile,
    removeEmptyLines = removeEmptyLines,
    choose = choose,
    chooseRandomFromTable = chooseRandomFromTable,
    setAll = setAll
}
