{
  exo.mods.neovim =
    { lib, ... }:
    {
      diagnostic.settings = {
        virtual_lines = false;
        # virtual_text = {
        #   prefix = "";
        #   format = lib.nixvim.mkRaw /* lua */ ''
        #     function(diagnostic)
        #       local function prefix_diagnostic(prefix)
        #         return string.format(prefix .. ' %s', diagnostic.message)
        #       end
        #       local severity = diagnostic.severity
        #       if severity == vim.diagnostic.severity.ERROR then
        #         return prefix_diagnostic('󰅚')
        #       end
        #       if severity == vim.diagnostic.severity.WARN then
        #         return prefix_diagnostic('⚠')
        #       end
        #       if severity == vim.diagnostic.severity.INFO then
        #         return prefix_diagnostic('ⓘ')
        #       end
        #       if severity == vim.diagnostic.severity.HINT then
        #         return prefix_diagnostic('󰌶')
        #       end
        #       return prefix_diagnostic('■')
        #     end
        #   '';
        # };
        signs.text.vim.diagnostic.severity = {
          ERROR = "󰅚";
          WARN = "⚠";
          INFO = "ⓘ";
          HINT = "󰌶";
        };
        update_in_insert = false;
        underline = true;
        severity_sort = true;
        float = {
          focusable = false;
          style = "minimal";
          border = "single";
          source = "if_many";
          header = "";
          prefix = "";
        };
      };

      plugins.lsp = {
        enable = true;
        servers = {
          typos_lsp = {
            enable = true;
            extraOptions.init_options.diagnosticSeverity = "Hint";
          };
        };
      };

      lsp = {
        inlayHints.enable = true;
        keymaps = [
          {
            key = "<leader>l";
            action = lib.nixvim.mkRaw /* lua */ ''
              function()
                vim.diagnostic.open_float { border = 'single' }
              end
            '';
            options.desc = "[L]ine diagnostics";
            mode = "n";
          }
          {
            key = "<C-]>";
            lspBufAction = "definition";
            options.desc = "Definition";
            mode = "n";
          }
          {
            key = "<leader>cr";
            lspBufAction = "rename";
            options.desc = "[R]ename";
            mode = "n";
          }
          {
            key = "ga";
            lspBufAction = "code_action";
            options.desc = "[G]oto Code [A]ction";
            mode = [
              "n"
              "x"
            ];
          }
          {
            key = "gd";
            lspBufAction = "definition";
            options.desc = "Goto Definition";
            mode = "n";
          }
          {
            key = "gr";
            lspBufAction = "references";
            options.desc = "References";
            mode = "n";
          }
          {
            key = "gI";
            lspBufAction = "implementation";
            options.desc = "Goto Implementation";
            mode = "n";
          }
          {
            key = "gy";
            lspBufAction = "type_definition";
            options.desc = "Goto T[y]pe Definition";
            mode = "n";
          }
          {
            key = "gD";
            lspBufAction = "declaration";
            options.desc = "Goto Declaration";
            mode = "n";
          }
        ];
      };
    };
}
