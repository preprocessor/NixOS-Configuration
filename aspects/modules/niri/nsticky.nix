{
  ff.nsticky.url = "github:lonerOrz/nsticky";

  w.default =
    {
      inputs',
      lib,
      pkgs,
      ...
    }:
    {
      hj.packages = [ inputs'.nsticky.packages.default ];

      wrappers.niri.settings.spawn-at-startup = [ "nsticky" ];

      hj.xdg.config.files."nsticky/config.toml".text = ''
        [sticky.otter]
        app_id = "otter"
        title = "otter-launcher"
      '';
    };
}
