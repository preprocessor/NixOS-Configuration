{
  flake.modules.nixos.default = {
    services.udisks2.enable = true;
  };

  flake.modules.homeManager.default =
    { pkgs, ... }:
    {
      services.udiskie = {
        enable = true;
        settings = {
          # workaround for
          # https://github.com/nix-community/home-manager/issues/632
          program_options = {
            # replace with your favorite file manager
            file_manager = "${pkgs.ghostty}/bin/ghostty -e ${pkgs.yazi}/bin/yazi";
          };
        };
      };
    };
}
