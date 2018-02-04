vector = require "src.vector"
require "src.utils"
require "src.class"
require "src.Level"
require "src.WorldObject"
require "src.Player"
require "src.Enemy"
require "src.CameraFollower"
require "src.Wall"
require "src.MovingWall"
require "src.LevelExit"
require "src.TextBox"
require "src.Colour"
gamera = require "src.gamera"



--used to store what colour we are currently
colour_stack = {}

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

    --load the first level
    l = Level("06.lvl")

    --the background should not be completely black
    local col = game_colours.black
    love.graphics.setBackgroundColor(col.red, col.green, col.blue, col.alpha)

    --set the window
    love.window.setMode(1280, 720)
    -- love.window.setFullscreen(true)

    cam = gamera.new(l.camera_left,l.camera_top,l.width, l.height)
end

function love.update(dt)
    -- -- body...
    -- p = l.player
    follower = l.follower

    local pd = l:run()

    setAll(keyspressed, false)
    setAll(keysreleased, false)



end

function love.draw()

    if (follower) then
        print(l.camera_left)
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
end
