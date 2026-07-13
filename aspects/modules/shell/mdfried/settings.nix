{
  exo.mods.desktop = {
    my.mdfried = {
      enable = true;
      settings = {
        font_family = "Maple Mono NF";
        stdio_query_timeout_ms = 2000;
        max_image_height = 30;
        watch_debounce_milliseconds = 100;
        enable_mouse_capture = false;
        osc8_links = true;
        url_transform_command = "readable | html2text";
        mermaid = "mmdc -i - -o - -e png";

        padding = {
          type = "centered";
          width = 100;
        };

        theme = {
          blockquote_bar = "▌ ";
          link_desc_open = "";
          link_desc_close = "";
          link_url_open = "◖";
          link_url_close = "◗";
          horizontal_rule_char = "─";
          task_checked_mark = "[✓] ";
          blockquote_colors = [
            "202"
            "203"
            "204"
            "205"
            "206"
            "207"
          ];
          link_bg = "237";
          link_fg = "4";
          prefix_color = "222";
          emphasis_color = "220";
          code_bg = "236";
          code_fg = "203";
          hr_color = "240";
          table_border_color = "240";
          table_header_color = "255";
          header_color = "#FFFFFF";
          hide_urls = true;
          hard_softbreaks = false;
        };
      };
    };

    _file = ./settings.nix;
  };
}
