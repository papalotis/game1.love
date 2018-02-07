local vector = require "src.vector"
local utils = require "src.utils"
local class = require "src.class"
local Level = require "src.Level"
local LevelExit = require "src.LevelExit"
local LevelGenerator = require "src.LevelGenerator"
local WorldObject = require "src.WorldObject"
local Player = require "src.Player"
local Enemy = require "src.Enemy"
local CameraFollower = require "src.CameraFollower"
local Wall = require "src.Wall"
local AlwaysActiveWall = require "src.AlwaysActiveWall"
local MovingWall = require "src.MovingWall"
local TextBox = require "src.TextBox"
local Colour = require "src.Colour"
local gamera = require "src.gamera"

--global variable that holds the contructor for every class
objects = {vector = vector,
 utils = utils,
 class = class,
 Level =  Level,
 LevelExit = LevelExit,
 LevelGenerator = LevelGenerator,
 WorldObject = WorldObject,
 Player = Player,
 Enemy = Enemy,
 CameraFollower = CameraFollower,
 Wall = Wall,
 AlwaysActiveWall = AlwaysActiveWall,
 MovingWall = MovingWall,
 TextBox =TextBox,
 Colour = Colour,
 gamera = gamera
}

if not love then return end

--used to store what colour we are currently
-- colour_stack = {}

game_colours = {
    black        = Colour( 0x30, 0x30, 0x30, 0xaa),
    gray         = Colour( 0x47, 0x47, 0x47, 0xaa),
    bright_red   = Colour( 0xeb, 0x17, 0x5d, 0xaa),
    bright_green = Colour( 0x8F, 0x97, 0x79, 0xaa),
    dark_red     = Colour( 0xcc, 0x52, 0x7a, 0xaa),
    light_gray   = Colour( 0xa8, 0xa7, 0xa8, 0xaa),
    white        = Colour( 0xdd, 0xdd, 0xdd, 0xaa)
}



--the default colour is white
game_colours.light_gray:push()

--used to store key presses
keys = {}
keyspressed = {}
keysreleased = {}

--game variables
local cam

function love.keypressed(key, scancode, isrepeat)
    keys[key] = true
    keyspressed[key] = true

    if (key == "escape") then
        love.event.quit(0)
    end
end

function love.quit()
    print("Thanks for playing")
end

function love.keyreleased(key)
    keys[key] = false
    keysreleased[key] = true
end

function love.load(arg)

    --this makes the canvas not blurry
    love.graphics.setDefaultFilter( "nearest", "nearest" )

    -- load the first level
    l = Level("01.lvl")
    g = LevelGenerator(100,100,10)
    thepath = g:generatePath()

    --the background should not be completely black
    local col = game_colours.black
    love.graphics.setBackgroundColor(col.red, col.green, col.blue, col.alpha)

    --set the window
    love.window.setMode(1280, 720)
    -- love.window.setFullscreen(true)

    cam = gamera.new(l.camera_left,l.camera_top,l.width, l.height)
end

function love.update(dt)

    p = l.player

    follower = l.follower

    local pd = l:run()

    setAll(keyspressed, false)
    setAll(keysreleased, false)



end

function love.draw()

    if (follower) then

        cam:setWorld(l.camera_left,l.camera_top,l.width, l.height)
        cam:setPosition(follower.pos.x, follower.pos.y)
    end


    for _,elem in pairs(l.world) do
        if (elem.ignore_camera) then
            elem:draw()
        end
    end


    cam:draw(function()

        l:render()
    end)
    for i = 1,#thepath - 1 do
        local p1 = thepath[i]
        local p2 = thepath[i + 1]
        love.graphics.line(p1.x, p1.y, p2.x, p2.y)
    end
    love.graphics.setPointSize(5)
    love.graphics.points(50,200,500,400)

end
