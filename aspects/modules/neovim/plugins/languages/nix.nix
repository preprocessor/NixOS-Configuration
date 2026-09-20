{
  exo.mods.neovim =
    { pkgs, ... }:
    {
      extraPackages = [ pkgs.nixfmt-rs ];

      plugins = {
        nix.enable = true;
        conform-nvim.settings.formatters_by_ft.nix = [ "nixfmt" ];
        lsp.servers.nixd = {
          enable = true;

          settings = {
            nixpkgs.expr = "import <nixpkgs> { }";
            formatting.command = [ "nixfmt" ];
            options = {
              nixos.expr = ''(builtins.getFlake ("git+file://" + toString /home/wyspr/Configuration/NixOS/)).nixosConfigurations.ramiel.options'';
              hjem.expr = "(builtins.getFlake (builtins.toString /home/wyspr/Configuration/NixOS/)).nixosConfigurations.ramiel.options.hjem.users.type.getSubOptions []";
              # wrappers. expr = "(builtins.getFlake ("git+file://" + toString /home/wyspr/Configuration/NixOS/)).nixosConfigurations.ramiel.config.wrappers";
            };
          };
        };
      };
    };
}
