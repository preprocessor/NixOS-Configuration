{
  tack.inputs.nixtopsy = {
    url = "gh:amaanq/nixtopsy";
    group = "nix";
  };

  modules.core = { pkgs, packages', ... }: {
    hj.packages =
      with pkgs;
      [
        nix-output-monitor
        nix-inspect
        nixfmt-rs
        nurl
      ]
      ++ [ packages'.nixtopsy ];

    programs.fish.shellFunctions = {
      runpkgs.body = "nix run nixpkgs#$argv[1]";
      shpkgs.body = "nix shell nixpkgs#$argv[1]";
    };
  };
}
