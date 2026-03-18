{ inputs, ... }:
{
  flake.modules.homeManager.default =
    { pkgs, ... }:
    let
      apple-fonts = inputs.apple-fonts.packages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      programs.tofi = {
        enable = true;
        settings = {
          width = "100%";
          height = "100%";
          border-width = 0;
          outline-width = 0;
          padding-left = "35%";
          padding-top = "35%";
          result-spacing = 25;
          num-results = 5;
          font = "${apple-fonts.sf-pro}/share/fonts/truetype/SF-Pro.ttf";
          background-color = "#000A";
        };
      };

      programs.anyrun = {
        enable = true;
        config = {
          x = {
            fraction = 0.5;
          };
          y = {
            fraction = 0.3;
          };
          width = {
            fraction = 0.3;
          };
          hideIcons = false;
          ignoreExclusiveZones = false;
          layer = "overlay";
          hidePluginInfo = true;
          closeOnClick = false;
          showResultsImmediately = false;
          maxEntries = null;

          plugins = [
            # The order of plugins here specifies the order in which they appear in the results
            "${pkgs.anyrun}/lib/libapplications.so" # Search and run system & user specific desktop entries
            "${pkgs.anyrun}/lib/libshell.so" # Run shell commands
            "${pkgs.anyrun}/lib/libkidex.so" # File search provided by Kidex
            "${pkgs.anyrun}/lib/librink.so" # Calculator & unit conversion
          ];
        };

        # extraCss = /* css */ ''
        #   .some_class {
        #     background: red;
        #   }
        # '';

        extraConfigFiles."applications.ron".text = ''
          Config(
            hide_description: true,

            terminal: Some(Terminal(
              // The main terminal command
              command: "ghostty",
              // What arguments should be passed to the terminal process to run the command correctly
              // {} is replaced with the command in the desktop entry
              args: "-e {}",
            )),
          )
        '';
      };
    };
}
