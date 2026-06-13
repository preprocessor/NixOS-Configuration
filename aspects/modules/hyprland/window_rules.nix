{
  w.desktop = {
    wrappers.hyprland.lua.files = {
      "window_rules".content = /* lua */ ''
        ---@class FloatRule
        ---@field width    integer    width as percent of monitor width  (1..100)
        ---@field height   integer    height as percent of monitor height (1..100)
        ---@field patterns string[]   Lua patterns matched against window title

        ---@type FloatRule[]
        local rules = {
          {
            width = 30,
            height = 54,
            patterns = {
              "%(Bitwarden.*Password Manager%) %- Bitwarden",
              "^Bitwarden$",
              "^Vivaldi Settings",
            }
          },
        }

        ---Return true if `title` matches any pattern in `rule`.
        ---@param title string
        ---@param rule  FloatRule
        ---@return boolean
        local function matches(title, rule)
          for _, pattern in ipairs(rule.patterns) do
            if title:match(pattern) then return true end
          end
          return false
        end

        hl.on("window.title", function(window)
          local title = window.title or ""
          for _, rule in ipairs(rules) do
            if matches(title, rule) then
              local monitor = hl.get_active_monitor()
              if not monitor then return end

              hl.dispatch(hl.dsp.window.float({ window = window, action = "on" }))
              hl.dispatch(hl.dsp.window.center({ window = window, action = "on" }))
              hl.dispatch(hl.dsp.window.resize({
                window = window,
                x = math.floor(monitor.width * rule.width / 180),
                y = math.floor(monitor.height * rule.height / 80),
              }))
              return
            end
          end
        end)

        hl.window_rule({
          -- Fix some dragging issues with XWayland
          name     = "fix-xwayland-drags",
          match    = {
            class      = "^$",
            title      = "^$",
            xwayland   = true,
            float      = true,
            fullscreen = false,
            pin        = false,
          },

          no_focus = true,
        })


        hl.window_rule({
          -- Ignore maximize requests from all apps
          name           = "suppress-maximize-events",
          match          = { class = ".*" },

          suppress_event = "maximize",
        })

        -- Hyprland-run windowrule
        hl.window_rule({
          name  = "move-hyprland-run",
          match = { class = "hyprland-run" },

          move  = "20 monitor_h-120",
          float = true,
        })

        hl.window_rule({
          name  = "pip",
          match = {
            title = "^Picture[- ]in[- ][Pp]icture$"
          },
          move  = "monitor_w-600 monitor_h-400",

          float = true,
        })

        hl.window_rule({
          name         = "file-chooser",
          match        = { class = "^FileChooser$" },

          border_color = "rgb(ff2200)",
          size         = "1700 1100",
          center       = true,
          float        = true,
        })

        hl.window_rule({
          name = "hide windows",
          match = {
            title = "(login|signin|log in|sign in|mail)"
          },
          no_screen_share = true,
          border_color = "rgb(ff0d2d)",
          border_size = 3,
        })
      '';
    };
  };
}
