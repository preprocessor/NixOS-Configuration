{
  exo.mods.neovim =
    { pkgs, ... }:
    {
      extraPackages = [ pkgs.stylua ];

      plugins.lsp.servers.lua_ls = {
        enable = true;
        settings.diagnostics = {
          disable = [ "miss-name" ];
          globals = [
            "vim"
            "cmp"
            "Snacks"
          ];
        };
      };
      plugins.conform-nvim.settings.formatters_by_ft.lua = [ "stylua" ];
    };
}
