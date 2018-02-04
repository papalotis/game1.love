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

            --table that holds the arguments
            local vals = {}

            --the first element is not a key value pair
            --it tells us what kind of object will be created
            local obj_type = fields[1]

            --for the rest of the key, val pairs
            for i=2, #fields do
                local str = fields[i]

                --the key, val are separated by a :
                --(like the properties) so we split the
                --string into two substrings that are split by a :
                local substr = mysplit(str, ":")

                --attempt to convert the value to a number
                local val = tonumber(substr[2]) or substr[2]

                --insert the value to the arguments table
                table.insert(vals,val)
            end

            --get the constructor of the object we want to make
            local obj = _G[obj_type]
            --r will hold the instance of the object that we will make
            local r = nil

            --if there is a constructor for the object we want to make
            if (obj) then
                --create the object with the arguments we stored in the vals table
                r = obj(unpack(vals))
            end

            --if an object was created
            if (r) then
                --insert it into the world
                table.insert(self.world,r)

                --if the object we made was of type player
                if (r.isplayerobject) then
                    --store that instance in the player member
                    self.player = r
                    --and also store it in the moving objects table
                    table.insert(self.moving_objects,r)
                end

                --enemy objects can also move
                if (r.isenemyobject) then
                    --so we also add them to the moving_objects table
                    table.insert(self.moving_objects,r)
                end

                --we need to store the camera follower in its own member
                if (r.iscamerafollowerobject) then
                    self.follower = r
                end

            end
        end


    end
end

--runs one tick(step, frame) of the level
function Level.run(self)
    local player_dies = false
    local load_next_level = false

    --when the player presses the space key swap
    --which walls are active (collidable)
    self.activeWallGroup = 1
    if (keys["space"]) then
        self.activeWallGroup = 2
    end

    --for every element in the world run its update function
    --different objects need different arguments for their update
    --so there is an if-elseif-...-else statement that looks at what kind
    --of object the current one is and gives it the appropriate arguments
    for _,elem in pairs(self.world) do
        if (elem.isplayerobject) then
            elem:update(self.gravity)

        elseif (elem.isenemyobject) then
            --an enemy object also tells us if that enemy killed the player
            --so we compare what the enemy says with the general 'consensus'
            local this_enemy_kills_the_player = elem:update(self.player, self.gravity)

            --if at least one enemy claims to kill the player then we want to kill
            --that player
            player_dies = player_dies or this_enemy_kills_the_player

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

    --if the level exit object says that we should move to the next levels
    --then move to the next level
    if (load_next_level) then
        self:loadNextLevel()
    end

    --if an enemy claims that it killed the player, reload the level
    if (player_dies) then
        self:reload()
    end

    if (keys["r"]) then self:reload() end

    return player_dies
end

--this method runs the draw method of all the objects in the world
function Level.render(self)
    --like the run method, different objects require different arguments
    --in their draw methods, so there is an if... that gives each
    --object the appropriate arguments
    for _,elem in pairs(self.world) do
        if (not elem.ignore_camera and not elem.isplayerobject) then
            if (elem.islevelexitobject) then
                elem:draw(self.player)
            else
                elem:draw()
            end
        end
    end
    --draw the player last
    if (self.player) then
        self.player:draw()
    end
end

--loads a level from a file
--this methods creates a new level instance
--and copies all the attribures to the current level instance
function Level.load(self, filename)
    local nl = nil
    if (filename) then
        --create new level instance
        nl = Level(filename)
        --reset the current level
        self:reset()
        --copy all attributes to self
        for k,v in pairs(nl) do
            self[k] = v
        end
        nl = nil
    end
end

--reloads the current level
function Level.reload(self)
    if (self.file) then
        self:load(self.file)
    end
end

--load the next level that is specified
--in the .lvl file
function Level.loadNextLevel(self)
    if (self.next) then
        self:load(self.next)
    end

end

function removeComments(lines)
    for i=#lines,1, -1 do
        if (lines[i]:sub(1,1) == "!") then
            table.remove(lines, i)
        end
    end
end
