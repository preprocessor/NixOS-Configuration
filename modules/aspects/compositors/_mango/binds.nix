{
  flake.modules.homeManager.desktop.wayland.windowManager.mango.settings = /* ini */ ''
    # Key Bindings
    # key name refer to `xev` or `wev` command output,
    # mod keys name: super,ctrl,alt,shift,none

    # reload config
    bind=SUPER,r,reload_config

    # app launcher
    bind=SUPER,space,spawn,tofi-drun --drun-launch=true
    # cmd launcher
    bind=SUPER+ALT,space,spawn_shell,tofi-run | xargs --no-run-if-empty ghostty -e
    # emoji picker
    bind=SUPER,period,spawn,bemoji

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

    # volume
    bind=NONE,XF86AudioRaiseVolume,spawn,wpctl set-volume @DEFAULT_SINK@ 5%+
    bind=NONE,XF86AudioLowerVolume,spawn,wpctl set-volume @DEFAULT_SINK@ 5%-
    bind=NONE,XF86AudioMute,spawn,wpctl set-mute @DEFAULT_SINK@ toggle
    bind=SHIFT,XF86AudioMute,spawn,wpctl set-mute @DEFAULT_SOURCE@ toggle

    # brightness
    bind=SUPER,F2,spawn,brightnessctl s +2%
    bind=SUPER+SHIFT,F2,spawn,brightnessctl s 100%
    bind=SUPER,F1,spawn,brightnessctl s 2%-
    bind=SUPER+SHIFT,F1,spawn,brightnessctl s 1%

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
  '';
}
