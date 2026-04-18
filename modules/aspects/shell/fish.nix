{
  flake.modules.nixos.shell =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      programs.fish = {
        enable = true;

        shellInit = /* fish */ ''
          fish_vi_key_bindings # Vim mode

          set -g fish_greeting # Disable greeting

          bind Z __onelockeds_fuzzy_zox
          bind -M insert Z __onelockeds_fuzzy_zox
        '';

        functions = {
          starship_transient_prompt_func = ''printf  " \e[1;96m  \e[0m"'';

          mcd = "mkdir -p $argv[1]; and cd $argv[1]"; # mkdir + cd

          __onelockeds_fuzzy_zox = /* fish */ ''
            set -l dir (
              zoxide query -ls 2>/dev/null \
              | awk -v home="$HOME" '{
                  score = $1
                  sub(/^[ \t]*[0-9.]+[ \t]+/, "", $0)
                  orig = $0
                  sub("^" home, "~", $0)

                  green = "\033[32m"
                  dim   = "\033[2m"
                  reset = "\033[0m"

                  printf "%s%6s %s│%s  %s\t%s\n", green, score, reset dim, reset, $0, orig
              }' \
              | fzf \
                  --ansi --no-sort --height=100% --layout=reverse --info=inline-right \
                  --scheme=path --delimiter='\t' --with-nth=1 \
                  --prompt "󰰷 Zoxide: ➜ " --pointer="▶" --separator "─" \
                  --scrollbar "│" --border="rounded" --padding="1,2" \
                  --header " Rank │  Directory" \
                  --preview '
                      printf "   Tree Structure\n";
                      printf "  \033[2m────────────────\033[0m\n";
                      eza -TL=3 --color=always --icons {2} 2>/dev/null | tail -n +2
                  ' \
                  --preview-window="right:50%:wrap:border-left" \
                  --bind "ctrl-j:down,ctrl-k:up" \
                  --bind "ctrl-d:preview-half-page-down,ctrl-u:preview-half-page-up" \
              | cut -f2 | string trim
            )

            if test -n "$dir"
                cd "$dir"
                # yazi
            end
            commandline -f repaint
          '';
        };
      };

      hj.xdg.config.files =
        let

          # Adapted from home-manager (https://github.com/nix-community/home-manager/blob/master/modules/programs/fish.nix)
          fishIndent =
            name: text:
            pkgs.runCommand name {
              nativeBuildInputs = [ pkgs.fish ];
              inherit text;
              passAsFile = [ "text" ];
            } "env HOME=$(mktemp -d) fish_indent < $textPath > $out";

          inherit (lib) optional isAttrs;
        in
        lib.mapAttrs' (name: def: {
          name = "fish/functions/${name}.fish";
          value = {
            source =
              let
                modifierStr = n: v: optional (v != null) ''--${n}="${toString v}"'';
                modifierStrs = n: v: optional (v != null) "--${n}=${toString v}";
                modifierBool = n: v: optional (v != null && v) "--${n}";

                mods =
                  with def;
                  modifierStr "description" description
                  ++ modifierStr "wraps" wraps
                  ++ lib.concatMap (modifierStr "on-event") (lib.toList onEvent)
                  ++ modifierStr "on-variable" onVariable
                  ++ modifierStr "on-job-exit" onJobExit
                  ++ modifierStr "on-process-exit" onProcessExit
                  ++ modifierStr "on-signal" onSignal
                  ++ modifierBool "no-scope-shadowing" noScopeShadowing
                  ++ modifierStr "inherit-variable" inheritVariable
                  ++ modifierStrs "argument-names" argumentNames;

                modifiers = if isAttrs def then " ${toString mods}" else "";
                body = if isAttrs def then def.body else def;
              in
              fishIndent "${name}.fish" ''
                function ${name}${modifiers}
                  ${lib.strings.removeSuffix "\n" body}
                end
              '';
          };
        }) config.programs.fish.functions;

    };

  flake.modules.nixos.default =
    { lib, ... }:
    {
      options.programs.fish = {
        functions = lib.mkOption {
          default = { };
          type = with lib.types; attrsOf (either lines functionModule);
          description = "Set custom fish functions.";
        };
      };
    };
}
