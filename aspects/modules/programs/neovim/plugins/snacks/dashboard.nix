{
  exo.mods.neovim =
    { lib, ... }:
    let
      inherit (lib.nixvim) mkRaw;
    in
    {
      plugins.snacks.settings.dashboard =
        let
          width = 83;
          header_hl = "ModeMsg";
          border_hl = "StatusLine";
          footer_hl = "StatusLine";
          plain_text_hl = "Constant";

          filler = {
            text = {
              __unkeyed-1 = "│${lib.strings.replicate (width - 2) " "}│";
              hl = border_hl;
            };
          };

          header = ''
            ┌─────────────────────────────────────────────────────────────────────────────────┐
            │                                      ▄▀                                         │
            │                          ░   ░ ░░  ▄▓█▌ ░░ ░   ░                                │
            │ ▄▄    ▀▀▓▓█▄▄▄   ▄▄███▄          ▄▓████▄                   ▄▄   🬋▀▀▓▓▄▄▄        │
            │  ▀▓▓▓▄▄  ▀▓███▓▓▄ ▀██▓▓█▄▄▄    ▄▓▓▓▓█████▄▄     ▄🬋█▓▄▄      ▀▓▓▓▄▄   ▀███▓▓▄    │
            │   ▐▓████▓▄  ▀███▓▓▄ ██▓▌  ▀▓██▄ ▀▀▀████▓▀▀███▄▄▄   ▀████▄▄   ▐▓████▓▓▄ ▀███▓▓▄  │
            │    ████▓▓▌   ▐███▓▓▌ ▀▀▀🬋  ▐█████▓▄ ▀ ▄▄▄████▓▀ ▄▀   █▓███▓▄  ████▓▓▌   ▐███▓▓▌ │
            │    ▐████▓   ▄████▓▀ ▄▓▓▄    ███▓█▌ ▄██████▓▀▀ ▄▓▌    ▐▓████▓▓▄ ▀███▓   ▄████▓▀  │
            │     ████▓ ▀▀▀▀▀▀ ▄▄███▀██▄▄ ▐█▓▓▓ ████▓▀▀  ▄██▓▓▌     █▀▓▀██▓▓▌ ███▓🬋▀██▀▀▀     │
            │     ███▓▓▌🬋▀▓██▄▄ ▀██▄▓▄██▀▀🬋██▓▌  ▀██▄█▓▄▄ ▀▀█▓▓     ▐█▄███▓▓▌ ██▓▓  ▐███▄▄    │
            │    ▐██▓▓▓▓  ▐███▓▓▄ ▀███▀    ██▓▓    ▀█████▓▓▄▄▄      ▐█████▓▓ ▐█▓▓▓   ▓███▓▓▄  │
            │   ▄█████▓▓▓▄ ████▓▓▌ ██▓▌   ▐███▓▓     ▀██████▓▓▓▓▀  ▄█████▓▀ ▄████▓▌  ▐████▓▓▌ │
            │ 🬋▀▀▀   ▀▀▓▀ ▐█████▓▓ ▐▓▓▓▓▄▄▓████▓▓      ▀███▓▓▀  🬋▄▓██▓▓▀▀ 🬭█▀   ▀▀▀  ▀▀▀███▓▓ │
            │           ▄▓▓▓███▓▓▓▌ ▀▓▓▀▀     ▀█▓▓       ▓▓▀      ▀▀▀   ▗▖🬂               ▀▀▓ │
            │                 ▀▀▀▓▓▄            ▀▓▓▄      ▀▄           ▄  R A Z O R           │
            │                      ▀▓             ▀▓▌        ▀ ■ ▄ ■ ▀     1 9 1 1            │
            │                       ▀▄             ▐▌                                         │'';
          footer = ''
            │                                                                                 │
            └──────── ───── ── ── ─ ── ──    ─             ─     ─ ─ ── ─── ──── ─── ─────────┘
             ▀████████████████████████████████████████████████▄███████████████████▄██████████▀
              ▐▀██▀     ▀▀■▄ ▀▀▀▀▀▀▀▄▀▀▀▀▀▀▀▀■▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▄▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀████
               ▐█▀▄        ▀▄                                                ▄▀▀▀▀▄▄    ████▌
               █   ▀▀▄▄▄■   ▀■▄▄  •-----•  ─  𝐍  Σ  Ø  𝐕  i m   ─  •-----• ■▀       ▀▄▄████▀
              ▀                                                                         ▀▄'';
        in
        {
          inherit width;
          sections = [
            {
              text = {
                __unkeyed-1 = header;
                hl = header_hl;
              };
            }
            { section = "keys"; }
            {
              text = {
                __unkeyed-1 = footer;
                hl = footer_hl;
              };
            }
          ];

          preset.keys = [
            {
              icon = " ";
              key = "f";
              desc = "Find File";
              action = ":lua Snacks.dashboard.pick('files')";
            }
            filler
            {
              icon = " ";
              key = "n";
              desc = "New File";
              action = ":ene | startinsert";
            }
            filler
            {
              icon = " ";
              key = "g";
              desc = "Find Text";
              action = ":lua Snacks.dashboard.pick('live_grep')";
            }
            filler
            {
              icon = " ";
              key = "r";
              desc = "Recent Files";
              action = ":lua Snacks.dashboard.pick('oldfiles')";
            }
            filler
            {
              icon = " ";
              key = "p";
              desc = "Projects";
              action = ":lua Snacks.picker.projects()";
            }
            filler
            {
              icon = " ";
              key = "c";
              desc = "Config";
              action = ":lua Snacks.dashboard.pick('files'; {cwd ='~/Configuration/Neovim/'})";
            }
            filler
            {
              icon = " ";
              key = "s";
              desc = "Restore Session";
              action = ":lua require('persistence').load({ last = true; })";
            }
            filler
            {
              icon = " ";
              key = "q";
              desc = "Quit";
              action = ":qa";
            }
          ];

          formats = {
            key = mkRaw /* lua */ ''
              function(item)
                return {
                  { '[', hl = ${plain_text_hl} },
                  { item.key, hl = '@string.special.url' },
                  { ']', hl = ${plain_text_hl} },
                  { '  │', hl = ${border_hl} },
                }
              end
            '';
            icon = mkRaw /* lua */ ''
              function(item)
                return { { '│   ', hl = ${border_hl} }, { item.icon, width = 2, hl = ${plain_text_hl} } }
              end
            '';
            desc = mkRaw /* lua */ ''
              function(item)
                -- return { { item.desc, hl = "@constant.builtin" } }
                return { { item.desc, hl = 'Conceal' } }
              end
            '';
          };

        };
    };
}
