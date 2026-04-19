let
  browser = "vivaldi-stable.desktop";
in
{
  w.ramiel.hj.xdg.mime-apps = {
    default-applications = {
      "x-scheme-handler/discord" = "vesktop.desktop";
      "text/html" = browser;
      "x-scheme-handler/http" = browser;
      "x-scheme-handler/https" = browser;
      "x-scheme-handler/about" = browser;
      "x-scheme-handler/unknown" = browser;
    };
  };
}
