{
  w.shell =
    { pkgs, config, ... }:
    let
      confirm-dialog = pkgs.yaziPlugins.mkYaziPlugin {
        pname = "confirm-dialog";
        version = "1.0";
        src = pkgs.writeTextFile {
          name = "confirm-dialog-src";
          destination = "/main.lua";
          text = /* lua */ ''
            local get_hovered = ya.sync(function()
                local h = cx.active.current.hovered
                if not h then return nil end
                return {
                    url     = tostring(h.url),
                    is_dir  = h.cha.is_dir,
                    exists  = h.cha.len ~= nil,
                }
            end)

            local function entry()
                if not os.getenv("YAZI_CHOOSER_SAVE") then
                    return ya.emit("open", { hovered = true })
                end

                local h = get_hovered()
                if not h then return end

                if h.is_dir then
                    return ya.emit("enter", {})
                end

                if h.exists then
                    local yes = ya.confirm({
                        pos = { "center", w = 62, h = 10 },
                        title = "Overwrite file?",
                        body = ui.Text(
                            h.url .. "\n\nThis file already exists and will be overwritten."
                        ):wrap(ui.Wrap.YES),
                    })
                    if not yes then return end
                end

                ya.emit("open", { hovered = true })
            end

            return { entry = entry }
          '';
        };
      };
    in
    {
      wrappers.yazi.plugins = { inherit confirm-dialog; };

      wrappers.yazi.keymap = {
        mgr.prepend_keymap = with config.utils; [
          (yaziKeymap [ "<Enter>" ] "plugin confirm-dialog" "Safe open in chooser mode")
        ];
      };
    };
}
