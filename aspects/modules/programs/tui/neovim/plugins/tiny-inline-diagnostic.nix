{
  exo.mods.neovim =
    { lib, ... }:
    {
      plugins.tiny-inline-diagnostic = {
        enable = true;
        settings = {
          signs.diag = "";
          options = {
            show_source.if_many = true;
            set_arrow_to_diag_color = true;
            # use_icons_from_diagnostic = true;
            multilines = {
              enabled = true;
              always_show = true;
            };
            format = lib.nixvim.mkRaw /* lua */ ''
              function(diagnostic)
                local function prefix_diagnostic(prefix)
                  return string.format(prefix .. ' %s', diagnostic.message)
                end
                local severity = diagnostic.severity
                if severity == vim.diagnostic.severity.ERROR then
                  return prefix_diagnostic('󰅚')
                end
                if severity == vim.diagnostic.severity.WARN then
                  return prefix_diagnostic('⚠')
                end
                if severity == vim.diagnostic.severity.INFO then
                  return prefix_diagnostic('ⓘ')
                end
                if severity == vim.diagnostic.severity.HINT then
                  return prefix_diagnostic('󰌶')
                end
                return prefix_diagnostic('■')
              end
            '';

          };
        };
      };
    };
}
