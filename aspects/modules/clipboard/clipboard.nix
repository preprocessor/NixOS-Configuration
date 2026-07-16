{ inputs, ... }:
{
  tack = {
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
      self',
      pkgs,
      wrapPackage,
      ...
    }:
    {
      packages.cliphist = wrapPackage {
        env.CLIPHIST_MAX_STORE_SIZE = "1GB";

        package = pkgs.buildGoModule (final: {
          pname = "cliphist";
          version = "0-unstable-2026-04-21";
          src = inputs.cliphist-src;
          vendorHash = "sha256-fDl+ul1t2Ux1w5WcCo6YMJtrcC20o+eUEO3NNycSNvI=";
          buildInputs = [ pkgs.bash ];
          postInstall = ''
            cp ${final.src}/contrib/* $out/bin/
          '';
          patches = [ ./cliphist-fix-browser-copy-with-meta.patch ];
        });
      };

      packages.cliphist-tui = wrapPackage {
        package = pkgs.rustPlatform.buildRustPackage (final: {
          pname = "cliphist-tui";
          version = "0-unstable-2026-04-26";
          cargoLock.lockFile = final.src + "/Cargo.lock";
          src = inputs.cliphist-tui-src;
        });
        extraPkgs = [
          self'.packages.cliphist
          pkgs.ffmpegthumbnailer
          pkgs.chafa
        ];
      };

      _file = ./clipboard.nix;
    };

  exo.core =
    { self', pkgs, ... }:
    {
      hj.packages = [
        self'.packages.cliphist-tui
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
    {
      config,
      self',
      pkgs,
      lib,
      ...
    }:
    {
      my.otter-launcher.modules =
        let
          spawn = config.utils.hyprSpawn;
        in
        [
          {
            description = "board";
            prefix = "clip";
            cmd = spawn 800 1000 "cliphist-tui" (lib.getExe' self'.packages.cliphist-tui "cliphist-tui");
          }
        ];

      my.hyprland.startup = [
        ''hl.exec_cmd("${pkgs.wl-clip-persist}/bin/wl-clip-persist --clipboard regular")''
      ];

      _file = ./clipboard.nix;
    };
}
