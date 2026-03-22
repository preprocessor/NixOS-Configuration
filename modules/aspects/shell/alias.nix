{
  flake.modules.homeManager.default =
    { pkgs, lib, ... }:
    {
      home.packages = with pkgs; [
        uutils-coreutils-noprefix
      ];

      programs = {
        fish = {
          shellAliases =
            let
              _ = lib.getExe;
            in
            with pkgs;
            {
              rebuild = "nh os switch --diff always";
              repl = "nix repl --file ~/Configuration/NixOS/repl.nix";

              ls = "${_ eza} --group-directories-first --icons";
              la = "${_ eza} --group-directories-first --icons -a";
              ll = "${_ eza} --group-directories-first --icons -al";

              man = "batman";
              cat = "bat --plain";

              gr = "cd (git rev-parse --show-toplevel)"; # cd to git root

              cp = "cp -r";
              mkdir = "mkdir -p";

              rm = "trash-put";
              rmdir = "trash-put";

              # y = yazi
              # f = pay-respects
            };

          shellAbbrs = {
            clone = "git clone";
            cls = "clear";

            wf = "nix run .#write-flake";
            ga = "git add .";

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
