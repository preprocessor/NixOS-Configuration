{ inputs, ... }:
{
  ff.otterlauncher = {
    url = "github:kuokuo123/otter-launcher";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.systems.follows = "systems";
    inputs.flake-parts.follows = "flake-parts";
  };

  w.desktop =
    { pkgs, ... }:
    {
      hj.packages = [
        (inputs.otterlauncher.packages.${pkgs.sys}.default.overrideAttrs {
          doCheck = false;
        })
      ];

      custom.programs.niri.settings.binds."Mod+Space" = _: {
        content.spawn = [
          # "tofi-drun | xargs --no-run-if-empty app2unit"
          "ghostty --gtk-quick-terminal-layer overlay -e otterlauncher"
        ];
        props.hotkey-overlay-title = "Open application launcher: fuzzel";
      };
    };
}
