{
  exo.mods.neovim =
    { scheme, lib, ... }:
    let
      inherit (lib.nixvim) mkRaw;
    in
    {
      colorschemes.catppuccin = {
        enable = true;
        settings = {
          flavour = "mocha"; # latte; frappe; macchiato; mocha
          transparent_background = true; # disables setting the background color.
          float = {
            transparent = true; # enable transparent floating windows
            solid = true; # use solid styling for floating windows; see |winborder|
          };
          term_colors = false; # sets terminal colors (e.g. `g:terminal_color_0`)
          dim_inactive = {
            enabled = false; # dims the background color of inactive window
            shade = "dark";
            percentage = 0.15; # percentage of the shade to apply to the inactive window
          };
          no_italic = false; # Force no italic
          no_bold = false; # Force no bold
          no_underline = false; # Force no underline
          styles = {
            # Handles the styles of general hi groups (see `:h highlight-args`):
            comments = [ "italic" ]; # Change the style of comments
            conditionals = [ "italic" ];
            # loops = {};
            # functions = {};
            # keywords = {};
            # strings = {};
            # variables = {};
            # numbers = {};
            # booleans = {};
            # properties = {};
            # types = {};
            # operators = {};
            # miscs = {}; # Uncomment to turn off hard-coded styles
          };
          lsp_styles = {
            # Handles the style of specific lsp hl groups (see `:h lsp-highlight`).
            virtual_text = {
              errors = [ "italic" ];
              hints = [ "italic" ];
              warnings = [ "italic" ];
              information = [ "italic" ];
              ok = [ "italic" ];
            };
            underlines = {
              errors = [ "underline" ];
              hints = [ "underline" ];
              warnings = [ "underline" ];
              information = [ "underline" ];
              ok = [ "underline" ];
            };
            inlay_hints.background = true;
          };
          color_overrides.mocha = {
            rosewater = scheme.base05;
            flamingo = scheme.base05;

            pink = scheme.magenta;
            mauve = scheme.magenta;

            red = scheme.red;
            maroon = scheme.red;

            peach = scheme.bright-yellow;
            yellow = scheme.yellow;

            green = scheme.bright-green;
            teal = scheme.green;

            sky = scheme.cyan;
            sapphire = scheme.cyan;

            blue = scheme.bright-blue;
            lavender = scheme.blue;

            text = scheme.base05;
            subtext1 = scheme.base06;
            subtext0 = scheme.base07;
            overlay2 = scheme.base04;
            overlay1 = scheme.base03;
            overlay0 = "#C4C4C4";
            surface2 = "#606060";
            surface1 = scheme.base02;
            surface0 = scheme.base01;
            base = scheme.base00;
            mantle = scheme.base10;
            crust = scheme.base11;
          };
          highlight_overrides.mocha = mkRaw /* lua */ ''
            function(mocha)
              return {
                Comment = { fg = mocha.surface2, style = { 'italic' } },
                SignColumn = { bg = mocha.base },
                CursorLineNr = { bg = mocha.base },
                LineNr = { bg = mocha.mantle },
                RenderMarkdownH1Bg = { bg = '#1e2e2f', fg = '#3e787b' },
                RenderMarkdownH1 = { fg = '#3e787b' },
              }
            end
          '';
          default_integrations = true;
          auto_integrations = false;
          integrations = {
            blink_cmp.style = "bordered";
            blink_indent = true;
            blink_pairs = true;
            gitsigns = true;
            grug_far = true;
            notify = true;
            hop = true;
            mini.enabled = true;
            noice = true;
            snacks.enabled = true;
            render_markdown = true;
            lsp_trouble = true;
            which_key = true;
            lualine.mocha = mkRaw /* lua */ ''
              function(mocha)
                return {
                  normal = {
                    a = { bg = mocha.blue, fg = mocha.mantle, gui = 'bold' },
                    b = { bg = mocha.surface0, fg = mocha.blue },
                    c = { bg = 'NONE', fg = mocha.text },
                  },

                  insert = {
                    a = { bg = mocha.green, fg = mocha.base, gui = 'bold' },
                    b = { bg = mocha.surface0, fg = mocha.green },
                  },

                  terminal = {
                    a = { bg = mocha.green, fg = mocha.base, gui = 'bold' },
                    b = { bg = mocha.surface0, fg = mocha.green },
                  },

                  command = {
                    a = { bg = mocha.peach, fg = mocha.base, gui = 'bold' },
                    b = { bg = mocha.surface0, fg = mocha.peach },
                  },
                  visual = {
                    a = { bg = mocha.mauve, fg = mocha.base, gui = 'bold' },
                    b = { bg = mocha.surface0, fg = mocha.mauve },
                  },
                  replace = {
                    a = { bg = mocha.red, fg = mocha.base, gui = 'bold' },
                    b = { bg = mocha.surface0, fg = mocha.red },
                  },
                  inactive = {
                    a = { bg = 'NONE', fg = mocha.blue },
                    b = { bg = 'NONE', fg = mocha.surface1, gui = 'bold' },
                    c = { bg = 'NONE', fg = mocha.overlay0 },
                  },
                }
              end
            '';
          };
        };
      };
    };
}
