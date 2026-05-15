{
  perSystem =
    { pkgs, lib, ... }:
    {
      packages.worldclocks = pkgs.buildGoModule (finalAttrs: {
        pname = "worldclocks";
        version = "1.0.2";

        src = pkgs.fetchFromGitHub {
          owner = "Solomon";
          repo = "worldclocks";
          tag = "v${finalAttrs.version}";
          hash = "sha256-XMTm2kzeL/qF1t9vzTioJUS9mivdIaq29TDKiB37VmY=";
        };

        vendorHash = "sha256-uwBJAqN4sIepiiJf9lCDumLqfKJEowQO2tOiSWD3Fig=";

        ldflags = [
          "-s"
          "-w"
          "-X=main.version=${finalAttrs.version}"
          "-X=main.commit=${finalAttrs.src.rev}"
          "-X=main.date=1970-01-01T00:00:00Z"
        ];

        meta = {
          description = "Terminal UI for showing world clocks";
          homepage = "https://github.com/Solomon/worldclocks";
          license = lib.licenses.mit;
          mainProgram = "worldclocks";
        };
      });
    };

  w.default =
    { self', ... }:
    {
      hj.packages = [ self'.packages.worldclocks ];

      hj.xdg.config.files."worldclocks".text = ''
        # timezone,country_code,include(Yes/No)
        America/New_York,US,Yes
        Europe/London,GB,Yes
        Europe/Berlin,DE,Yes

        America/Los_Angeles,US,No
        America/Denver,US,No
        America/Chicago,US,No
        America/New_York,US,No
        America/Toronto,CA,No
        America/Mexico_City,MX,No
        America/Sao_Paulo,BR,No
        America/Bogota,CO,No
        Europe/London,GB,No
        Europe/Paris,FR,No
        Europe/Berlin,DE,No
        Europe/Madrid,ES,No
        Europe/Rome,IT,No
        Europe/Moscow,RU,No
        Africa/Cairo,EG,No
        Africa/Johannesburg,ZA,No
        Africa/Nairobi,KE,No
        Asia/Jerusalem,IL,No
        Asia/Dubai,AE,No
        Asia/Kolkata,IN,No
        Asia/Bangkok,TH,No
        Asia/Hong_Kong,HK,No
        Asia/Tokyo,JP,No
        Asia/Seoul,KR,No
        Asia/Singapore,SG,No
        Australia/Sydney,AU,No
        Pacific/Auckland,NZ,No
        Pacific/Honolulu,US,No
        America/Anchorage,US,No
        America/Phoenix,US,No
      '';
    };
}
