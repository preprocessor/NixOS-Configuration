{ self, ... }:
{
  flake.modules.homeManager.default =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        uutils-coreutils-noprefix
        eza # better ls
      ];

      programs = {
        fish = {
          shellAliases = {

            ls = "eza --group-directories-first --icons";
            la = "eza --group-directories-first --icons -a";
            ll = "eza --group-directories-first --icons -al";

            man = "batman";
            cat = "bat --plain";

            gr = "cd (git rev-parse --show-toplevel)"; # cd to git root

            cp = "cp -r";
            mkdir = "mkdir -p";

            rm = "trash-put";
            rmdir = "trash-put";

            write-flake = "nix run ${self.const.cfgdir}/#write-flake";
            rebuild = "nh os switch --diff always";
            repl = "nix repl --file ${self.const.cfgdir}/repl.nix";

            # y = yazi
            # f = pay-respects
          };

          shellAbbrs = {
            clone = "git clone";
            cls = "clear";
            ga = "git add .";
            wf = "write-flake";
            rb = "rebuild";
            cd = "z";
            v = "nvim";
            x = "exit";
          };
        };

        bat = {
          enable = true;
          extraPackages = with pkgs.bat-extras; [
            batman
          ];
        };

        pay-respects = {
          enable = true;
          enableFishIntegration = true;
        };
      };
    };
}
