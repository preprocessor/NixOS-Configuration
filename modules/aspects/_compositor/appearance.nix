{
  flake.modules.homeManager.desktop =
    { osConfig, ... }:
    let
      shadow_size = 10;
      scheme = osConfig.scheme;
    in
    {
      wayland.windowManager.mango.settings = /* ini */ ''
        # Overview Setting
        hotarea_size=10
        enable_hotarea=1
        ov_tab_mode=0
        overviewgappi=5
        overviewgappo=30

        # Appearance
        gappih=20
        gappiv=20
        gappoh=25
        gappov=25
        scratchpad_width_ratio=0.8
        scratchpad_height_ratio=0.9
        borderpx=5

        # Background color of the root window
        rootcolor=0x${scheme.base01}ff
        # Inactive window border
        bordercolor=0x${scheme.base07}ff
        # Active window border
        focuscolor=0x${scheme.base0D}ff
        # Urgent window border (alerts)
        urgentcolor=0x${scheme.base08}ff

        maximizescreencolor=0x${scheme.base0A}ff
        scratchpadcolor=0x${scheme.base0C}ff
        # globalcolor=0xb153a7ff
        # overlaycolor=0x14a57cff

        cursor_theme=hand-of-evil
        cursor_size=128

        # Window effect
        blur=0
        blur_layer=0
        blur_optimized=1
        blur_params_num_passes = 2
        blur_params_radius = 5
        blur_params_noise = 0.02
        blur_params_brightness = 0.9
        blur_params_contrast = 0.9
        blur_params_saturation = 1.2

        shadows = 1
        layer_shadows = 1
        shadow_only_floating = 0
        shadows_size = ${builtins.toString shadow_size}
        shadows_blur = ${builtins.toString (shadow_size - 1)}
        shadows_position_x = -${builtins.toString shadow_size}
        shadows_position_y = -${builtins.toString shadow_size}
        shadowscolor= 0x000000dd

        border_radius=0
        no_radius_when_single=0
        no_border_when_single=0
        focused_opacity=1.0
        unfocused_opacity=1.0
      '';
    };
}
