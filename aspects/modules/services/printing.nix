{
  exo.mods.printing =
    { pkgs, ... }:
    {
      my.xdg.desktopEntries."cups".noDisplay = true;

      # Enable CUPS to print documents.
      services.avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };

      services.printing = {
        enable = true;
        drivers = with pkgs; [
          cups-filters
          cups-browsed
        ];
      };
    };
}
