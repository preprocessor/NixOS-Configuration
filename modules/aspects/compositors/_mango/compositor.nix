{ inputs, ... }:
{
  flake-file.inputs.mango.url = "github:mangowm/mango";

  flake.modules.nixos.desktop = {
    imports = [ inputs.mango.nixosModules.mango ];
    programs.mango.enable = true;
  };

  flake.modules.homeManager.desktop = {
    imports = [ inputs.mango.hmModules.mango ];

    wayland.windowManager.mango = {
      enable = true;
      systemd = {
        enable = true;
        xdgAutostart = true;
      };

      settings = /* ini */ ''
        # More option see https://github.com/DreamMaoMao/mango/wiki/

        # Misc
        axis_bind_apply_timeout=100
        focus_on_activate=1
        idleinhibit_ignore_visible=0
        sloppyfocus=1
        warpcursor=1
        focus_cross_monitor=0
        focus_cross_tag=0
        enable_floating_snap=0
        snap_distance=30
        drag_tile_to_tile=1

        # keyboard
        repeat_rate=25
        repeat_delay=200
        numlockon=1
        xkb_rules_layout=us

        # Trackpad
        # need relogin to make it apply
        disable_trackpad=1
        tap_to_click=1
        tap_and_drag=1
        drag_lock=1
        trackpad_natural_scrolling=0
        disable_while_typing=1
        left_handed=0
        middle_button_emulation=0
        swipe_min_threshold=1

        # mouse
        # need relogin to make it apply
        mouse_natural_scrolling=0

        # layout support:
        # tile,scroller,grid,deck,monocle,center_tile,vertical_tile,vertical_scroller
        tagrule=id:1,layout_name:tile
        tagrule=id:2,layout_name:tile
        tagrule=id:3,layout_name:tile
        tagrule=id:4,layout_name:tile
        tagrule=id:5,layout_name:tile
        tagrule=id:6,layout_name:tile
        tagrule=id:7,layout_name:tile
        tagrule=id:8,layout_name:tile
        tagrule=id:9,layout_name:tile

        # layer rule
        ; layerrule=noshadow:1,layer_name:anyrun

        source=~/.config/mango/dyn.conf
      '';
    };
  };

  flake.modules.nixos.default =
    { lib, pkgs, ... }:
    {
      options.custom.programs.mango.settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType = (pkgs.formats.json { }).type;
          # strings don't merge by default
          options.extraConfig = lib.mkOption {
            type = lib.types.lines;
            default = "";
            description = "Additional configuration lines.";
          };
        };
        description = "Mango settings, see https://github.com/Lassulus/wrappers/blob/main/modules/niri/module.nix for available options";
      };
    };
}
