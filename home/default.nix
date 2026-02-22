{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./direnv.nix
    ./ghostty/ghostty.nix
    ./git.nix
    ./neovim.nix
    ./nh.nix
    ./nixcord.nix
    ./shell.nix
    ./stylix.nix
    ./xdg.nix
    ./zed.nix
  ];

  programs.home-manager.enable = true;

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
      gruvbox-dark-gtk
      prismlauncher
      virtualbox
      vivaldi
      delta
      steam
      gimp
    ];
}
