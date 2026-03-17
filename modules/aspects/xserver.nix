{
  flake.modules.nixos.default.services.xserver = {
    enable = true; # Enable the X11 windowing system.

    # Configure keymap in X11
    xkb = {
      layout = "us";
      variant = "";
    };
  };
}
