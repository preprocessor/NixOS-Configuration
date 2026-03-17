{
  flake.modules.homeManager.ramiel.dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-light";
    };
  };

  flake.modules.nixos.ramiel.programs.dconf.enable = true;
}
