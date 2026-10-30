{
  exo.mods.desktop =
    {
      scheme,
      pkgs,
      ...
    }:

    {
      my.hyprland.lua.files = {
        "keybinds.base".content = /* lua */ ''
          -- Close
          hl.bind("SUPER + CTRL + Q", hl.dsp.window.close())
          -- Float
          hl.bind("SUPER + Backslash", function() utils.float_center() end)
        '';

        "keybinds.zoom".content = /* lua */ ''
          local MAX_ZOOM = 5
          local MIN_ZOOM = 1
          local ZOOM_TOGGLE_FACTOR = 5

          ---@param offset number
          ---@return nil
          local function zoom(offset)
            local current = hl.get_config("cursor.zoom_factor")
            if offset ~= nil then
              current = current + offset
            elseif current ~= MIN_ZOOM then
              current = MIN_ZOOM
            else
              current = ZOOM_TOGGLE_FACTOR
            end
            current = math.max(MIN_ZOOM, math.min(MAX_ZOOM, current))
            hl.config({ cursor = { zoom_factor = current } })
          end

          hl.bind("SUPER + Z", zoom)
          hl.bind("SUPER + KP_Add", function()
            zoom(0.5)
          end)
          hl.bind("SUPER + KP_Subtract", function()
            zoom(-0.5)
          end)
        '';
      };
    };
}
