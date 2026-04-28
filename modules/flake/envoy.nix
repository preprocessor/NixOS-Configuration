topLevel@{ lib, self, ... }:
let
  generated = import (self + /envoy/generated.nix);
  injectArg =
    { pkgs, ... }:
    {
      _module.args.envoy = pkgs.callPackage generated { };
    };

  # See: https://github.com/berberman/nvfetcher for the full list of source
  # and fetcher tags, plus modifier keys (branch, regex, prerelease, etc.).
  srcTagKeys = [
    "github"
    "github_tag"
    "git"
    "gitlab"
    "pypi"
    "archpkg"
    "aur"
    "manual"
    "repology"
    "webpage"
    "httpheader"
    "openvsx"
    "vsmarketplace"
    "cmd"
    "container"
  ];
  fetchTagKeys = [
    "github"
    "pypi"
    "git"
    "url"
    "tarball"
    "gitlab"
    "docker"
  ];

  hasExactlyOneTag =
    tagKeys: attrs: lib.length (lib.intersectLists tagKeys (lib.attrNames attrs)) == 1;

  taggedAttrs =
    tagKeys:
    (lib.types.addCheck (lib.types.attrsOf lib.types.anything) (hasExactlyOneTag tagKeys))
    // {
      description = "attrs containing exactly one of: ${lib.concatStringsSep ", " tagKeys}";
    };

  # Map from src tag -> function building the inferred fetch entry.
  # Add new entries here when nvfetcher gains directly-fetchable source types.
  fetchInferenceMap = {
    github = src: { github = src.github; };
    github_tag = src: { github = src.github_tag; };
    pypi = src: { pypi = src.pypi; };
    git = src: { git = src.git; };
    gitlab = src: { gitlab = src.gitlab; };
  };

  inferFetch =
    src:
    let
      key = lib.findFirst (k: src ? ${k}) null (lib.attrNames fetchInferenceMap);
    in
    if key == null then null else fetchInferenceMap.${key} src;

  # Shorthand keys that must be stripped before serializing to TOML —
  # nvfetcher itself doesn't understand them.
  shorthandKeys = [
    "github"
    "gitlab"
    "codeberg"
    "srchut"
    "tarball"
    "url"
  ];
  # Keys consumed by this module, never passed to nvfetcher.
  internalKeys = shorthandKeys ++ [ "locked" ];
  stripInternal = source: lib.filterAttrs (n: _: !lib.elem n internalKeys) source;

  sourceType = lib.types.submodule (
    { name, config, ... }:
    {
      freeformType = lib.types.attrsOf lib.types.anything;
      options = {
        locked = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            If true, nvfetcher will not update this source. The cached entry
            in `generated.nix` is preserved as-is.
          '';
        };
        github = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Shorthand for GitHub sources. Sets src.git and fetch.github.";
        };
        gitlab = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Shorthand for GitLab sources. Sets src.git and fetch.gitlab.";
        };
        codeberg = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Shorthand for Codeberg sources. Sets src.git and fetch.git.";
        };
        srchut = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = ''
            Shorthand for SourceHut sources, given as `owner/repo` (no `~`).
            Sets src.git and fetch.git to `https://git.sr.ht/~owner/repo`.
          '';
        };
        tarball = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = ''
            Shorthand for fixed-URL tarballs. Sets fetch.tarball and pins
            src.manual to the URL so the hash is recomputed only when the
            URL itself changes.
          '';
        };
        url = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = ''
            Shorthand for fixed-URL fetches. Sets fetch.url and pins
            src.manual to the URL so the hash is recomputed only when the
            URL itself changes.
          '';
        };
        src = lib.mkOption {
          type = taggedAttrs srcTagKeys;
          description = ''
            Version source for `${name}`. Must contain exactly one of:
            ${lib.concatStringsSep ", " srcTagKeys}.
            Modifier keys like `branch`, `regex`, `prerelease`, `include_regex`
            may be set alongside.
          '';
        };
        fetch = lib.mkOption {
          type = taggedAttrs fetchTagKeys;
          # Default to {} so the inference branch below can override via mkDefault.
          # If neither inference nor user input populates this, the type check
          # will fire with a clear "exactly one of" message.
          default = { };
          description = ''
            Fetcher for `${name}`. Must contain exactly one of:
            ${lib.concatStringsSep ", " fetchTagKeys}.
            If omitted, it will be inferred from `src` if possible.
          '';
        };
      };
      config =
        let
          setShorthands = lib.filter (k: config.${k} != null) shorthandKeys;
        in
        lib.mkMerge [
          (lib.mkIf (config.github != null) {
            src.git = lib.mkDefault "https://github.com/${config.github}";
            fetch.github = lib.mkDefault config.github;
          })
          (lib.mkIf (config.gitlab != null) {
            src.git = lib.mkDefault "https://gitlab.com/${config.gitlab}";
            fetch.gitlab = lib.mkDefault config.gitlab;
          })
          (lib.mkIf (config.codeberg != null) {
            src.git = lib.mkDefault "https://codeberg.org/${config.codeberg}";
            fetch.git = lib.mkDefault "https://codeberg.org/${config.codeberg}";
          })
          (lib.mkIf (config.srchut != null) {
            src.git = lib.mkDefault "https://git.sr.ht/~${config.srchut}";
            fetch.git = lib.mkDefault "https://git.sr.ht/~${config.srchut}";
          })
          (lib.mkIf (config.tarball != null) {
            src.manual = lib.mkDefault config.tarball;
            fetch.tarball = lib.mkDefault config.tarball;
          })
          (lib.mkIf (config.url != null) {
            src.manual = lib.mkDefault config.url;
            fetch.url = lib.mkDefault config.url;
          })
          (lib.mkIf (setShorthands == [ ]) (
            let
              inferred = inferFetch config.src;
            in
            lib.mkIf (inferred != null) { fetch = lib.mkDefault inferred; }
          ))
        ];
    }
  );
