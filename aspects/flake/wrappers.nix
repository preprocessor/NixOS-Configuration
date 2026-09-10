{ lib, ... }:
let
  # This module defines the options and the use of those options to make a wrapped package
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

        linkedPackages = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [ ];
          description = ''
            Additional packages to include in the derivation.

            This differs from extraPkgs, which links packages for use at runtime

            Note: As of writing, packages in extraPackages do not inherit environment
                  variables passed to the wrapper.
          '';
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
          description = "Arguments to pass to the binary";
        };

        runCommand = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "Run commands before the executable";
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
          description = "Environment variables to pass to the binary";
        };

        extraPkgs = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [ ];
          description = "Packages to link at runtime";
        };

        files = lib.mkOption {
          type = lib.types.attrsOf (
            lib.types.submodule {
              options = {
                relPath = lib.mkOption {
                  type = lib.types.str;
                  description = "Path of the file relative to $out. ";
                };

                file = lib.mkOption {
                  type = with lib.types; either str pathInStore;
                  description = ''
                    Either a string to be passed into `pkgs.writeText` or a path to a file in the nix store.
                  '';
                };
              };
            }
          );
          default = { };
          description = "Files generated relative to the root of the derivation.";
        };

        aliases = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "Aliases to the main binary.";
        };

        wrapper = lib.mkOption {
          type = lib.types.package;
          readOnly = true;
          description = "The built, wrapped derivation.";
        };

        processedFiles = lib.mkOption {
          type = with lib.types; attrsOf anything;
          readOnly = true;
        };
      };

      config = {
        processedFiles =
          config.files |> lib.mapAttrs (_: { relPath, ... }: "${placeholder "out"}/${relPath}");

        wrapper =
          let
            inherit (config)
              package
              binName
              args
              env
              extraPkgs
              linkedPackages
              files
              aliases
              runCommand
              ;

            userFiles =
              files
              |> lib.mapAttrsToList (
                filename:
                { relPath, file }:
                # Linkfarm expects { name = ..., path = ... }
                {
                  name = relPath;
                  path =
                    # If the value IS a string and IS NOT a nix store path
                    if (lib.isString file) && !(lib.hasPrefix builtins.storeDir file) then
                      # Write a text file of the content and return its store path
                      file |> pkgs.writeText "${lib.baseNameOf filename}-text"
                    else
                      file;
                }
              );
          in
          pkgs.symlinkJoin {
            name = "${package.name}-wrapper";
            paths = linkedPackages ++ [ package ] ++ [ (pkgs.linkFarm "${package.name}-files" userFiles) ];
            nativeBuildInputs = [ pkgs.makeWrapper ];
            postBuild =
              let
                args' = args |> map (v: "--add-flags ${lib.escapeShellArg v}") |> lib.join " \\\n  ";

                env' =
                  env
                  |> lib.mapAttrsToList (n: v: " --set ${lib.escapeShellArg n} ${lib.escapeShellArg (toString v)}")
                  |> lib.join " \\\n ";

                extraPkgs' = lib.optionalString (extraPkgs != [ ]) " --prefix PATH : ${lib.makeBinPath extraPkgs}";

                aliases' =
                  aliases
                  |> map (alias: "ln -sf $out/bin/${binName} $out/bin/${lib.escapeShellArg alias}")
                  |> lib.concatLines;

                runCommand' = runCommand |> map (v: " --run ${lib.escapeShellArg v}") |> lib.join " \\\n ";

                # Each of the prime (') variables above are the correctly processed values for use with makeWrapper

                wrapperArgs = "${args'}${env'}${extraPkgs'}${runCommand'}";
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

            meta = removeAttrs (package.meta or { }) [ "outputsToInstall" ] // {
              mainProgram = binName;
            };
          };
      };
    };

  wlib = (
    { config, pkgs, ... }:
    {
      _module.args = {
        files = config.processedFiles;

        wlib = rec {
          out = placeholder "out";

          generate = fmt: (fmt { }).generate;

          json = generate pkgs.formats.json;
          toml = generate pkgs.formats.toml;
          yaml = generate pkgs.formats.yaml;
          ini = generate pkgs.formats.ini;

          buildAndAppend =
            {
              formatter,
              buildFrom,
              appendString ? "",
            }:
            fileName:
            pkgs.runCommand "generate-${fileName}" { } ''
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
        };
      };
    }
  );

  wrap =
    pkgs: spec:
    let
      evaluation = lib.evalModules {
        modules = [
          wrapperModule
          wlib
          spec
        ];
        specialArgs = { inherit pkgs; };
      };
    in
    evaluation.config.wrapper;
in
{
  exo.core =
    { pkgs, ... }:
    {
      _module.args.wrapPackage = wrap pkgs;
    };

  perSystem =
    { pkgs, ... }:
    {
      _module.args.wrapPackage = wrap pkgs;
    };

  _file = "wrappers.nix";
}
