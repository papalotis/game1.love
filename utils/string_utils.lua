--returns a table of strings that are separeated by a string
function mysplit(inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            t[i] = str
            i = i + 1
    end
    return t
end



function string.trim(self)
  return (self:gsub("^%s*(.-)%s*$", "%1"))
end
