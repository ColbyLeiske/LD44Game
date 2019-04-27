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
  nextlayerid = 4,
  nextobjectid = 5,
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
      name = "Tile Layer 1",
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
        0, 2, 2, 2, 2, 35, 2, 2, 2, 2, 2, 0,
        0, 2, 7, 5, 6, 2, 2, 7, 5, 6, 2, 0,
        0, 2, 22, 1, 21, 2, 2, 22, 1, 21, 2, 0,
        2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 35, 2,
        2, 2, 2, 2, 2, 2, 35, 2, 2, 2, 2, 2,
        0, 2, 7, 5, 6, 2, 2, 7, 5, 6, 2, 0,
        0, 2, 22, 1, 21, 2, 2, 22, 1, 21, 2, 0,
        0, 2, 35, 2, 2, 2, 2, 2, 2, 2, 2, 0,
        0, 0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      id = 2,
      name = "shadows",
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
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 36, 0, 0, 0, 0, 36, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 36, 0, 0, 0, 0, 36, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "objectgroup",
      id = 3,
      name = "collision",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {
        ["collidable"] = true
      },
      objects = {
        {
          id = 1,
          name = "",
          type = "",
          shape = "rectangle",
          x = 42,
          y = 43,
          width = 28,
          height = 21.25,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 2,
          name = "",
          type = "",
          shape = "rectangle",
          x = 122.125,
          y = 43,
          width = 27.75,
          height = 21.125,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 3,
          name = "",
          type = "",
          shape = "rectangle",
          x = 122.125,
          y = 107,
          width = 28.125,
          height = 20.875,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 4,
          name = "",
          type = "",
          shape = "rectangle",
          x = 42.125,
          y = 107.125,
          width = 27.875,
          height = 20.875,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
