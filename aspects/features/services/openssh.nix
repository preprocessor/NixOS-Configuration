{
  modules.host.xyz = { constants, ... }: {
    services.openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        PermitEmptyPasswords = false;
        KbdInteractiveAuthentication = false;
      };
    };

    users.users.${constants.username}.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB090gyVUFUA85M9cAjah1Me0juj+ZvfKjr8WZqrSAjm"
    ];
  };

  modules.host.ramiel = {
    hj.files.".ssh/config".text = ''
      Host github.com
        HostName github.com
        User git
        IdentityFile ~/.ssh/id_ed25519
        IdentitiesOnly yes
    '';
  };
}
