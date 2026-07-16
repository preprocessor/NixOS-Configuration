{ lib, ... }:
let
  wrapperModule =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      options = {
        package = lib.mkOption {
          type = lib.types.package;
          description = "The package to wrap.";
        };

        binName = lib.mkOption {
          type = lib.types.str;
          default = config.package.meta.mainProgram or (lib.getName config.package);
          description = "Name of the wrapped binary at $out/bin/<binName>.";
          apply = lib.escapeShellArg;
        };

        args = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
        };

        env = lib.mkOption {
          type =
            with lib.types;
            attrsOf (oneOf [
              str
              number
              bool
              path
            ]);
          default = { };
        };

        extraPkgs = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [ ];
        };

        files = lib.mkOption {
          type = with lib.types; attrsOf (either str path);
          default = { };
          apply = lib.mapAttrs (
            name: path:
            if (path |> lib.isString) && !(lib.hasPrefix builtins.storeDir path) then
              (path |> pkgs.writeText "${lib.baseNameOf name}-text")
            else
              path
          );

        };

        aliases = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
        };

        wrapper = lib.mkOption {
          type = lib.types.functionTo lib.types.package;
          readOnly = true;
          description = "The built, wrapped derivation.";
        };
      };

      config = {
        wrapper =
          let
            inherit (config)
              package
              binName
              args
              env
              extraPkgs
              files
              aliases
              ;
          in
          pkgs:
          pkgs.symlinkJoin {
            name = "${package.name}-wrapped";
            paths = [
              (
                files |> lib.mapAttrsToList (name: path: { inherit name path; }) |> pkgs.linkFarm "${package.name}"
              )
              package
            ];
            nativeBuildInputs = [ pkgs.makeWrapper ];
            meta = removeAttrs (package.meta or { }) [ "outputsToInstall" ] // {
              mainProgram = binName;
            };
            postBuild =
              let
                args' = args |> map (v: "--add-flags ${lib.escapeShellArg v}") |> lib.concatStringsSep " \\\n  ";

                env' =
                  env
                  |> lib.mapAttrsToList (n: v: "--set ${lib.escapeShellArg n} ${lib.escapeShellArg (toString v)}")
                  |> lib.concatStringsSep " \\\n  ";

                extraPkgs' = lib.optionalString (extraPkgs != [ ]) " --prefix PATH : ${lib.makeBinPath extraPkgs}";

                aliases' =
                  aliases
                  |> map (alias: "ln -sf $out/bin/${binName} $out/bin/${lib.escapeShellArg alias}")
                  |> lib.concatStringsSep "\n";

                wrapperArgs = "${args'} ${env'}${extraPkgs'}";
              in
              /* bash */ ''
                if [ ! -e $out/bin/${binName} ]; then
                  makeWrapper ${
                    lib.getExe' package (package.meta.mainProgram or (lib.getName package))
                  } $out/bin/${binName} ${wrapperArgs}
                else
                  wrapProgram $out/bin/${binName} ${wrapperArgs}
                fi

                ${lib.optionalString (aliases != [ ]) aliases'}
              '';
          };
      };
    };

  wlib = pkgs: rec {
    inherit pkgs;

    files = placeholder "out";

    buildAndAppend =
      {
        formatter,
        buildFrom,
        appendString ? "",
      }:
      fileName:
      pkgs.runCommand "${fileName}" { } ''
        install -m644 -DT "${formatter.generate "${fileName}" buildFrom}" "$out"
        echo -e "\n${appendString}" >> "$out"
      '';

    buildAndAppend' =
      {
        formatter,
        buildFrom,
        appendString ? "",
      }:
      fileName: {
        "${fileName}" = fileName |> buildAndAppend { inherit formatter buildFrom appendString; };
      };

    buildAndAppendYaml =
      {
        buildFrom,
        appendString ? "",
      }:
      fileName:
      fileName
      |> buildAndAppend {
        inherit buildFrom appendString;
        formatter = pkgs.formats.yaml { };
      };

    buildAndAppendYaml' =
      {
        buildFrom,
        appendString ? "",
      }:
      fileName: {
        "${fileName}" = fileName |> buildAndAppendYaml { inherit buildFrom appendString; };
      };

    buildAndAppendToml =
      {
        buildFrom,
        appendString ? "",
      }:
      fileName:
      fileName
      |> buildAndAppend {
        inherit buildFrom appendString;
        formatter = pkgs.formats.toml { };
      };

    buildAndAppendToml' =
      {
        buildFrom,
        appendString ? "",
      }:
      fileName: {
        "${fileName}" = fileName |> buildAndAppendToml { inherit buildFrom appendString; };
      };
  };

  wrap =
    pkgs: spec:
    let
      evaluation = lib.evalModules {
        modules = [
          wrapperModule
          spec
        ];
        specialArgs = {
          inherit pkgs;
          wlib = wlib pkgs;
        };
      };
    in
    evaluation.config.wrapper pkgs;
in
{
  exo.core =
    { pkgs, ... }:
    {
      _module.args.wrapPackage = wrap pkgs;
      _module.args.wrapPackage' = wrap;
    };
  perSystem =
    { pkgs, ... }:
    {
      _module.args.wrapPackage = wrap pkgs;
      _module.args.wrapPackage' = wrap;
    };

  _file = "wrappers.nix";
}
