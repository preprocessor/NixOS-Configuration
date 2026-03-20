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

              cp = "cp -r";
              mkdir = "mkdir -p";

              rm = "trash-put";
              rmdir = "trash-put";
            };

          shellAbbrs = {
            clone = "git clone";
            cls = "clear";

            # y = yazi
            # f = pay-respects
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
