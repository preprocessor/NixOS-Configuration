{
  flake.modules.homeManager.desktop.wayland.windowManager.mango.settings = /* ini */ ''
    windowrule=isfloating:1,appid:^(steam)$,title:^(Steam Settings)$
    windowrule=isfloating:1,appid:^(steam)$,title:^(Controller Layout)$
    windowrule=isfloating:1,appid:^(steam)$,title:^(Steam Controller Configs).*$

    windowrule=isfloating:1,appid:^(vivaldi-stable)$,title:^(Vivaldi Settings).*$
    windowrule=isfloating:1,appid:^(vivaldi-stable)$,title:^(title)$

    windowrule=isoverlay:1,isglobal:1,isfloating:1,appid:^()$,title:^(Picture in picture)$
    windowrule=width:1280,height:720,offsetx:90,offsety:90,appid:^()$,title:^(Picture in picture)$

    windowrule=isoverlay:1,isglobal:1,isfloating:1,appid:^(waypaper)$,title:^(Waypaper)$
  '';
}
