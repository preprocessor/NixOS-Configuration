{
  modules.host.ramiel =
    { self', ... }:
    {
      my.gtk.cursor = {
        package = self'.legacyPackages.retrosmart-classic;
        name = "retrosmart-xcursor-mac-ish-white-shadow";
        size = 32;
      };
    };
}
