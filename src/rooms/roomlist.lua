--eventually change to dynamically grab all of the maps in the folder......

basePath = "res/tilemaps/"
local roomlist = {
    basePath .. "spawn.lua",
    basePath .. "room1.lua",


    walls = basePath .. "walls.lua"
}
return roomlist
