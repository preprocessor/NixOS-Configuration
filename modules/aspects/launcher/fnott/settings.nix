{
  w.desktop = {
    wrappers.fnott = {
      enable = true;
      settings = {
        # For documentation on these options, see `man fnott.ini`

        # Global values
        globalSection = {
          output = null;
          min-width = 0;
          max-width = 0;
          max-height = 0;
          stacking-order = "bottom-up";
          anchor = "top-right";
          edge-margin-vertical = 10;
          edge-margin-horizontal = 10;
          notification-margin = 10;
          icon-theme = "hicolor";
          max-icon-size = 32;
          selection-helper = "dmenu";
          selection-helper-uses-null-separator = "no";
          play-sound = "aplay \${filename}";

          # Default values, may be overridden in 'urgency' specific sections
          layer = "top";
          background = "3f5f3fff";

          border-color = "909090ff";
          border-radius = 0;
          border-size = 1;

          padding-vertical = 20;
          padding-horizontal = 20;

          dpi-aware = "no";

          title-font = "sans serif";
          title-color = "ffffffff";
          title-format = "<i>%a%A</i>";

          summary-font = "sans serif";
          summary-color = "ffffffff";
          summary-format = "<b>%s</b>\n";

          body-font = "sans serif";
          body-color = "ffffffff";
          body-format = "%b";

          progress-bar-height = 20;
          progress-color = "ffffffff";
          progress-style = "bar";

          sound-file = null;
          icon = null;

          # Timeout values are in seconds. 0 to disable
          max-timeout = 0;
          default-timeout = 0;
          idle-timeout = 0;
        };
        sections = {
          low = {
            background = "2b2b2bff";
            title-color = "888888ff";
            summary-color = "888888ff";
            body-color = "888888ff";
          };

          normal = { };

          critical = {
            background = "6c3333ff";
          };
        };
      };
    };
  };
}
