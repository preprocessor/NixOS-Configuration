{ inputs, ... }:
{
  flake.modules.nixos.wayland =
    { pkgs, ... }:
    {
      imports = [ inputs.mango.nixosModules.mango ];
      programs.mango.enable = true;
    };

  flake.modules.homeManager.wayland =
    { pkgs, osConfig, ... }:
    let
      scheme = osConfig.scheme;
      shadow_size = 10;
    in
    {
      imports = [ inputs.mango.hmModules.mango ];

      wayland.windowManager.mango = {
        enable = true;
        systemd = {
          enable = true;
          xdgAutostart = true;
        };

        settings = /* ini */ ''
          # More option see https://github.com/DreamMaoMao/mango/wiki/

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
          focused_opacity=1.0
          unfocused_opacity=1.0

          # Animation Configuration(support type:zoom,slide)
          # tag_animation_direction: 1-horizontal,0-vertical
          animations=1
          layer_animations=1
          animation_type_open=slide
          animation_type_close=slide
          animation_fade_in=1
          animation_fade_out=1
          tag_animation_direction=0
          zoom_initial_ratio=0.3
          zoom_end_ratio=0.8
          fadein_begin_opacity=0.5
          fadeout_begin_opacity=0.8
          animation_duration_move=500
          animation_duration_open=400
          animation_duration_tag=350
          animation_duration_close=800
          animation_duration_focus=0
          animation_curve_open=0.46,1.0,0.29,1
          animation_curve_move=0.46,1.0,0.29,1
          animation_curve_tag=0.46,1.0,0.29,1
          animation_curve_close=0.08,0.92,0,1
          animation_curve_focus=0.46,1.0,0.29,1
          animation_curve_opafadeout=0.5,0.5,0.5,0.5
          animation_curve_opafadein=0.46,1.0,0.29,1

          # Scroller Layout Setting
          scroller_structs=20
          scroller_default_proportion=0.8
          scroller_focus_center=0
          scroller_prefer_center=0
          edge_scroller_pointer_focus=1
          scroller_default_proportion_single=1.0
          scroller_proportion_preset=0.5,0.8,1.0

          # Master-Stack Layout Setting
          new_is_master=0
          default_mfact=0.55
          default_nmaster=1
          smartgaps=0

          # Overview Setting
          hotarea_size=10
          enable_hotarea=1
          ov_tab_mode=0
          overviewgappi=5
          overviewgappo=30

          # Misc
          no_border_when_single=0
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

          # Key Bindings
          # key name refer to `xev` or `wev` command output,
          # mod keys name: super,ctrl,alt,shift,none

          # reload config
          bind=SUPER,r,reload_config

          # menu and terminal
          # bind=SUPER,space,spawn,fuzzel
          bind=SUPER,Return,spawn,ghostty

          # exit mango
          bind=SUPER+ALT+CTRL,q,quit

          # close client
          bind=SUPER,q,killclient,

          # alt tab
          bind=Alt,Tab,focusstack,next
          bind=Alt+Shift,Tab,focusstack,prev

          # switch window focus h j k l
          bind=SUPER,h,focusdir,left
          bind=SUPER,l,focusdir,right
          bind=SUPER,k,focusdir,up
          bind=SUPER,j,focusdir,down

          # swap window
          bind=SUPER+ALT,k,exchange_client,up
          bind=SUPER+ALT,j,exchange_client,down
          bind=SUPER+ALT,h,exchange_client,left
          bind=SUPER+ALT,l,exchange_client,right

          bind=SUPER,1,view,1,0
          bind=SUPER,2,view,2,0
          bind=SUPER,3,view,3,0
          bind=SUPER,4,view,4,0
          bind=SUPER,5,view,5,0
          bind=SUPER,6,view,6,0
          bind=SUPER,7,view,7,0
          bind=SUPER,8,view,8,0
          bind=SUPER,9,view,9,0

          # tag: move client to the tag and focus it
          bind=SUPER+CTRL,1,tag,1,0
          bind=SUPER+CTRL,2,tag,2,0
          bind=SUPER+CTRL,3,tag,3,0
          bind=SUPER+CTRL,4,tag,4,0
          bind=SUPER+CTRL,5,tag,5,0
          bind=SUPER+CTRL,6,tag,6,0
          bind=SUPER+CTRL,7,tag,7,0
          bind=SUPER+CTRL,8,tag,8,0
          bind=SUPER+CTRL,9,tag,9,0

          # tagsilent: move client to the tag and not focus it
          bind=SUPER+SHIFT,1,tagsilent,1,0
          bind=SUPER+SHIFT,2,tagsilent,2,0
          bind=SUPER+SHIFT,3,tagsilent,3,0
          bind=SUPER+SHIFT,4,tagsilent,4,0
          bind=SUPER+SHIFT,5,tagsilent,5,0
          bind=SUPER+SHIFT,6,tagsilent,6,0
          bind=SUPER+SHIFT,7,tagsilent,7,0
          bind=SUPER+SHIFT,8,tagsilent,8,0
          bind=SUPER+SHIFT,9,tagsilent,9,0

          # switch window status
          bind=SUPER,g,toggleglobal,
          bind=SUPER,Tab,toggleoverview,
          bind=SUPER,backslash,togglefloating,
          bind=SUPER,m,togglemaximizescreen,
          bind=SUPER,f,togglefullscreen,
          bind=SUPER+Alt,f,togglefakefullscreen,
          bind=SUPER,i,minimized,
          bind=SUPER+SHIFT,I,restore_minimized
          bind=SUPER,o,toggleoverlay,
          bind=SUPER,z,toggle_scratchpad

          # scroller layout
          bind=ALT,e,set_proportion,1.0
          bind=ALT,x,switch_proportion_preset,

          # switch layout
          bind=SUPER,n,switch_layout

          # monitor switch
          bind=alt+shift,Left,focusmon,left
          bind=alt+shift,Right,focusmon,right
          bind=SUPER+Alt,Left,tagmon,left
          bind=SUPER+Alt,Right,tagmon,right

          # gaps
          bind=ALT+SHIFT,X,incgaps,1
          bind=ALT+SHIFT,Z,incgaps,-1
          bind=ALT+SHIFT,R,togglegaps

          # movewin
          bind=CTRL+SHIFT,Up,movewin,+0,-50
          bind=CTRL+SHIFT,Down,movewin,+0,+50
          bind=CTRL+SHIFT,Left,movewin,-50,+0
          bind=CTRL+SHIFT,Right,movewin,+50,+0

          # resizewin
          bind=CTRL+ALT,Up,resizewin,+0,-50
          bind=CTRL+ALT,Down,resizewin,+0,+50
          bind=CTRL+ALT,Left,resizewin,-50,+0
          bind=CTRL+ALT,Right,resizewin,+50,+0

          # Mouse Button Bindings
          # btn_left and btn_right can't bind none mod key
          mousebind=SUPER,btn_left,moveresize,curmove
          mousebind=SUPER,btn_middle,togglemaximizescreen,0
          mousebind=SUPER,btn_right,moveresize,curresize

          # Axis Bindings
          axisbind=SUPER,UP,viewtoleft_have_client
          axisbind=SUPER,DOWN,viewtoright_have_client
          axisbind=SUPER,LEFT,viewtoleft
          axisbind=SUPER,RIGHT,viewtoright

          # layer rule
          # layerrule=animation_type_open:zoom,layer_name:rofi
          # layerrule=animation_type_close:zoom,layer_name:rofi

          # layerrule=animation_type_open:zoom,layer_name:fuzzel
          # layerrule=animation_type_close:zoom,layer_name:fuzzel

          layerrule=noshadow:1,layer_name:vicinae

          cursor_theme=hand-of-evil
          cursor_size=128

          windowrule=isfloating:1,appid:^(steam)$,title:^(Steam Settings)$
          windowrule=isfloating:1,appid:^(steam)$,title:^(Controller Layout)$
          windowrule=isfloating:1,appid:^(steam)$,title:^(Steam Controller Configs).*$

          windowrule=isfloating:1,appid:^(vivaldi-stable)$,title:^(Vivaldi Settings).*$
          windowrule=isfloating:1,appid:^(vivaldi-stable)$,title:^(title)$

          windowrule=isoverlay:1,isglobal:1,isfloating:1,appid:^()$,title:^(Picture in picture)$
          windowrule=width:1280,height:720,offsetx:90,offsety:90,appid:^()$,title:^(Picture in picture)$

          source=~/.config/mango/dyn.conf
        '';

        autostart_sh = /* bash */ ''
          wl-clip-persist --clipboard regular --reconnect-tries 0 &
          wl-paste --type text --watch cliphist store &
          ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd --all
          ${pkgs.vicinae}/bin/vicinae server
        '';
      };
    };
}
