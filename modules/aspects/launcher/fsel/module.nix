{
  ff.fsel.url = "github:Mjoyufull/fsel";

  perSystem =
    { pkgs, ... }:
    {
      packages.fsel = pkgs.rustPlatform.buildRustPackage {
        pname = "fsel";
        version = "0-unstable-2026-04-19";

        src = pkgs.fetchFromGitHub {
          owner = "Mjoyufull";
          repo = "fsel";
          rev = "ad49c5d96bb1b1b738c5ce6f4410ecffea8adb5c";
          hash = "sha256-pBQMSlEUICEfmzA+oSonzH0JlAcBjsVE0gT0QwsTNFE=";
        };

        nativeBuildInputs = [ pkgs.pkg-config ];
        buildInputs = [ pkgs.pkg-config ];

        doCheck = false;

        # install man page
        postInstall = ''
          install -Dm644 fsel.1 $out/share/man/man1/fsel.1
        '';

        cargoHash = "sha256-hNDiVdEOT3X6YSjggZgj1ZMpy4Ttcu3H7UKe/R1pJfY=";
      };
    };

  w.default =
    {
      wrappers,
      config,
      self',
      pkgs,
      lib,
      ...
    }:
    let
      toml = pkgs.formats.toml { };
      inherit (lib) mkOption types;
      cfg = config.wrappers.fsel;
    in
    {
      options.wrappers.fsel = {
        enable = lib.mkEnableOption { };

        settings = mkOption {
          inherit (toml) type;
          default = { };
          description = ''
            Configuration of fsel.
            See {manpage}`fsel(1)`
          '';
        };

        moreCfg = mkOption {
          type = with types; nullOr (either path lines);
          default = "";
          description = "Additional config lines.";
          example = lib.literalExpression "./config.toml";
        };

        package = mkOption {
          type = types.package;
          default = wrappers.lib.wrapPackage (
            { config, lib, ... }:
            {
              inherit pkgs;
              package = self'.packages.fsel;
              flags = {
                "--config" = config.constructFiles.generatedConfig.path;
              };
              constructFiles.generatedConfig = {
                relPath = "config.toml";
                content = (cfg.settings |> toml.generate "config.toml" |> builtins.readFile) + cfg.moreCfg;
              };
            }
          );
        };

      };

      config = lib.mkIf (cfg.enable) {
        hj.packages = [ cfg.package ];
      };

      _file = ./module.nix;
    };
}
