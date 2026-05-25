{ ... }@top:
let
  resize = top.config.utils.otterResize;
in
{
  w.default =
    { pkgs, ... }:
    {
      hj.packages = with pkgs; [
        cliamp
        yt-dlp
      ];

      wrappers.otter-launcher.modules = [
        {
          cmd = resize 500 1000 "cliamp $(wl-paste)";
          description = "youtube player";
          prefix = "amp";
        }
      ];
    };
}
