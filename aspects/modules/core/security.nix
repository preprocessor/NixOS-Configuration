{
  exo.core = {
    security = {
      sudo.enable = false;
      run0 = {
        enable = true;
        sudo-shim.enable = true;
        persistentAuth.enable = true;
      };
    };
  };
}
