{ self, ... }:
{
  flake.modules.nixos.default =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      home-manager.users."${self.const.username}".home = {
        username = "${self.const.username}";
        homeDirectory = "/home/${self.const.username}";
      };

      users.users."${self.const.username}" = {
        description = "${self.const.username}";
        isNormalUser = true;
        initialPassword = "password";
        shell = pkgs.fish;
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
      };
    };
}
