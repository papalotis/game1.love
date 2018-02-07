local function show()
    return l.player.pos.y < 100 or
    (l.player.pos.x > 400 and l.player.pos.y < 300)
end


return show
