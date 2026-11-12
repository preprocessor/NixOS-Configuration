{
  modules.core = { scheme, self, ... }: {
    imports = [ self.hjemModules.btop ];

    my.btop = {
      enable = true;

      settings = {
        color_theme = "base16";
        theme_background = false;
        disable_presets = "Default";
        presets = ''"cpu:0:default,mem:0:default,proc:0:default cpu:0:default,proc:0:default"'';

        shown_boxes = ''"cpu proc"'';

        show_disks = false;
        vim_keys = true;
        disable_mouse = true;
        rounded_corners = false;
      };

      themes.base16 = with scheme; ''
        theme[main_bg]="${base11}"
        theme[main_fg]="${base05}"
        theme[title]="${base05}"
        theme[hi_fg]="${base0B}"
        theme[selected_bg]="${base01}"
        theme[selected_fg]="${base05}"
        theme[inactive_fg]="${base01}"
        theme[graph_text]="${base06}"
        theme[meter_bg]="${base02}"
        theme[proc_misc]="${base06}"
        theme[cpu_box]="${base0E}"
        theme[mem_box]="${base0B}"
        theme[net_box]="${base0C}"
        theme[proc_box]="${base0D}"
        theme[div_line]="${base0E}"
        theme[temp_start]="${base0B}"
        theme[temp_mid]="${base0A}"
        theme[temp_end]="${base08}"
        theme[cpu_start]="${base0B}"
        theme[cpu_mid]="${base0A}"
        theme[cpu_end]="${base08}"
        theme[free_start]="${base0A}"
        theme[free_mid]="${base0B}"
        theme[free_end]="${base0B}"
        theme[cached_start]="${base0C}"
        theme[cached_mid]="${base0C}"
        theme[cached_end]="${base0A}"
        theme[available_start]="${base08}"
        theme[available_mid]="${base0A}"
        theme[available_end]="${base0B}"
        theme[used_start]="${base0B}"
        theme[used_mid]="${base0A}"
        theme[used_end]="${base08}"
        theme[download_start]="${base0B}"
        theme[download_mid]="${base0A}"
        theme[download_end]="${base08}"
        theme[upload_start]="${base0B}"
        theme[upload_mid]="${base0A}"
        theme[upload_end]="${base08}"
        theme[process_start]="${base0B}"
        theme[process_mid]="${base0A}"
        theme[process_end]="${base08}"
      '';
    };
  };
}
