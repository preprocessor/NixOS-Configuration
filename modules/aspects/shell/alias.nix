{
  self,
  lib,
  inputs,
  ...
}:
{
  flake-file.inputs.bat-syntax-justfile = {
    url = "github:nk9/just_sublime";
    flake = false;
  };

  flake.modules.homeManager.default =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        uutils-coreutils-noprefix
      ];

      programs = {
        fish = {
          shellAliases =
            let
              lla = lib.getExe pkgs.lla;
            in
            {
              l = lla + " -T";
              ls = lla;
              la = lla + " -AT";
              ll = lla + " -Al";
              lss = lla + " -S";

              man = "batman";
              cat = "bat --plain";

              gr = "cd (git rev-parse --show-toplevel)"; # cd to git root

              cp = "cp -r";
              mkdir = "mkdir -p";

              rm = "trash-put";
              rmdir = "trash-put";

              write-flake = "nix run ${self.const.cfgdir}/#write-flake";
              repl = "nix repl --file ${self.const.cfgdir}/repl.nix";
            };

          shellAbbrs = {
            ga = "git add .";
            clone = "git clone";
            cls = "clear";

            rb = "nh os switch";
            ost = "nh os test";

            wf = "write-flake";

            v = "nvim";
            x = "exit";
          };
        };

        bat = {
          enable = true;
          extraPackages = with pkgs.bat-extras; [
            batman
          ];
          syntaxes = {
            justfile = {
              src = inputs.bat-syntax-justfile;
              file = "Syntax/Just.sublime-syntax";
            };
          };
        };

        pay-respects = {
          enable = true;
          enableFishIntegration = true;
        };
      };
    };
}
