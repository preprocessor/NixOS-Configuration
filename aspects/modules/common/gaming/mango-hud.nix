{
  modules.features.gaming = {
    my.mangohud = {
      enable = true;
      envConfig = true;

      settings = {
        position = "top-left";
        hud_compact = true;
        round_corners = 0;
        font_size = 17;

        background_alpha = 0;
        fps = true;
        frametime = true;
        fps_limit = "60+30+0"; # careful with the fps limiter, Dark Souls 2 SOFTS doesn't like it
        fps_limit_method = "early";
        toggle_fps_limit = "Alt_L+f";
        horizontal = true;

        cpu_stats = true;

        gpu_stats = true;

        ram = true;
        vram = true;

        toggle_hud = "Alt_L+m";
      };
    };
  };
}
