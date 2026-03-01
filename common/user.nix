{ pkgs, ... }:
let
  shell = pkgs.fish;
in
{
  environment.shells = [ shell ];

  users = {
    defaultUserShell = shell;

    users.wyspr = {
      isNormalUser = true;
      description = "wyspr";
      initialPassword = "password";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      inherit shell;
    };
  };
}
