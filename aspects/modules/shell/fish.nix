{
  tack.inputs.fish-completion-sync = {
    url = "gh:iynaix/fish-completion-sync";
    type = "fetch";
  };

  exo.core =
    {
      inputs,
      config,
      ...
    }:
    {
      programs.fish = {
        enable = true;
        extraCompletionPackages = config.hj.packages;

        shellInit = /* fish */ ''
          fish_vi_key_bindings # Vim mode

          set -g fish_greeting # Disable greeting
          set -g SHELL_PROGRAM fish

          # setup fish-completion-sync
          source ${inputs.fish-completion-sync}/init.fish

          bind Z __onelockeds_fuzzy_zox
          bind -M insert Z __onelockeds_fuzzy_zox
        '';
      };
    };
}
