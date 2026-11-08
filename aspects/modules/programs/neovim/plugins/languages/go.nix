{
  exo.mods.neovim =
    { pkgs, ... }:
    {
      extraPackages = [ pkgs.golangci-lint ];

      plugins.lsp.servers = {
        golangci_lint_ls = {
          enable = true;
          package = pkgs.golangci-lint-langserver;
        };
        gopls = {
          enable = true;
          package = pkgs.gopls;
        };
      };

      plugins.conform-nvim.settings.go = [ "gofmt" ];
    };
}
