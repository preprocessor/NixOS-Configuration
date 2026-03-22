{
  flake.modules.homeManager.desktop.wayland.windowManager.mango.settings = /* ini */ ''
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
  '';
}
