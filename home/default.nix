{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./ghostty/ghostty.nix
    ./direnv.nix
    ./git.nix
    ./nh.nix
    ./nixcord.nix
    ./shell
    ./stylix.nix
    ./vicinae.nix
    ./xdg.nix
    ./zed.nix
  ];

  programs.home-manager.enable = true;

  programs.nix-index-database.comma.enable = true;

  home.packages =
    with pkgs;
    let
      wyspr-eye = pkgs.writeShellApplication {
        name = "eye";
        runtimeInputs = [ pkgs.coreutils ];
        text = (builtins.readFile ./bin/eye);
      };

      wyspr-gbc = pkgs.writeShellApplication {
        name = "gbc";
        runtimeInputs = [ pkgs.coreutils ];
        checkPhase = "";
        text = (builtins.readFile ./bin/gbc);
      };

      wyspr-waow = pkgs.writeShellApplication {
        name = "waow";
        checkPhase = "";
        runtimeInputs = [
          pkgs.coreutils
        ];
        text = (builtins.readFile ./bin/waow);
      };
    in
    [
      wyspr-eye
      wyspr-gbc
      wyspr-waow
      inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
      capitaine-cursors-themed
      gimp-with-plugins
      gruvbox-dark-gtk
      prismlauncher
      virtualbox
      vivaldi
      delta
      steam
    ];
}
