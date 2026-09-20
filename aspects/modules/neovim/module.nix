top: {
  tack.inputs.nixvim.url = "gh:nix-community/nixvim";

  exo.skeleton =
    {
      inputs,
      system,
      config,
      scheme,
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.my.nixvim;
    in
    {
      options.my.nixvim = {
        enable = lib.mkEnableOption { };

        package = lib.mkOption {
          default =
            (inputs.nixvim.lib.evalNixvim {
              inherit system;
              extraSpecialArgs = {
                inherit scheme inputs;
                pkgs = pkgs.appendOverlays [
                  (_: _: {
                    yazi = config.my.yazi.package;
                    lazygit = config.my.lazygit.package;
                  })
                ];
              };
              modules = [
                top.config.exo.mods.neovim
                (
                  { pkgs, ... }:
                  {
                    nixpkgs = { inherit pkgs; };
                    luaLoader.enable = false;
                    performance.byteCompileLua = {
                      enable = true;
                      plugins = true;
                      nvimRuntime = true;
                    };
                  }
                )
              ];
            }).config.build.package;
        };
      };

      config = lib.mkIf cfg.enable {
        hj.packages = [ cfg.package ];

        environment.variables = {
          EDITOR = "nvim";
          VISUAL = "nvim";
        };

        hj.xdg.mime-apps.default-applications = {
          "text/*" = [ "nvim.desktop" ];
        };

        my.xdg.desktopEntries = {
          nvim = {
            noDisplay = true;
            exec = "nvim %F";
            terminal = true;
            type = "Application";
            startupNotify = false;
            mimeType = [
              "text/english"
              "text/plain"
              "text/x-makefile"
              "text/x-c++hdr"
              "text/x-c++src"
              "text/x-chdr"
              "text/x-csrc"
              "text/x-java"
              "text/x-moc"
              "text/x-pascal"
              "text/x-tcl"
              "text/x-tex"
              "application/x-shellscript"
              "text/x-c"
              "text/x-c++"
            ];
            settings = {
              TryExec = "nvim";
            };
          };
        };
      };

      _file = ./module.nix;
    };
}
