{
  exo.mods.neovim = {
    plugins = {
      lsp.servers.rust_analyzer = {
        enable = true;
        installCargo = false;
        installRustc = false;
        settings = {
          rust-analyzer = {
            checkOnSave = true;
            check = {
              command = "clippy";
              features = "all";
              invocationStrategy = "per_workspace";
            };
            diagnostics.enable = true;
            procMacro.enable = true;
            lens = {
              implementations.enable = true;
              references = {
                method.enable = true;
                adt.enable = true;
                trait.enable = true;
                enumVariant.enable = true;
              };
            };
            inlayHints = {
              enable = true;
              bindingModeHints.enable = true;
              closureReturnTypeHints.enable = "always";
              lifetimeElisionHints.enable = "always";
            };
          };
        };
      };

      conform-nvim.settings.formatters_by_ft.rust = [ "rustfmt" ];
    };
  };
}
