{
  exo.mods.neovim =
    { lib, ... }:
    let
      inherit (lib.nixvim) mkRaw listToUnkeyedAttrs;
    in
    {
      globals = {
        mapleader = " ";
        maplocalleader = " ";
      };

      keymaps = [
        {
          action = mkRaw /* lua */ ''
            function()
              require('which-key').show { global = false }
            end
          '';
          key = "<leader>?";
          mode = "n";
          options.desc = "Buffer Keymaps (which-key)";
        }
        {
          action = mkRaw /* lua */ ''
            function()
              require('which-key').show { keys = '<c-w>', loop = true }
            end
          '';
          key = "<c-w><space>";
          mode = "n";
          options.desc = "Window Hydra Mode (which-key)";
        }
      ];

      plugins.which-key = {
        enable = true;

        lazyLoad.settings.event = [ "DeferredUIEnter" ];

        settings.spec =
          listToUnkeyedAttrs [
            {
              __unkeyed-1 = "<leader><tab>";
              group = "tabs";
            }
            {
              __unkeyed-1 = "<leader>c";
              group = "code";
            }
            {
              __unkeyed-1 = "<leader>d";
              group = "debug";
            }
            {
              __unkeyed-1 = "<leader>dp";
              group = "profiler";
            }
            {
              __unkeyed-1 = "<leader>f";
              group = "file/find";
            }
            {
              __unkeyed-1 = "<leader>g";
              group = "git";
            }
            {
              __unkeyed-1 = "<leader>gh";
              group = "hunks";
            }
            {
              __unkeyed-1 = "<leader>q";
              group = "quit/session";
            }
            {
              __unkeyed-1 = "<leader>s";
              group = "search";
            }
            {
              __unkeyed-1 = "<leader>u";
              group = "ui";
            }
            {
              __unkeyed-1 = "<leader>x";
              group = "diagnostics/quickfix";
            }
            {
              __unkeyed-1 = "<leader>sn";
              group = "noice";
            }
            {
              __unkeyed-1 = "[";
              group = "prev";
            }
            {
              __unkeyed-1 = "]";
              group = "next";
            }
            {
              __unkeyed-1 = "g";
              group = "goto";
            }
            {
              __unkeyed-1 = "gs";
              group = "surround";
            }
            {
              __unkeyed-1 = "z";
              group = "fold";
            }
            {
              __unkeyed-1 = "<leader>b";
              group = "buffer";
              expand = mkRaw /* lua */ ''
                function()
                  return require("which-key.extras").expand.buf()
                end
              '';
            }
            {
              __unkeyed-1 = "<leader>w";
              group = "windows";
              proxy = "<c-w>";
              expand = mkRaw /* lua */ ''
                function()
                  return require("which-key.extras").expand.win()
                end
              '';
            }
            {
              __unkeyed-1 = "gx";
              desc = "Open with system app";
            }

          ]
          // {
            mode = [
              "n"
              "x"
            ];
          };
      };
    };

}
