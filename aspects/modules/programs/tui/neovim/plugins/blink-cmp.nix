{
  exo.mods.neovim = {
    plugins.blink-ripgrep.enable = true;
    plugins.blink-cmp-dictionary.enable = true;

    plugins.blink-cmp = {
      enable = true;
      settings = {
        keymap = {
          # 'default' (recommended) for mappings similar to built-in completions
          #   <c-y> to accept ([y]es) the completion.
          #    This will auto-import if your LSP supports it.
          #    This will expand snippets if the LSP sent a snippet.
          # 'super-tab' for tab to accept
          # 'enter' for enter to accept
          # 'none' for no mappings
          #
          # For an understanding of why the 'default' preset is recommended;
          # you will need to read `:help ins-completion`
          #
          # No, but seriously. Please read `:help ins-completion`, it is really good!
          #
          # All presets have the following mappings:
          # <tab>/<s-tab>: move to right/left of your snippet expansion
          # <c-space>: Open menu or open docs if already open
          # <c-n>/<c-p> or <up>/<down>: Select next/previous item
          # <c-e>: Hide menu
          # <c-k>: Toggle signature help
          #
          # See :h blink-cmp-config-keymap for defining your own keymap
          preset = "enter";
          "<Tab>" = [
            "select_next"
            "fallback"
          ];
          "<S-Tab>" = [
            "select_prev"
            "fallback"
          ];

          # For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
          #    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
        };

        appearance = {
          # sets the fallback highlight groups to nvim-cmp's highlight groups
          # useful for when your theme doesn't support blink.cmp
          # will be removed in a future release, assuming themes add support
          use_nvim_cmp_as_default = false;
          # 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
          # Adjusts spacing to ensure icons are aligned
          nerd_font_variant = "mono";
        };

        completion = {
          # experimental auto-brackets support
          accept.auto_brackets.enabled = true;
          ghost_text.enabled = false;
          list.selection = {
            preselect = false;
            auto_insert = true;
          };
          menu.draw.treesitter = [ "lsp" ];
          documentation = {
            auto_show = true;
            auto_show_delay_ms = 200;
          };
        };

        sources = {
          default = [
            "lsp"
            "path"
            "snippets"
            "buffer"
            "dictionary"
            "ripgrep"
          ];
          providers = {
            dictionary = {
              module = "blink-cmp-dictionary";
              name = "Dict";
              min_keyword_length = 1;
              opts = {
                # Optional: explicitly force fallback mode
                # (By default, fallback is used when fzf is not found)
                force_fallback = true;
              };
            };
            ripgrep = {
              async = true;
              module = "blink-ripgrep";
              name = "Ripgrep";
              score_offset = 100;
              opts = {
                prefix_min_len = 3;
                context_size = 5;
                max_filesize = "1M";
                project_root_marker = ".git";
                project_root_fallback = true;
                search_casing = "--ignore-case";
                additional_rg_options = { };
                fallback_to_regex_highlighting = true;
                ignore_paths = { };
                additional_paths = { };
                debug = false;
              };
            };
          };
        };

        snippets = {
          preset = "luasnip";
        };

        # Blink.cmp includes an optional, recommended rust fuzzy matcher;
        # which automatically downloads a prebuilt binary when enabled.
        #
        # By default, we use the Lua implementation instead, but you may enable
        # the rust implementation via `'prefer_rust_with_warning'`
        #
        # See :h blink-cmp-config-fuzzy for more information
        fuzzy = {
          implementation = "lua";
        };

        # Shows a signature help window while you type arguments for a function
        signature = {
          enabled = true;
        };
      };
    };

  };
}
