{
  tack.inputs.helium.url = "gh:amaanq/helium-flake/";

  exo.skeleton =
    { packages', lib, ... }:
    {
      hj.packages = [ packages'.helium ];

      xdg.mime = lib.mkIf true {
        defaultApplications =
          [
            "application/x-extension-shtml"
            "application/x-extension-xhtml"
            "application/x-extension-html"
            "application/x-extension-xht"
            "application/x-extension-htm"
            "x-scheme-handler/unknown"
            "x-scheme-handler/https"
            "x-scheme-handler/http"
            "application/xhtml+xml"
            "application/json"
            "application/pdf"
            "text/html"
          ]
          |> map (mime: lib.nameValuePair mime [ "helium.desktop" ])
          |> lib.listToAttrs;
      };
      hj.environment.sessionVariables = lib.mkIf true { BROWSER = "helium"; };
    };
}
