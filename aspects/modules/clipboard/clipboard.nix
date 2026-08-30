{ inputs, ... }:
{
  tack.inputs = {
    cliphist-src = {
      url = "gh:sentriz/cliphist";
      type = "fetch";
    };
    cliphist-tui-src = {
      url = "gh:SHORiN-KiWATA/cliphist-tui";
      type = "fetch";
    };
  };

  perSystem =
    {
      wrapPackage,
      self',
      pkgs,
      ...
    }:
    {
      packages.cliphist-tui = wrapPackage {
        package = pkgs.rustPlatform.buildRustPackage (final: {
          pname = "cliphist-tui";
          version = "0-unstable-2026-04-26";
          cargoLock.lockFile = final.src + "/Cargo.lock";
          src = inputs.cliphist-tui-src;
          allowSubstitutes = false;
          preferLocalBuild = true;
        });

        extraPkgs = [
          pkgs.ffmpegthumbnailer
          pkgs.chafa
        ];
      };

      packages.cliphist = wrapPackage {
        package = pkgs.buildGoModule (final: {
          pname = "cliphist";
          version = "0-unstable-2026-04-21";
          src = inputs.cliphist-src;
          allowSubstitutes = false;
          preferLocalBuild = true;
          vendorHash = "sha256-fDl+ul1t2Ux1w5WcCo6YMJtrcC20o+eUEO3NNycSNvI=";
          buildInputs = [ pkgs.bash ];
          postInstall = "cp ${final.src}/contrib/* $out/bin/ ";
          patches = [ ./cliphist-fix-browser-copy-with-meta.patch ];
        });

        env.CLIPHIST_MAX_STORE_SIZE = "1GB";
      };

      _file = ./clipboard.nix;
    };

  exo.core =
    { self', pkgs, ... }:
    {
      hj.packages = [
        self'.packages.cliphist-tui
        self'.packages.cliphist
        pkgs.wl-clipboard
      ];

      systemd.user.services = {
        cliphist-text = {
          description = "Clipboard history service (Text)";
          after = [ "graphical-session.target" ];
          partOf = [ "graphical-session.target" ];
          wantedBy = [ "graphical-session.target" ];

          serviceConfig = {
            ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch ${self'.packages.cliphist}/bin/cliphist store";
            Restart = "on-failure";
          };
        };

        cliphist-image = {
          description = "Clipboard history service (Images)";
          after = [ "graphical-session.target" ];
          partOf = [ "graphical-session.target" ];
          wantedBy = [ "graphical-session.target" ];

          serviceConfig = {
            ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --type image --watch ${self'.packages.cliphist}/bin/cliphist store";
            Restart = "on-failure";
          };
        };
      };
    };

  exo.host.ramiel =
    { self', lib, ... }:
    {
      my.hyprland.lua.files."keybinds.clipboard".content = /* lua */ ''
        hl.bind("SUPER + V", hl.dsp.exec_cmd('kitty -e ${lib.getExe' self'.packages.cliphist "cliphist-tui"}', {size = { 800, 1200}, float = true, center = true}))
      '';

      _file = ./clipboard.nix;
    };
}
