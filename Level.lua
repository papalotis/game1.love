-- class that runs the game code
Level = class()

--constructor for Level class
function Level.init(self, filename)
    self.islevelobject = true

    --get the path to the filename
    self.path = love.filesystem.getSource() .. "/levels/"

    --store the filename of the level
    self.file = filename

    --initilize the level with default values
    self:reset()

    --load the level from the file
    self:readFromFile(self.path .. filename)

end

--method that initilizes the object with default values
function Level.reset(self)
    self.world = {}
    self.moving_objects = {}
    self.player = nil
    self.follower = nil
    self.colours = {}
    self.width = -1
    self.height = -1
    self.next = nil
    self.gravity = 300 / 1000
    self.activeWallGroup = -1
end


--reads a file, loads/creates the appropriate objects
--and adds them to the level
function Level.readFromFile(self, filename)
    --at the beginning we are reading the properties of
    --the level like the width, height, what's the next level etc...
    mode = "properties"

    --load all the lines of the file into a table
    local lines = getLinesFromFile(filename)

    --we can ignore empty lines
    removeEmptyLines(lines)
    --lines beginning with ! are treated as comments and can
    --therefore be ignored
    removeComments(lines)

    --for every line in the file
    for _,line in ipairs(lines) do
        --if a line is "Objects" that tells us, that from now on
        --we won't be reading properties, but actual objects to be
        --placed in the world
        if (line == "Objects") then mode = "objects" end

        --if we are reading properties of the level
        if (mode == "properties") then
            --properties are differantiated by a : as key:value

            --split the line at the : to get the key and the value
            local vals = mysplit(line,":")

            local key, value = vals[1], vals[2];
            if (key and value) then
                --trim the key and value (remove the leading and trailing spaces)
                key, value = key:trim(), value:trim()

                --attempt to convert the value to a number
                value = tonumber(vallue) or value

                --if we just read a colour (that is one of the colours that will be used
                --for the walls) then
                if (key:sub(1,6) == "colour") then
                    --inset the colour to the colours table
                    table.insert(self.colours,game_colours[val])
                else

                    --this is for normal values
                    self[key] = val
                end
            end

        --we have read an object to be placed in the world
        else
            --key val pairs are separated by a comma
            --make a table that contains all those key value pairs
            --as strings
            local fields = mysplit(line, ",")
            local vals = {}

            --the first element is not a key value pair
            --it tells us what kind of object will 
            local obj_type = fields[1]
            for i=2, #fields do
                local str = fields[i]
                local substr = mysplit(str, ":")

                local val = tonumber(substr[2]) or substr[2]
                table.insert(vals,val)
            end


            local obj = _G[obj_type]
            local r = nil
            if (obj) then

                r = obj(unpack(vals))
            end

            if (r) then
                table.insert(self.world,r)
                if (r.isplayerobject) then
                    self.player = r
                    table.insert(self.moving_objects,r)
                end
                if (r.isenemyobject) then
                    table.insert(self.moving_objects,r)
                end
                if (r.iscamerafollowerobject) then
                    self.follower = r
                end

            end
        end


    end
end

function Level.run(self)
    local player_dies = false
    local load_next_level = false

    self.activeWallGroup = 1
    if (keys["space"]) then
        self.activeWallGroup = 2
    end

    for _,elem in pairs(self.world) do
        if (elem.isplayerobject) then
            elem:update(self.gravity)

        elseif (elem.isenemyobject) then

            player_dies = elem:update(self.player, self.gravity)

        elseif (elem.ismovingwallobject) then

            elem:update(self.moving_objects)

        elseif (elem.islevelexitobject) then
            load_next_level = elem:update(self.player)
        elseif (elem.iswallobject) then
            elem:update(self.activeWallGroup, self.colours)

        elseif (elem.iscamerafollowerobject) then

            elem:update(self.player)
        else

            elem:update()
        end
    end

    if (load_next_level) then
        self:loadNextLevel()
    end

    if (player_dies) then
        self:reload()
    end

    if (keys["r"]) then self:reload() end

    return player_dies
end

function Level.render(self)
    for _,elem in pairs(self.world) do
        if (not elem.ignore_camera and not elem.isplayerobject) then
            if (elem.islevelexitobject) then
                elem:draw(self.player)
            else
                elem:draw()
            end
        end
    end
    if (self.player) then
        self.player:draw()
    end
end


function Level.load(self, filename)
    local nl = nil
    if (self.next) then
        nl = Level(filename)
    end
    self:reset()
    for k,v in pairs(nl) do
        self[k] = v
    end
    nl = nil
end

function Level.reload(self)
    self:load(self.file)
end

function Level.loadNextLevel(self)
    self:load(self.next)

end

function removeComments(lines)
    for i=#lines,1, -1 do
        if (lines[i]:sub(1,1) == "!") then
            table.remove(lines, i)
        end
    end
end
