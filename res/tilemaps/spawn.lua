return {
  version = "1.2",
  luaversion = "5.1",
  tiledversion = "1.2.3",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 12,
  height = 10,
  tilewidth = 16,
  tileheight = 16,
  nextlayerid = 6,
  nextobjectid = 1,
  properties = {},
  tilesets = {
    {
      name = "BaseTilesheet",
      firstgid = 1,
      filename = "../tilesheets/BaseTilesheet.tsx",
      tilewidth = 16,
      tileheight = 16,
      spacing = 0,
      margin = 0,
      columns = 16,
      image = "../raw_sprites/textureatlas.png",
      imagewidth = 256,
      imageheight = 256,
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 16,
        height = 16
      },
      properties = {},
      terrains = {},
      tilecount = 256,
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      id = 1,
      name = "base_floor",
      x = 0,
      y = 0,
      width = 12,
      height = 10,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0,
        0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0,
        0, 2, 2, 2, 2, 2, 2, 35, 2, 2, 2, 0,
        0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0,
        2, 2, 2, 35, 2, 2, 2, 2, 2, 2, 2, 2,
        2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
        0, 2, 2, 2, 2, 2, 2, 2, 35, 2, 2, 0,
        0, 2, 2, 2, 35, 2, 2, 2, 2, 2, 2, 0,
        0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0,
        0, 0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0
      }
    }
  }
}
