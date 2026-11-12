{
  modules.features.desktop = { scheme, self, ... }: {
    imports = [ self.hjemModules.fuzzel ];

    my.fuzzel = {
      enable = true;

      settings = {
        main = {
          launch-prefix = "app2unit --";
          namespace = "fuzzel";
          render-workers = 10;
          match-workers = 10;
          horizontal-pad = 14;
          vertical-pad = 14;
          prompt = ''"Run: "'';
          font = "SF Pro Display:weight=Medium:size=16";
        };

        colors = with scheme.noHashtag; {
          background = "${base11}e5";
          text = "${base05}ff";
          match = "${bright-magenta}ff";
          selection-match = "${bright-magenta}ff";
          selection = "${base00}ff";
          selection-text = "${bright-cyan}ff";
          border = "${bright-cyan}ff";
        };

        border = {
          radius = 0;
          selection-radius = 0;
        };
      };
    };
  };
}
