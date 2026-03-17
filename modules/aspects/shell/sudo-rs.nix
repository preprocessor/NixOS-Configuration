{
  flake.modules.nixos.default = {
    security = {
      sudo.enable = false;
      sudo-rs = {
        enable = true;
        wheelNeedsPassword = true;
        execWheelOnly = true;
        extraConfig = ''
          Defaults pwfeedback
        '';
      };
      polkit.enable = true;
    };
  };
}
