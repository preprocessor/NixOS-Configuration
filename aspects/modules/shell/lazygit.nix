{
  w.default =
    {
      pkgs,
      config,
      lib,
      birdee,
      ...
    }:
    let
      cfg = config.my.lazygit;
      yaml = pkgs.formats.yaml { };
    in
    {
      config = lib.mkMerge [
        {
          my.lazygit = {
            enable = true;
            settings = {
              git = {
                autoFetch = false;
                overrideGpg = true;
                paging.colorArg = "always";
                pagers =
                  let
                    delta = config.my.delta;
                  in
                  [
                    {
                      pager = "${lib.getExe delta.package}";
                    }
                    {
                      pager = "${lib.getExe delta.package} --side-by-side";
                    }
                  ];
                update = {
                  days = 365;
                  method = "never";
                };
              };

              color = {
                ui = true;

                diff-highlight = {
                  oldNormal = "red bold";
                  oldHighlight = "red bold 52";
                  newNormal = "green bold";
                  newHighlight = "green bold 22";

                };

                diff = {
                  meta = "11";
                  frag = "magenta bold";
                  func = "146 bold";
                  commit = "yellow bold";
                  old = "red bold";
                  new = "green bold";
                  whitespace = "red reverse";
                };
              };

              gui = {
                expandFocusedSidePanel = true;
                expandedSidePanelWeight = 2;
                filterMode = "fuzzy";
                showNumstatInFilesView = true;
                showPanelJumps = false;
                showRandomTip = false;
                sidePanelWidth = 0.25;
                border = "single";
              };

              keybinding = {
                universal = {
                  jumpToBlock = [
                    "0"
                    "1"
                    "2"
                    "3"
                    "4"
                  ];
                };
              };

              os = {
                editInTerminal = true;
                edit = ''if [ -n "$NVIM" ]; then nvim --server $NVIM --remote-send '<C-\><C-n><cmd>close<cr>' && nvim --server $NVIM --remote {{filename}}; else nvim {{filename}}; fi'';
                editAtLine = ''if [ -n "$NVIM" ]; then nvim --server $NVIM --remote-send '<C-\><C-n><cmd>close<cr>' && nvim --server $NVIM --remote +{{line}} {{filename}}; else nvim +{{line}} {{filename}}; fi'';
              };
            };
          };
        }
        (lib.mkIf cfg.enable {
          hj.packages = [ cfg.package ];

          programs.fish.functions.lg = /* fish */ ''
            set -x LAZYGIT_NEW_DIR_FILE ${config.hj.xdg.config.directory}/lazygit/newdir
            command lazygit $argv
            if test -f $LAZYGIT_NEW_DIR_FILE
              cd (cat $LAZYGIT_NEW_DIR_FILE)
                rm -f $LAZYGIT_NEW_DIR_FILE
                end
          '';
        })
      ];

      options.my.lazygit =
        let
          yaml = pkgs.formats.yaml { };
        in
        {
          enable = lib.mkEnableOption { };

          settings = lib.mkOption {
            inherit (yaml) type;
            default = { };
            description = "Options to go into lazygit's yaml config";
          };

          moreCfg = lib.mkOption {
            type = with lib.types; nullOr (either path lines);
            default = "";
            description = "Additional config lines.";
          };

          package = lib.mkOption {
            default = birdee.lib.wrapPackage {
              inherit pkgs;
              package = pkgs.lazygit;
              env.LG_CONFIG_FILE = yaml.generate "config.yml" cfg.settings;
            };
          };
        };

      _file = ./lazygit.nix;
    };
}
