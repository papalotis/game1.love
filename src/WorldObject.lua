local class = require "src.class"
local WorldObject = class();
local vector = require "src.vector"
WorldObject.isworldelement = true
WorldObject.pos = vector(0,0)
WorldObject.w = 0
WorldObject.h = 0
WorldObject.ignore_camera = false
function WorldObject.update(self) return false end
function WorldObject.draw(self)   return false end

return WorldObject
