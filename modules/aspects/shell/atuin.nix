{
  flake.modules.nixos.default =
    { pkgs, ... }:
    {
      hj.packages = [ pkgs.atuin ];

      hj.xdg.config.files."atuin/config.toml".text = /* toml */ ''
        enter_accept = true
        filter_mode = "session"
      '';
    };
}
