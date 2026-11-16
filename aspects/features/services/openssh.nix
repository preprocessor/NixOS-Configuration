{
  modules.host.xyz = { constants, ... }: {
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        PermitEmptyPasswords = false;
        KbdInteractiveAuthentication = false;
      };
    };

    users.users.${constants.username}.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICkCeWsgSWc7pbDNm3rpBg6nmK7DEjI/6TrZaKR3ueOr shorekeeper"
    ];
  };
}