in
{
  options.envoy = lib.mkOption {
    type = lib.types.attrsOf sourceType;
    default = { };
    description = "nvfetcher source definitions, written to nvfetcher.toml.";
    example = lib.literalExpression ''
      {
        helix = {
          src.github = "helix-editor/helix";
        };
        nvfetcher-git = {
          src.git = "https://github.com/berberman/nvfetcher";
          fetch.github = "berberman/nvfetcher";
        };
        fuzzy-search = {
          github = "onelocked/fuzzy-search.yazi";
        };
      }
    '';
  };

  config = {
    m.default = injectArg;

    perSystem =
      { pkgs, ... }:
      let
        # `topLevel.config.…` (not perSystem `config`) because sources are
        # defined at the top level, not per-system.
        sources = topLevel.config.envoy;
        processedSources = lib.mapAttrs (_: stripInternal) sources;
        tomlFile = (pkgs.formats.toml { }).generate "nvfetcher.toml" processedSources;
        unlockedNames = lib.attrNames (lib.filterAttrs (_: s: !s.locked) sources);
        unlockedNamesStr = lib.concatStringsSep "\n" unlockedNames;
        allNamesStr = lib.concatStringsSep "\n" (lib.attrNames sources);
      in
      {
        imports = [ injectArg ];
        apps.write-sources = {
          meta.description = "Update sources. Usage: write-sources [name-regex]. Without a filter, locked sources are skipped; with an explicit filter, locked sources matching the filter are updated too.";
          program = pkgs.writeShellApplication {
            name = "write-sources";
            runtimeInputs = [
              pkgs.nvfetcher
              pkgs.ripgrep
            ];
            text = ''
              # Without a filter: update unlocked only (safe default).
              # With an explicit filter: match against all sources, so users
              # can force-update a locked entry by naming it.
              if [ $# -eq 0 ]; then
                user_filter="."
                candidates=${lib.escapeShellArg unlockedNamesStr}
              else
                user_filter="$1"
                candidates=${lib.escapeShellArg allNamesStr}
              fi
              # nvfetcher's -f matches by full source name, so we build an
              # alternation of just the names we want to update.
              matched=$(printf '%s\n' "$candidates" \
                | rg -e "$user_filter" || true)
              if [ -z "$matched" ]; then
                echo "No sources match '$user_filter'; nothing to update." >&2
                exit 0
              fi
              regex="^($(echo "$matched" | paste -sd'|' -))$"
              nvfetcher -c ${tomlFile} -o envoy -f "$regex"
            '';
          };
        };
      };
  };
}
