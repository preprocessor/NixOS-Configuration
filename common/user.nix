{
  inputs,
  config,
  pkgs,
  ...
}:
{
  users.users.wyspr = {
    isNormalUser = true;
    description = "wyspr";
    initialPassword = "password";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.fish;
  };
}
