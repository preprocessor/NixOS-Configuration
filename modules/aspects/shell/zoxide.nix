{
  flake.modules.nixos.default = {
    programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
