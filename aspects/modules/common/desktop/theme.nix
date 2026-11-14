{
  modules.host.ramiel =
    { scheme, pkgs, ... }:
    {
      my.gtk = {
        enable = true;

        icons = {
          name = "Chicago95-tux";
          package = pkgs.chicago95;
        };

        theme = {
          name = "Chicago95";
          package = pkgs.chicago95;
          css = with scheme; ''
            :root {
              --c95-face: #333333;                  /* surface, base02 - Window Theme: buttonface */
              --c95-fg: #B0B0B0;                    /* foreground, base03 - windowtext */
              --c95-base: #161616;                  /* surfaceDeep - Window Theme: window (the sunken field) */
              --c95-text: #B0B0B0;                  /* foreground - windowtext on a field */
              --c95-text-light: #6E6E6E;            /* base05 - dim label / inactive sidebar-button text */
              --c95-selected-bg: #2DD4D8;           /* volumeLevel - Window Theme: hilight */
              --c95-selected-fg: #111111;           /* bevelDark - hilighttext, and text on any saturated fill */
              --c95-selected-inactive-bg: #2D2D2D;  /* surfaceMid - unfocused selection */
              --c95-selected-inactive-fg: #B0B0B0;
              --c95-border-bright: #6E6E6E;         /* base05 - outer TL of a raised bevel (was buttonlight) */
              --c95-border-light: #555555;          /* bevelLight - inner TL of a raised bevel */
              --c95-border-shade: #111111;          /* bevelDark - inner BR of a raised bevel */
              --c95-border-dark: #000000;           /* outline - outer BR of a raised bevel */
              --c95-border-face: #333333;           /* surface - where a bevel edge must vanish */
              --c95-border-shade-dark: #000000;     /* Sidebar row:selected inner shadow only */
              --c95-bright: #161616;                /* surfaceDeep - the real inner field, a sunken well */
              --c95-shade: #2D2D2D;                 /* surfaceMid - .sidebar list background, calendar.highlight */
              --c95-dark: #111111;                  /* bevelDark - dither second stop, titlebutton colour */
              --c95-asset-shadow: #555555;          /* Baked into scrollbar_button.png / notebook_*.png */
              --c95-asset-trough: #6E6E6E;          /* Outer edge of assets/scale.png */
              --c95-tooltip-bg: #2D2D2D;            /* surfaceMid - Window Theme: infowindow */
              --c95-tooltip-fg: #F5F5F5;            /* base09 - Window Theme: infotext */
              --c95-tooltip-shade: #111111;         /* The Clippy drop-shadow grey, unused in GTK4 - see note above */
              --c95-inactive-title-bg: #222222;     /* base01 - Window Theme: inactivetitle */
              --c95-inactive-title-fg: #6E6E6E;     /* base05 - Window Theme: inactivetitletext */
              --c95-scrollbar-trough: #161616;      /* surfaceDeep - Window Theme: scrollbar, base under the 50% dither */
              --c95-warning-bg: rgba(254, 179, 67, 0.16);  /* spectrumHigh at 16% - infobar .warning */
              --c95-error-bg: rgba(224, 82, 82, 0.16);     /* volumeMuted at 16% - infobar .error */
              --c95-success: #2DD46A;               /* tempLevel */
              --c95-warning: #FEB343;               /* spectrumHigh */
              --c95-error: #E05252;                 /* volumeMuted */
              --c95-disabled-fg: #555555;           /* base04 - Window Theme: buttonshadow */
              --c95-disabled-shadow: #000000;        /* the emboss behind disabled text, now a dark cut not a light one */
              --c95-outline: #555555;               /* The theme's global default outline-color */
              --c95-transparent: rgba(0, 0, 0, 0); }

            /* libadwaita 1.9 named colours, mapped onto the palette above.
                This block is what recolours every AdwApplicationWindow, AdwHeaderBar,
                AdwPreferencesPage, AdwStatusPage, boxed list, toast and dialog in one shot, before
                a single node selector is written.

                DELIBERATE DECISION - there is no second variant. libadwaita re-declares all of these
                inside @media (prefers-color-scheme: dark) and @media (prefers-contrast: more).
                Chicago95 has exactly one look: the shell's dark ramp, treated as a solid system
                colour set. Half of the palette (the light/dark bevel rings) carries structural
                meaning that inverts into nonsense, so there is no light answer to fall back to. The
                values below are declared unconditionally on bare :root, and then repeated verbatim
                inside the dark and high-contrast queries so that a user sitting on
                color-scheme=prefer-light - which is the minority of GNOME 50 installs, but not
                nobody - gets this theme rather than a washed-out stock-light UI with teal-on-white
                text. The repeated blocks reference the same var(--c95-*) tokens, so there is one
                source of truth for every value. */
            :root {
              /* Window */
              --window-bg-color: var(--c95-face);
              --window-fg-color: var(--c95-fg);

              /* Content views: textview, listview, columnview, gridview, iconview, .view */
              --view-bg-color: var(--c95-bright);
              --view-fg-color: var(--c95-text);

              /* Headerbar. libadwaita's default is flush window/grey; Chicago95's focused CSD
                  titlebar is a saturated band, and its backdrop is the flat inactivetitle grey. The
                  band is the shell's start-menu teal, its text the pale neutral step, so the
                  titlebar keeps the one place where Win95 put colour. Both shade colours go fully
                  transparent - they exist only to fake soft elevation. */
              --headerbar-bg-color: #1F5964;
              --headerbar-fg-color: #C8C8C8;
              --headerbar-border-color: #0E3038;
              --headerbar-backdrop-color: var(--c95-inactive-title-bg);
              --headerbar-shade-color: var(--c95-transparent);
              --headerbar-darker-shade-color: var(--c95-transparent);

              /* Sidebar panes (AdwNavigationSplitView / AdwOverlaySplitView) */
              --sidebar-bg-color: var(--c95-face);
              --sidebar-fg-color: var(--c95-fg);
              --sidebar-backdrop-color: var(--c95-face);
              --sidebar-border-color: var(--c95-border-shade);
              --sidebar-shade-color: var(--c95-transparent);
              --secondary-sidebar-bg-color: var(--c95-face);
              --secondary-sidebar-fg-color: var(--c95-fg);
              --secondary-sidebar-backdrop-color: var(--c95-face);
              --secondary-sidebar-border-color: var(--c95-border-shade);
              --secondary-sidebar-shade-color: var(--c95-transparent);

              /* Cards and boxed lists. Win95 group boxes are the button face, not a white sheet. */
              --card-bg-color: var(--c95-face);
              --card-fg-color: var(--c95-fg);
              --card-shade-color: var(--c95-transparent);

              /* Dialogs (AdwDialog / AdwAlertDialog / AdwPreferencesDialog sheets) */
              --dialog-bg-color: var(--c95-face);
              --dialog-fg-color: var(--c95-fg);

              /* Popovers, menus, dropdown lists */
              --popover-bg-color: var(--c95-face);
              --popover-fg-color: var(--c95-fg);
              --popover-shade-color: var(--c95-transparent);

              /* AdwTabOverview thumbnails */
              --thumbnail-bg-color: var(--c95-bright);
              --thumbnail-fg-color: var(--c95-fg);

              /* Generic elevation/scroll-edge shading. Chicago95 has no soft shading at all. */
              --shade-color: var(--c95-transparent);

              /* The 1px ring libadwaita draws round an overlay scrollbar slider */
              --scrollbar-outline-color: var(--c95-border-shade);

              /* Accent = the shell's live teal, the role Win95 gave to the navy hilight.
                  --accent-color must be set by hand: libadwaita derives it as
                  oklab(from var(--accent-bg-color) var(--standalone-color-oklab)), and the
                  dark-scheme recipe max(l, 0.85) shoots a mid-tone accent up into a pastel.
                  Same trap for all five standalone colours below. */
              --accent-bg-color: var(--c95-selected-bg);
              --accent-fg-color: var(--c95-selected-fg);
              --accent-color: var(--c95-selected-bg);
              --destructive-bg-color: var(--c95-error);
              --destructive-fg-color: var(--c95-selected-fg);
              --destructive-color: var(--c95-error);
              --success-bg-color: var(--c95-success);
              --success-fg-color: var(--c95-selected-fg);
              --success-color: var(--c95-success);
              --warning-bg-color: var(--c95-warning);
              --warning-fg-color: var(--c95-selected-fg);
              --warning-color: var(--c95-warning);
              --error-bg-color: var(--c95-error);
              --error-fg-color: var(--c95-selected-fg);
              --error-color: var(--c95-error);

              /* Pin the derivation recipe to the identity transform as a belt-and-braces measure,
                  so anything libadwaita derives that we have not listed stays on-palette instead of
                  being lightened or darkened into a colour the ramp never had. */
              --standalone-color-oklab: l a b;

              /* Borders. libadwaita's --border-color is currentColor-relative
                  (color-mix(in srgb, currentColor var(--border-opacity), transparent)), which is why
                  a hard bevel rule needs an explicit colour here and not just an opacity tweak.
                  --border-opacity goes to 100% so nothing translucent survives. */
              --border-color: var(--c95-border-shade);
              --border-opacity: 100%;

              /* Chicago95 does not express dim or disabled with translucency - dim text is a flat
                  step down the ramp and disabled text is that step with a dark emboss. Both opacity
                  levers are neutralised to 100% here so libadwaita cannot double-dim on top of the
                  colour rules in gtk-widgets.css; the greys come from those rules. */
              --dim-opacity: 100%;
              --disabled-opacity: 100%;

              /* The single highest-impact non-colour variable: 15px by default, and the reason an
                  Adw window stops looking like Win95 the moment you see its corners. */
              --window-radius: 0;

              /* Selected toggle in a toggle-group / AdwInlineViewSwitcher. Custom-property only -
                  these four have no @define-color twin, so they cannot be shimmed below. */
              --active-toggle-bg-color: var(--c95-face);
              --active-toggle-fg-color: var(--c95-fg);
              --overview-bg-color: var(--c95-face);
              --overview-fg-color: var(--c95-fg);

              /* AdwBanner tints this 30% into the window background. Flat face grey means no tint
                  at all; gtk-adwaita.css gives the banner its bevel instead. */
              --banner-color: var(--c95-face);

              /* The ten GNOME 47+ system accent presets. Overriding --accent-bg-color above already
                  beats whichever one the portal picked, but pinning them all to the teal means an
                  app that reads a preset by name directly also lands on-palette. */
              --accent-blue: var(--c95-selected-bg);
              --accent-teal: var(--c95-selected-bg);
              --accent-green: var(--c95-selected-bg);
              --accent-yellow: var(--c95-selected-bg);
              --accent-orange: var(--c95-selected-bg);
              --accent-red: var(--c95-selected-bg);
              --accent-pink: var(--c95-selected-bg);
              --accent-purple: var(--c95-selected-bg);
              --accent-slate: var(--c95-selected-bg);
              --accent-brown: var(--c95-selected-bg);

              /* The neutral half of the 45-swatch GNOME palette, remapped onto the ramp. The
                  chromatic ramps (--blue-1..5, --green-1..5, --yellow-1..5, --orange-1..5,
                  --red-1..5, --purple-1..5, --brown-1..5) are deliberately left at their stock
                  values: libadwaita's own widget rules do not read them, they are an app-facing
                  swatch API, and flattening someone's chart or tag colours to grey would be a
                  regression rather than a theme. */
              --light-1: var(--c95-border-bright);
              --light-2: var(--c95-border-light);
              --light-3: var(--c95-face);
              --light-4: var(--c95-shade);
              --light-5: var(--c95-border-shade);
              --dark-1: var(--c95-border-shade);
              --dark-2: var(--c95-dark);
              --dark-3: var(--c95-bright);
              --dark-4: var(--c95-border-dark);
              --dark-5: var(--c95-border-dark); }

            /* "dark" color scheme - identical to the bare :root on purpose. See the decision note
                above: Chicago95 has one look, and it is the shell's dark ramp. */
            @media (prefers-color-scheme: dark) {
              :root {
                --window-bg-color: var(--c95-face);
                --window-fg-color: var(--c95-fg);
                --view-bg-color: var(--c95-bright);
                --view-fg-color: var(--c95-text);
                --headerbar-bg-color: #1F5964;
                --headerbar-fg-color: #C8C8C8;
                --headerbar-border-color: #0E3038;
                --headerbar-backdrop-color: var(--c95-inactive-title-bg);
                --headerbar-shade-color: var(--c95-transparent);
                --headerbar-darker-shade-color: var(--c95-transparent);
                --sidebar-bg-color: var(--c95-face);
                --sidebar-fg-color: var(--c95-fg);
                --sidebar-backdrop-color: var(--c95-face);
                --sidebar-border-color: var(--c95-border-shade);
                --sidebar-shade-color: var(--c95-transparent);
                --secondary-sidebar-bg-color: var(--c95-face);
                --secondary-sidebar-fg-color: var(--c95-fg);
                --secondary-sidebar-backdrop-color: var(--c95-face);
                --secondary-sidebar-border-color: var(--c95-border-shade);
                --secondary-sidebar-shade-color: var(--c95-transparent);
                --card-bg-color: var(--c95-face);
                --card-fg-color: var(--c95-fg);
                --card-shade-color: var(--c95-transparent);
                --dialog-bg-color: var(--c95-face);
                --dialog-fg-color: var(--c95-fg);
                --popover-bg-color: var(--c95-face);
                --popover-fg-color: var(--c95-fg);
                --popover-shade-color: var(--c95-transparent);
                --thumbnail-bg-color: var(--c95-bright);
                --thumbnail-fg-color: var(--c95-fg);
                --shade-color: var(--c95-transparent);
                --scrollbar-outline-color: var(--c95-border-shade);
                --accent-bg-color: var(--c95-selected-bg);
                --accent-fg-color: var(--c95-selected-fg);
                --accent-color: var(--c95-selected-bg);
                --destructive-bg-color: var(--c95-error);
                --destructive-fg-color: var(--c95-selected-fg);
                --destructive-color: var(--c95-error);
                --success-bg-color: var(--c95-success);
                --success-fg-color: var(--c95-selected-fg);
                --success-color: var(--c95-success);
                --warning-bg-color: var(--c95-warning);
                --warning-fg-color: var(--c95-selected-fg);
                --warning-color: var(--c95-warning);
                --error-bg-color: var(--c95-error);
                --error-fg-color: var(--c95-selected-fg);
                --error-color: var(--c95-error);
                --standalone-color-oklab: l a b;
                --border-color: var(--c95-border-shade);
                --border-opacity: 100%;
                --dim-opacity: 100%;
                --disabled-opacity: 100%;
                --window-radius: 0;
                --active-toggle-bg-color: var(--c95-face);
                --active-toggle-fg-color: var(--c95-fg);
                --overview-bg-color: var(--c95-face);
                --overview-fg-color: var(--c95-fg);
                --banner-color: var(--c95-face); } }

            /* high contrast - same again. The bevels are already a hard 4-tone light/dark scheme,
                so prefers-contrast: more has nothing left to add and libadwaita's version of it
                (50% border opacity, 90% dim) only muddies ours. */
            @media (prefers-contrast: more) {
              :root {
                --window-bg-color: var(--c95-face);
                --window-fg-color: var(--c95-fg);
                --view-bg-color: var(--c95-bright);
                --view-fg-color: var(--c95-text);
                --headerbar-bg-color: #1F5964;
                --headerbar-fg-color: #C8C8C8;
                --headerbar-backdrop-color: var(--c95-inactive-title-bg);
                --headerbar-shade-color: var(--c95-transparent);
                --headerbar-darker-shade-color: var(--c95-transparent);
                --card-bg-color: var(--c95-face);
                --card-fg-color: var(--c95-fg);
                --card-shade-color: var(--c95-transparent);
                --dialog-bg-color: var(--c95-face);
                --dialog-fg-color: var(--c95-fg);
                --popover-bg-color: var(--c95-face);
                --popover-fg-color: var(--c95-fg);
                --popover-shade-color: var(--c95-transparent);
                --shade-color: var(--c95-transparent);
                --accent-bg-color: var(--c95-selected-bg);
                --accent-fg-color: var(--c95-selected-fg);
                --accent-color: var(--c95-selected-bg);
                --border-color: var(--c95-border-shade);
                --border-opacity: 100%;
                --dim-opacity: 100%;
                --disabled-opacity: 100%;
                --window-radius: 0; } }

            /* colormap actually used by plain-GTK4 apps and by third-party app CSS.
                COMPATIBILITY SHIM ONLY - overriding these has zero effect on libadwaita's own
                widget rendering (measured), which is exactly why every previous Windows 95 GTK4
                sheet looks 90% finished and behaves 0% finished. Every name is given a literal
                value rather than an alias, because the aliases do not chain across providers:
                redefining @window_bg_color does NOT fix @theme_fg_color. */

            /* libadwaita's own named colours */
            @define-color window_bg_color #333333; /* surface (base02) */
            @define-color window_fg_color #B0B0B0; /* foreground (base03) */
            @define-color view_bg_color #161616; /* surfaceDeep */
            @define-color view_fg_color #B0B0B0;
            @define-color headerbar_bg_color #1F5964; /* startBandTop */
            @define-color headerbar_fg_color #C8C8C8; /* base07 */
            @define-color headerbar_border_color #0E3038; /* startBandBottom */
            @define-color headerbar_backdrop_color #222222; /* base01 */
            @define-color headerbar_shade_color rgba(0,0,0,0);
            @define-color headerbar_darker_shade_color rgba(0,0,0,0);
            @define-color popover_bg_color #333333;
            @define-color popover_fg_color #B0B0B0;
            @define-color popover_shade_color rgba(0,0,0,0);
            @define-color dialog_bg_color #333333;
            @define-color dialog_fg_color #B0B0B0;
            @define-color card_bg_color #333333;
            @define-color card_fg_color #B0B0B0;
            @define-color card_shade_color rgba(0,0,0,0);
            @define-color sidebar_bg_color #333333;
            @define-color sidebar_fg_color #B0B0B0;
            @define-color sidebar_backdrop_color #333333;
            @define-color sidebar_border_color #111111;
            @define-color sidebar_shade_color rgba(0,0,0,0);
            @define-color secondary_sidebar_bg_color #333333;
            @define-color secondary_sidebar_fg_color #B0B0B0;
            @define-color secondary_sidebar_backdrop_color #333333;
            @define-color secondary_sidebar_border_color #111111;
            @define-color secondary_sidebar_shade_color rgba(0,0,0,0);
            @define-color thumbnail_bg_color #161616;
            @define-color thumbnail_fg_color #B0B0B0;
            @define-color shade_color rgba(0,0,0,0);
            @define-color scrollbar_outline_color #111111;
            @define-color accent_bg_color #2DD4D8; /* volumeLevel - Window Theme: hilight */
            @define-color accent_fg_color #111111; /* bevelDark - hilighttext */
            @define-color accent_color #2DD4D8;
            @define-color destructive_bg_color #E05252;
            @define-color destructive_fg_color #111111;
            @define-color destructive_color #E05252;
            @define-color success_bg_color #2DD46A;
            @define-color success_fg_color #111111;
            @define-color success_color #2DD46A;
            /* NAME COLLISION, resolved in Chicago95's favour. libadwaita means @warning_bg_color /
                @error_bg_color as saturated semantic surfaces; Chicago95 has used those exact two
                names since it was written for the pale Win95 infobar tints, and gtk-menus.css
                consumes them for infobar.warning / infobar.error. The Chicago95 meaning wins here
                because it is the only one anything in this theme reads: libadwaita's own warning
                and error surfaces resolve through --warning-bg-color / --error-bg-color in the
                :root block above, which are set to the saturated values independently, so both
                meanings are served without either name having to compromise. The tints are now
                dark-ramp washes of the accent hues rather than pale paper. */
            @define-color warning_bg_color rgba(254,179,67,0.16); /* infobar .warning */
            @define-color warning_color #FEB343;
            @define-color error_bg_color rgba(224,82,82,0.16);   /* infobar .error */
            @define-color error_color #E05252;
            /* warning_fg_color and error_fg_color are declared once, in the "misc colors used by
                gtk+" block below, at #111111 - the tone that reads on a saturated fill. They are
                deliberately NOT repeated here: a second @define-color for the same name silently
                overwrites the first, and having both blocks declare them was doing exactly that.
                libadwaita's own foreground is reached through --error-fg-color above. */
            @define-color borders #111111; /* bevelDark */
            @define-color unfocused_borders #111111;
            @define-color insensitive_bg_color #333333;
            @define-color insensitive_fg_color #555555;
            @define-color insensitive_base_color #333333;
            @define-color unfocused_insensitive_color #555555;

            /* GTK's public colour API. Read by Thunar, GIMP, Firefox chrome hacks and Chicago95's
                own app sheets, so it has to be right even though libadwaita ignores it. */
            @define-color theme_bg_color #333333;
            @define-color theme_fg_color #B0B0B0;
            @define-color theme_base_color #161616; /* tracks @base_color, as gtk-3.0/gtk.css:63 does */
            @define-color theme_text_color #B0B0B0;
            @define-color theme_selected_bg_color #2DD4D8;
            @define-color theme_selected_fg_color #111111;
            @define-color theme_tooltip_bg_color #2D2D2D;
            @define-color theme_tooltip_fg_color #F5F5F5;
            @define-color theme_unfocused_bg_color #333333;
            @define-color theme_unfocused_fg_color #B0B0B0;
            @define-color theme_unfocused_base_color #161616;
            @define-color theme_unfocused_text_color #B0B0B0;
            @define-color theme_unfocused_selected_bg_color #2DD4D8;
            @define-color theme_unfocused_selected_fg_color #111111;
            @define-color content_view_bg #161616;

            /* The Chicago95 vocabulary itself, so the five partials and any ported GTK3 rule can
                keep saying @bg_color / @border_bright / @border_dark unchanged, and get the shell
                ramp out of it. The 4-tone bevel keeps its Win95 ORDER and only changes tone:
                bright = the lightest ramp step, light = the mid step, shade = the near-black step,
                dark = pure black. On a dark surface that inverts the light direction of a raised
                edge, which is the one thing this recolour had to get right - a "white" highlight
                would have read as an emissive line, not as light hitting a bevel.
                shade() and alpha() are pre-resolved: GTK 4.22 deprecates both. */
            @define-color bg_color #333333; /* surface, base02 */
            @define-color fg_color #B0B0B0; /* foreground, base03 */
            @define-color base_color #161616; /* surfaceDeep */
            @define-color text_color #B0B0B0;
            @define-color text_color_light #6E6E6E;
            @define-color selected_bg_color #2DD4D8; /* volumeLevel - Window Theme: hilight */
            @define-color selected_fg_color #111111; /* bevelDark - hilighttext */
            @define-color selected_inactive_bg_color #2D2D2D;
            @define-color selected_inactive_fg_color #B0B0B0;
            @define-color border_color #333333; /* surface, where a bevel edge must vanish */
            @define-color border_bright #6E6E6E; /* base05 - outer TL of a raised bevel */
            @define-color border_light #555555; /* bevelLight - inner TL */
            @define-color border_shade #111111; /* bevelDark - inner BR */
            @define-color border_dark #000000; /* outline - outer BR */
            @define-color border_shade_dark #000000;
            @define-color bg_bright #161616; /* the sunken inner window/text area */
            @define-color bg_shade #2D2D2D;
            @define-color bg_dark #111111;

            /* Notebook colors.
                These MUST be declared even though every one of them resolves to a colour that already
                has a name, because GTK does not treat an unresolved @name as an error and does not
                drop the declaration that references it: it resolves the name to opaque white and lets
                that win the cascade. Measured on GTK 4.22.4 - a sheet referencing an undeclared @name
                parses with zero diagnostics and paints white. gtk-containers.css consumes all five of
                these on the notebook tab, so while they were missing a selected tab was white text on
                a white tab. Values follow gtk-3.0/gtk.css:120-125 (notebook_label* = @font_color,
                notebook_bg* = @bg_color). */
            @define-color notebook_label #B0B0B0;
            @define-color notebook_label_selected #B0B0B0;
            @define-color notebook_label_hover #B0B0B0;
            @define-color notebook_bg #333333;
            @define-color notebook_bg_selected #333333;
            @define-color notebook_bg_hover #333333;
            @define-color notebook_bg_arrow rgba(0,0,0,0);

            /* osd.
                Same story: gtk-widgets.css paints button.osd with @osd_base / @osd_fg, and without
                these two an .osd button had no face and no text colour. gtk-3.0/gtk.css:90-94
                defines osd_base = @dark_bg_color (= @bg_color) and osd_fg = @dark_fg_color
                (= @fg_color). @osd_bg is alpha(@osd_base, 0.8) upstream; alpha() is deprecated in
                GTK 4.22 and Chicago95 GTK4 has no translucent chrome, so it is pre-resolved to the
                flat face. @osd_trough_bg is the accent, so an OSD level bar still reads as "live". */
            @define-color osd_base #333333;
            @define-color osd_fg #B0B0B0;
            @define-color osd_bg #333333;
            @define-color osd_trough_bg #2DD4D8;
            @define-color disabled_font #555555; /* base04 - dim step */
            @define-color disabled_font_shadow #000000; /* the emboss, now a dark cut */
            @define-color outline_color #F5F5F5; /* base09 - the dotted focus rectangle */
            @define-color dark_shadow #000000;
            @define-color icon_shadow #000000;
            @define-color icon_shadow_bright #F5F5F5;
            @define-color font_color #B0B0B0;
            @define-color font_bright #F5F5F5;
            @define-color text_bright #F5F5F5;
            @define-color menu_bg_color #333333; /* applied to popover.menu */
            @define-color menu_text_color #B0B0B0;
            @define-color button_bg_color #333333;
            @define-color button_text_color #B0B0B0;
            @define-color toolbar_bg_color #333333;
            @define-color toolbar_fg_color #B0B0B0;
            @define-color window_title_bg_color #1F5964; /* startBandTop */
            @define-color window_title_text_color #C8C8C8; /* base07 */
            @define-color inactive_title_bg_color #222222; /* base01 */
            @define-color inactive_title_text_color #6E6E6E; /* base05 */
            @define-color scrollbar_trough_bg_color #161616;
            @define-color scrollbar_bg_color #333333;
            @define-color scrollbar_solid_color #333333;
            @define-color progressbar_color #2DD4D8;
            @define-color tooltip_bg_color #2D2D2D;
            @define-color tooltip_fg_color #F5F5F5;
            @define-color tooltip_bg_shade #111111; /* The Clippy shadow grey - kept for parity, unused in GTK4 */
            @define-color link_color #2DD4D8;
            @define-color link_color_shadow #111111;
            @define-color transparent rgba(0,0,0,0);

            /* misc colors used by gtk+.
                This block is the sole owner of warning_fg_color and error_fg_color - see the note in
                the libadwaita block above. Both are #111111 because the tinted infobar is a wash of
                a saturated hue: the dark ink is what reads on it, exactly as black did on the pale
                Win95 tint. */
            @define-color info_fg_color #B0B0B0;
            @define-color info_bg_color #2D2D2D;
            @define-color warning_fg_color #111111;
            @define-color question_fg_color #B0B0B0;
            @define-color question_bg_color #2D2D2D;
            @define-color error_fg_color #111111;

            /* dark color scheme - the same values again, for the same reason as the custom
                properties above: one look, in every scheme. */
            @define-color dark_bg_color #333333;
            @define-color dark_fg_color #B0B0B0;

            /* The GTK3 sheet's @wm_* block is NOT ported. All eleven names are defined in terms of
                @titlebar_bg_color / @titlebar_fg_color, which the theme never defines anywhere, and
                no selector in the theme consumes any of them - it has been broken upstream since it
                was written. Titlebar colours live in --headerbar-bg-color and @window_title_bg_color
                instead. */

            /***********************
              * Global resets       *
              **********************/

            /* Everything below is structural, not per-widget: it removes the three things that make
                an Adwaita app unmistakably not Windows 95 - rounded corners, soft elevation, and
                motion - across every node at once. Provider priority beats selector specificity in
                GTK4 (measured: a bare `label` rule at PRIORITY_USER beats a five-class chain at
                PRIORITY_THEME), so these short selectors defeat libadwaita's long ones, and the
                partials imported at the bottom of this file re-specify what they need on top. */

            /* The universal reset. This is the GTK4 descendant of the `*` rule at the top of
                gtk-3.0/gtk-widgets.css, minus every -Gtk* widget style property: GTK4 removed the
                entire mechanism, so -GtkWidget-*, -GtkMenu-*, -GtkScrollbar-*, -GtkScrolledWindow-*,
                -GtkTextView-*, -GtkToolButton-*, -GtkTreeView-*, -GtkWindow-* and -WnckTasklist-*
                are all hard parse errors in 4.22 and are gone. What survives of that rule is the
                outline four.
                background-clip is deliberately NOT set globally, even though the GTK3 `*` rule carries
                it. libadwaita uses `background-clip: padding-box` on thirteen nodes to make a
                transparent border act as inset spacing - listview > row, bare row, calendar,
                .app-notification, window.print paper and the popover.touch-selection / .magnifier /
                .osd family - and forcing border-box on all of them at PRIORITY_USER lets the
                background bleed into that border box for no Win95 gain. The three nodes in this theme
                that genuinely need border-box state it themselves: the scrollbar slider
                (gtk-containers.css), popover > contents and tooltip (gtk-menus.css). */
            /* NOT ACHIEVABLE AS WRITTEN, and the substitution matters: the GTK3 `*` rule also
                carries the theme's global outline (1px solid, offset 0, gtk-widgets.css lines 33-36).
                That cannot be ported verbatim, because GTK3 only painted an outline on a widget
                flagged as having visible focus, whereas GTK4 snapshots the outline of every node
                whose outline-width is non-zero - which is exactly why both stock GTK4 sheets keep
                their base state at `outline: 0 solid transparent` and only give a node an outline
                inside a :focus-visible rule. Porting the global outline would draw a 1px rectangle
                around every widget in every application. So the base state below is zero-width and
                transparent, and every focus rule in the partials states its own outline-color
                explicitly rather than inheriting a global one - @outline_color is #F5F5F5, the
                brightest ramp step, because a Win95-black dotted rect on a dark face is invisible. */
            * {
              border-radius: 0;
              box-shadow: none;
              transition: none;
              animation: none;
              outline: 0 solid transparent;
              outline-offset: 0; }

            /* Corners. Win95 had no rounded anything, and libadwaita rounds a lot of it: 5px on
                buttons and entries, 8px on frames, 9px on popover contents, 12px on cards and boxed
                lists, and --window-radius (15px) on the window itself, its dialogs and its bottom
                sheets. The `*` rule above already zeroes the property everywhere; these are the nodes
                where Adwaita either derives the radius from a variable or clips a child to it, so
                they need saying out loud or the corner survives as a clipped background. */
            window,
            window.csd,
            window.solid-csd,
            window.dialog,
            window.messagedialog,
            dialog-host > dialog > sheet,
            floating-sheet > sheet,
            bottom-sheet > sheet,
            popover > contents,
            .card,
            list.boxed-list,
            list.boxed-list > row,
            list.boxed-list > row:first-child,
            list.boxed-list > row:last-child,
            list.boxed-list-separate > row,
            infobar,
            toast,
            avatar,
            tabthumbnail .card,
            .keycap {
              border-radius: 0; }

            /* Elevation. Every libadwaita drop shadow is a lie about depth that Win95 told with two
                pixels of border instead, and the *_shade_color variables above have already been made
                transparent so the gradient-based ones render as nothing. These are the nodes that
                carry a literal box-shadow. Note this rule removes shadows only - it must never set a
                background, a border or a colour, or it would fight the partials. */
            window.csd,
            window.solid-csd,
            dialog-host > dialog > sheet,
            floating-sheet > sheet,
            bottom-sheet > sheet,
            popover,
            popover.background,
            popover > contents,
            popover > arrow,
            tooltip,
            tooltip.background,
            toast,
            .card,
            list.boxed-list,
            list.boxed-list-separate > row,
            menubar > item popover > contents,
            navigation-view > shadow,
            overlay-split-view > shadow,
            headerbar,
            toolbarview > .top-bar,
            toolbarview > .bottom-bar {
              box-shadow: none; }

            /* The soft-transition decoration nodes. AdwNavigationView and AdwOverlaySplitView paint
                dedicated shadow/dimming/border children that have no GTK3 equivalent at all; there is
                nothing to translate them into, so they are blanked. Windows 95 had no page
                transitions to shade. */
            navigation-view > shadow,
            navigation-view > dimming,
            navigation-view > border,
            overlay-split-view > shadow,
            overlay-split-view > dimming,
            overlay-split-view > border,
            scrolledwindow > undershoot.top,
            scrolledwindow > undershoot.bottom,
            scrolledwindow > undershoot.left,
            scrolledwindow > undershoot.right,
            scrolledwindow > overshoot.top,
            scrolledwindow > overshoot.bottom,
            scrolledwindow > overshoot.left,
            scrolledwindow > overshoot.right {
              background-image: none;
              background-color: transparent;
              box-shadow: none; }

            /* Motion. `transition: none` is set explicitly on button and button.sidebar-button in
                the GTK3 sheet; GTK4 and libadwaita add `transition: all 200ms` and a 300ms animated
                outline to nearly every interactive node, so it is cheaper to kill it once here for
                every node and every state than to remember it on each rule.
                `animation: none` is here as well as `transition: none`, and it has to be: both stock
                sheets drive GtkSpinner purely from CSS (`spinner:checked { animation: spin 1s linear
                infinite }`, GTK Default-light.css:102 and adw gtk.css:2495), and libadwaita pulses a
                needs-attention badge from @keyframes needs_attention. Neither has a Win95 analogue.
                The one animation Chicago95 keeps IS the 16-frame hourglass spinner, and it is really
                implemented: gtk-widgets.css declares @keyframes c95-hglass and re-enables it on
                `spinner:checked`. That works because the partials are imported below this point in the
                same provider, and `spinner:checked` (0,1,1) out-ranks `*:checked` (0,1,0) - verified
                on GTK 4.22.4 against a mapped, spinning GtkSpinner, which does carry the :checked
                state. Beware when editing: at PRIORITY_USER a `*` rule here beats even a long selector
                chain in libadwaita's sheet, so anything meant to survive must live in a partial and
                name a node. */
            *,
            *:hover,
            *:active,
            *:checked,
            *:focus,
            *:disabled,
            *:backdrop,
            *:selected {
              transition: none;
              animation: none;
              transition-property: none;
              transition-duration: 0s;
              transition-delay: 0s; }

            /* Focus. libadwaita's animated ring is already dead: the zero-width transparent outline
                in the universal reset above takes the base state, and the motion rules take the
                300ms outline transition. The actual Win95 focus rectangle - 1px dotted at
                outline-offset -4px, in @outline_color rather than black - is applied per widget in
                gtk-widgets.css, because it has to be excluded from
                treeview/columnview/listview/gridview/view/checkbutton/radiobutton (upstream's
                comment on that exclusion is emphatic: an outline on a treeview causes momentary UI
                displacement, "Keep the treeview exclusion!"), and because check and radio need the
                dots on their label instead.
                PARTIALLY UNACHIEVABLE, and worth knowing before anyone "fixes" it: outline-style:
                dotted and outline-offset both parse and render as real dots on GTK 4.22.4 - libgtk-4
                still stroke-dashes non-solid outlines - so the focus rectangle itself is faithful.
                What cannot be reproduced is Win95's *placement* on some GTK4 nodes: GTK4 derives the
                outline path from the node's border-radius and allocation, so on nodes whose painted
                surface is a child (entry > text, scale > trough, progressbar > trough) the ring
                traces the invisible parent instead of the visible field. Where that looks wrong the
                partials fall back to the repo's own idiom from gtk-checks_radio.css - a 1px dotted
                border on the label, pre-reserved with a transparent border so focusing does not
                reflow. */

            /* Fonts.
                DELIBERATELY UNSET, and this is a metric, not an omission: there is no font-family
                anywhere in Theme/Chicago95/gtk-3.0/*.css. The interface font comes from
                XSettings/gsettings - INSTALL.md recommends the bundled bitmap Helvetica OTB (or real
                MS Sans Serif) at 8pt - and the installer sets the xfwm4 title font separately. Naming
                a family here would make GTK4 apps disagree with GTK3 apps on the same desktop, which
                is a worse failure than inheriting whatever the user chose. Only three explicit sizes
                exist in the whole GTK3 tree, and every one of them is scoped to a widget rather than
                global: 8pt on the SSD titlebar label, 11px on the Whisker menu button, and `smaller`
                on the headerbar subtitle. The titlebar 8pt is applied in gtk-containers.css, and
                libadwaita's typography classes (.title-1 .. .title-4, .heading, .caption) are left at
                their stock sizes so AdwStatusPage and AdwPreferencesGroup keep a legible hierarchy.
                What IS reset globally is emboss: Chicago95 uses a text/icon shadow for exactly one
                thing - the disabled #555555-with-#000000-emboss look - and that is applied on
                :disabled in gtk-widgets.css, whose selector outranks the rule below. */
            label {
              text-shadow: none;
              -gtk-icon-shadow: none; }

            /* Icon rendering. GTK3's `-gtk-icon-effect: dim` is a hard parse error in 4.22 ("No
                property named -gtk-icon-effect"); GTK4's own sheet uses -gtk-icon-filter for the same
                job, and the disabled-icon substitution lives with the disabled-text rule in
                gtk-widgets.css. Here we only make sure nothing inherits a scale transform.

                Deliberately NOT `-gtk-icon-style: regular` here. That property does not merely stop
                a recolour - it makes GTK prefer the non-symbolic variant of every icon it looks up,
                so each symbolic icon is replaced by whatever full-colour legacy icon the active icon
                theme happens to ship. Measured against the Yaru icon theme: the window-close button
                stopped being a glyph and became Yaru's red circle, because
                /usr/share/icons/Yaru/16x16/legacy/window-close.svg is full-colour #c7162b. Symbolic
                icons recoloured through `color` are what give Chicago95 its flat single-tone glyphs,
                so the default symbolic lookup is what we want globally. The few nodes that genuinely
                want a period bitmap set `-gtk-icon-source` explicitly instead. */
            image,
            image:backdrop {
              -gtk-icon-transform: none; }

            /***********************
              * Known unstyled      *
              **********************/

            /* These nodes have no owner in any of the five partials, and that is a scope decision
                rather than an oversight - recording it here so the next contributor does not have to
                work out which of the five files was supposed to have taken them. Each one renders as
                stock Adwaita: square-cornered, because the global resets above reach every node, but
                otherwise unthemed.

                  calendar                     gtk-3.0/gtk-widgets.css:132-161 gives calendar.view a
                                              2px border-image and calendar.header a full raised
                                              bevel. GTK4 nodes are calendar > header > button and
                                              calendar > grid > label.day-number.
                  colorswatch / colorchooser   41 rules in libadwaita; gtk-3.0 covers it across
                                              gtk-buttons.css and gtk-basic-effects.css. Note
                                              colorswatch is round by default in libadwaita.
                  stacksidebar                 gtk-3.0/gtk-widgets.css:268-291 (row padding 3px,
                                              selected focus dots at offset -6px).
                  expander-widget              GtkExpander's own arrow, expander-widget > box > title
                                              > arrow. gtk-lists.css scopes all of its expander work
                                              under treeexpander, which is a different widget.
                  placessidebar / filechooser  27 filechooser rules in libadwaita. Partly reached
                                              already through .navigation-sidebar in gtk-lists.css.

                Porting them wants a sixth partial following the gtk-3.0 naming - gtk-basic-effects.css
                or gtk-misc.css - rather than being wedged into one of the existing five. */

            /***********************
              * Widget partials     *
              **********************/

            /* Please keep these in their original load order. Later files intentionally override
                earlier ones, and every one of them overrides the global resets above - imported rules
                cascade as if they were written at the position of the @import, which is why the list
                sits at the bottom of the file rather than the top. */
            @import url("gtk-widgets.css");
            @import url("gtk-containers.css");
            @import url("gtk-lists.css");
            @import url("gtk-menus.css");
            @import url("gtk-adwaita.css");
          '';
        };
      };
    };
}
