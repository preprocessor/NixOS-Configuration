{ ... }:
{
  programs.vicinae = {
    enable = true;

    systemd.enable = true;

    settings = {
      faviconService = "twenty";
      font = {
        size = 10;
      };
      popToRootOnClose = false;
      rootSearch = {
        searchFiles = false;
      };
      theme = {
        name = "vicinae-dark";
      };
      window = {
        csd = true;
        opacity = 1.0;
        rounding = 0;
      };
    };

  };
}
