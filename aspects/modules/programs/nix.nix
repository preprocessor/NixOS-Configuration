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
      nrun.body = /* fish */ ''
        set -l package $argv[1]
        nix run "nixpkgs#$package" -- $argv[2..-1]
      '';
      nshell.body = /* fish */ ''
        set -l package $argv[1]
        nix shell "nixpkgs#$package" -- $argv[2..-1]
      '';
    };
  };
}
