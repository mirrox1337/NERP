Config                            = {}
Config.DrawDistance               = 15.0
Config.MarkerColor                = { r = 0, g = 0, b = 255 }
--language currently available EN and SV
Config.Locale = 'sv'
--this is how much the price shows from the purchase price
-- exapmle the cardealer boughts it for 2000 if 2 then it says 4000
Config.Price = 1.7 -- this is times how much it should show

Config.Zones = {

  ShopInside = {
    Pos     = { x = -148.77 , y = -596.63, z = 166.0 },
    Size    = { x = 1.5, y = 1.5, z = 1.0 },
    Heading = 177.28,
    Type    = -1,
  },

  Katalog = {
    Pos     = { x = -143.53 , y = -592.18, z = 166.03 },
    Size    = { x = 1.5, y = 1.5, z = 1.0 },
    Heading = 177.28,
    Type    = 27,
  },

  GoDownFrom = {
    Pos   = { x = -50.03, y = -1089.18, z = 25.48 },
    Size  = { x = 1.5, y = 1.5, z = 1.0 },
    Type  = 27,
  },

  GoUpFrom = {
    Pos   = { x = -139.36, y = -588.83, z = 166.03 },
    Size  = { x = 1.5, y = 1.5, z = 1.0 },
    Type  = 27,
  },

}