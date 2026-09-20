{
  exo.mods.neovim =
    { lib, ... }:
    let
      inherit (lib.nixvim) mkRaw;
    in
    {
      plugins.snacks.settings.picker = {
        actions.trouble_open = mkRaw /* lua */ ''
          function(...)
            return require('trouble.sources.snacks').actions.trouble_open.action(...)
          end
        '';

        sources =
          let
            excluded = [
              "node_modules/"
              "dist/"
              ".next/"
              ".vite/"
              ".git/"
              ".gitlab/"
              "build/"
              "target/"
              "result/"
              "package-lock.json"
              "pnpm-lock.yaml"
              "yarn.lock"
              "flake.lock"
            ];
          in
          {
            explorer.exclude = excluded;
            grep.exclude = excluded;
            files.exclude = excluded;
          };
      };
    };
}
