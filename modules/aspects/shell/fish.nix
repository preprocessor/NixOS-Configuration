{
  envoy.fish-completion-sync.github = "iynaix/fish-completion-sync";
  w.shell =
    {
      pkgs,
      lib,
      config,
      envoy,
      ...
    }:
    {
      programs.fish = {
        enable = true;

        shellInit = /* fish */ ''
          fish_vi_key_bindings # Vim mode

          set -g fish_greeting # Disable greeting

          # setup fish-completion-sync
          source ${envoy.fish-completion-sync.src}/init.fish

          bind Z __onelockeds_fuzzy_zox
          bind -M insert Z __onelockeds_fuzzy_zox
        '';
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
        lib.mkIf (config.programs.fish.functions != { }) (
          config.programs.fish.functions
          |> lib.mapAttrs' (
            name: def: {
              name = "fish/functions/${name}.fish";
              value.source =
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
            }
          )
        );

    };

  w.default =
    {
      lib,
      pkgs,
      config,
      ...
    }:
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
