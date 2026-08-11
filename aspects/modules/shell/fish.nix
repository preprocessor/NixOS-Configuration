{ inputs, ... }:
{
  tack.inputs = {
    fish-completion-sync = {
      url = "gh:iynaix/fish-completion-sync";
      type = "fetch";
    };

    my-nixpkgs = {
      url = "gh:preprocessor/nixpkgs/module-test";
      type = "fetch";
    };
  };

  exo.core =
    {
      modulesPath,
      config,
      ...
    }:
    {
      disabledModules = [ (modulesPath + "/programs/fish.nix") ];
      imports = [ (inputs.my-nixpkgs + "/nixos/modules/programs/fish.nix") ];

      programs.fish = {
        enable = true;

        shellInit = /* fish */ ''
          fish_vi_key_bindings # Vim mode

          set -g fish_greeting # Disable greeting

          set -g SHELL_PROGRAM fish

          # setup fish-completion-sync
          source ${inputs.fish-completion-sync}/init.fish

          bind Z __onelockeds_fuzzy_zox
          bind -M insert Z __onelockeds_fuzzy_zox
        '';

        extraCompletionPackages = config.hj.packages;
      };
    };
}
