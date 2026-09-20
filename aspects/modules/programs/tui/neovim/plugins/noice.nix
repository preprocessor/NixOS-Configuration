{
  exo.mods.neovim =
    { lib, ... }:
    let
      inherit (lib.nixvim) listToUnkeyedAttrs;
    in
    {
      plugins.noice = {
        enable = true;
        settings = {
          presets = {
            bottom_search = true;
            long_message_to_split = true;
            command_palette = true;
            lsp_doc_border = true;
          };
          lsp = {
            override = {
              "vim.lsp.util.convert_input_to_markdown_lines" = true;
              "vim.lsp.util.stylize_markdown" = true;
              "cmp.entry.get_documentation" = true;
            };
            hover.enabled = false;
            message.enabled = false;
            signature.enabled = false;
            progress.enabled = false;
          };
          routes = [
            {
              view = "mini";
              filter = {
                event = "msg_show";
                any = listToUnkeyedAttrs [
                  { find = "%d+L, %d+B"; }
                  { find = "; after #%d+"; }
                  { find = "; before #%d+"; }
                ];
              };
            }
          ];
        };
      };
    };
}
