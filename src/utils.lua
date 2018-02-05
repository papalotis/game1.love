require "utils.graphical_utils"
require "utils.math_logic_utils"
require "utils.string_utils"
require "utils.table_utils"

--returns true if a file exists
function file_exists(name)
    local f = io.open(name,"r")
    if (f~=nil) then
       io.close(f)
       return true
    else
       return false
    end
end




printf = compose(print, string.format)
