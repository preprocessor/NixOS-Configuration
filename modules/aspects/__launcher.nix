{
  flake.modules.homeManager.default =
    { pkgs, ... }:
    {
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
            "${pkgs.anyrun}/lib/libsymbols.so" # Search unicode symbols
          ];
        };

        # extraCss = /* css */ ''
        #   .some_class {
        #     background: red;
        #   }
        # '';

        extraConfigFiles."symbols.ron".text = ''
          Config(
            prefix: ":sym",
            // Custom user defined symbols to be included along the unicode symbols
            symbols: {
              // "name": "text to be copied"
              "shrug": "¯\\_(ツ)_/¯",
            },
            max_entries: 3,
          )
        '';

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
