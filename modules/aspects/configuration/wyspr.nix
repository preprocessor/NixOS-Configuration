{
  w.default =
    { constants, ... }:
    let
      inherit (constants) username homedir;
    in
    {
      # Will be referenced as "hj" in this flake
      hjem.users.${username} = {
        enable = true;
        user = username;
        directory = homedir;
      };

      users.users.${username} = {
        description = username;
        isNormalUser = true;
        initialPassword = "password"; # for VMs
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
      };
    };
}
