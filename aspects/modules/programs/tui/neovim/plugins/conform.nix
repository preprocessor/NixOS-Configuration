{
  exo.mods.neovim =
    { pkgs, lib, ... }:
    {
      keymaps = [
        {
          action = lib.nixvim.mkRaw /* lua */ ''
            function()
              require('conform').format { async = true, lsp_format = 'fallback' }
            end
          '';
          key = "<leader>f";
          mode = "n";
          options = {
            desc = "[F]ormat buffer";
            silent = true;
          };
        }
      ];

      plugins.conform-nvim = {
        enable = true;
        settings = {
          default_format_opts.lsp_format = "prefer";
          formatters_by_ft =
            let
              shell_formatters = [
                "shellcheck"
                "shellharden"
                "shfmt"
              ];
            in
            {
              "_" = [
                "squeeze_blanks"
                "trim_whitespace"
                "trim_newlines"
              ];
              xml = [ "xmllint" ];
              yaml = [ "yamlfix" ];
              json = [ "fixjson" ];
              toml = [ "taplo" ];
              bash = shell_formatters;
              sh = shell_formatters;
              zsh = shell_formatters;
              nushell = shell_formatters;
            };
          formatters = {
            xmllint.command = lib.getExe' pkgs.libxml2 "xmllint";
            squeeze_blanks.command = lib.getExe' pkgs.coreutils "cat";
            fixjson.command = lib.getExe pkgs.fixjson;
            yamlfix.command = lib.getExe pkgs.yamlfix;
            shellcheck.command = lib.getExe pkgs.shellcheck;
            shfmt.command = lib.getExe pkgs.shfmt;
            shellharden.command = lib.getExe pkgs.shellharden;
            taplo = {
              command = lib.getExe pkgs.taplo;
              args = [ "format" ];
            };
          };
          notify_on_error = false;
          format_on_save = lib.nixvim.mkRaw /* lua */ ''
            function(bufnr)
              -- Disable "format_on_save lsp_fallback" for languages that don't
              -- have a well standardized coding style. You can add additional
              -- languages here or re-enable it for the disabled ones.
              local disable_filetypes = { c = true, cpp = true }
              if disable_filetypes[vim.bo[bufnr].filetype] then
                return nil
              else
                return {
                  timeout_ms = 500,
                  lsp_format = 'fallback',
                }
              end
            end'';
        };
      };
    };
}
