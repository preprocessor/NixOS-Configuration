{ self, ... }:
{
  flake.modules.nixos.default = {
    home-manager.users."${self.const.username}".home = {
      username = "${self.const.username}";
      homeDirectory = "${self.const.homedir}";
    };

    hjem.users."${self.const.username}" = {
      enable = true;
      user = "${self.const.username}";
      directory = "${self.const.homedir}";
    };

    users.users."${self.const.username}" = {
      description = "${self.const.username}";
      isNormalUser = true;
      initialPassword = "password"; # for VMs
      extraGroups = [
        "networkmanager"
        "wheel"
        "docker"
      ];
    };
  };
}
