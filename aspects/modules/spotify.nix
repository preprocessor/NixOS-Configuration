{
  tack.inputs.spicetify-nix.url = "gh:Gerg-L/spicetify-nix";

  exo.mods.desktop =
    {
      inputs',
      inputs,
      scheme,
      config,
      lib,
      ...
    }:
    let
      spicePkgs = inputs'.spicetify-nix.legacyPackages;
      cfg = config.programs.spicetify;
    in
    {
      imports = [ inputs.spicetify-nix.nixosModules.default ];

      config = lib.mkMerge [
        {
          programs.spicetify = {
            enable = true;
            theme = spicePkgs.themes.text;
            customColorScheme = with scheme; {
              accent = magenta;
              accent-active = green;
              accent-inactive = base03;
              banner = green;
              border-active = orange;
              border-inactive = base01;
              header = base04;
              highlight = base03;
              main = base11;
              notification = bright-magenta;
              notification-error = base08;
              subtext = base04;
              text = base05;
            };

            enabledExtensions = with spicePkgs.extensions; [
              adblock
            ];
          };
        }

        (lib.mkIf cfg.enable {
          my.hyprland.windowrules.spotify = [
            {
              name = "spotify";
              match.class = "spotify";
              rules = {
                workspace = "name:media silent";
                scrolling_width = 0.5;
              };
            }
          ];
        })
      ];
    };
}
