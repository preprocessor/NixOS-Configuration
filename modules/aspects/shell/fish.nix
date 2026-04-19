{
  w.shell =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      fish-completion-sync = pkgs.fetchFromGitHub {
        owner = "iynaix";
        repo = "fish-completion-sync";
        rev = "4f058ad2986727a5f510e757bc82cbbfca4596f0";
        hash = "sha256-kHpdCQdYcpvi9EFM/uZXv93mZqlk1zCi2DRhWaDyK5g=";
      };
    in
    {
      programs.fish = {
        enable = true;

        shellInit = /* fish */ ''
          fish_vi_key_bindings # Vim mode

          set -g fish_greeting # Disable greeting

          # setup fish-completion-sync
          source ${fish-completion-sync}/init.fish

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
