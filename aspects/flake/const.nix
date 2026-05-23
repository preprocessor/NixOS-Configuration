{
  w.default =
    let
      constants = {
        stateVersion = "25.11";
        username = "wyspr";
        homedir = "/home/wyspr";
        cfgdir = "/home/wyspr/Configuration/NixOS";
      };
    in
    {
      _module.args = { inherit constants; };
    };
}
