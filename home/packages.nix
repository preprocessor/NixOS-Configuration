{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./ghostty/ghostty.nix
    ./shell
    ./direnv.nix
    ./fuzzel.nix
    ./git.nix
    ./gtk.nix
    ./nh.nix
    ./nixcord.nix
    ./vicinae.nix
    ./xdg.nix
    ./zed.nix
  ];

  programs.home-manager.enable = true;

  programs.nix-index-database.comma.enable = true;

  services.swww.enable = true;
  systemd.user.services.swww.Unit.ConditionEnvironment = lib.mkForce "";

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

      gimp = pkgs.gimp.overrideAttrs (
        finalAttrs: previousAttrs: {
          postInstall = ''
            cp $out/share/gimp/3.0/icons/Default/scalable/apps/image-missing-symbolic.svg  $out/share/gimp/3.0/icons/Legacy/scalable/apps/image-missing-symbolic.svg
            cp $out/share/gimp/3.0/icons/Default/scalable/apps/image-missing.svg           $out/share/gimp/3.0/icons/Legacy/scalable/apps/image-missing.svg
          '';
        }
      );
    in
    [
      wyspr-eye
      wyspr-gbc
      wyspr-waow
      inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
      capitaine-cursors-themed
      gimp
      gruvbox-dark-gtk
      prismlauncher
      virtualbox
      vivaldi
      delta
      steam
    ];
}
