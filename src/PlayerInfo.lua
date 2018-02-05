PlayerInfo = class()

function PlayerInfo.init(self)
    self.isplayerinfoobject = true
    self.keys = {right = "right", left = "left", jump = "up"}
    self.lives = 2
end
