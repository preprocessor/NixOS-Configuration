{
  exo.core =
    { constants, ... }:
    let
      inherit (constants) username;
    in
    {
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
