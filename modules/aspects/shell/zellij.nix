{
  flake.modules.homeManager.default =
    { osConfig, pkgs, ... }:
    let
      scheme = osConfig.scheme;

      zjstatus = pkgs.fetchurl {
        url = "https://github.com/dj95/zjstatus/releases/download/v0.22.0/zjstatus.wasm";
        hash = "sha256:4de426d20b1cbf861272e927aeeb5b49d92c17f0e2bb9d173f85bf7f0154dd53";
      };

      zjstatus-hints = pkgs.fetchurl {
        url = "https://github.com/b0o/zjstatus-hints/releases/download/v0.1.4/zjstatus-hints.wasm";
        hash = "sha256:936c55e9025c0edbd43421383efc151bdfdc78e924f966bfe9e7c682bec8719d";
      };

      zjautolock = pkgs.fetchurl {
        url = "https://github.com/fresh2dev/zellij-autolock/releases/download/0.2.2/zellij-autolock.wasm";
        hash = "sha256-aclWB7/ZfgddZ2KkT9vHA6gqPEkJ27vkOVLwIEh7jqQ=";
      };

      vim-zellij-navigator = pkgs.fetchurl {
        url = "https://github.com/hiasr/vim-zellij-navigator/releases/download/0.3.0/vim-zellij-navigator.wasm";
        hash = "sha256:77e5a2f62f7c1a698caf2574493d5d75587e0fd877cfba34c48caf731c24c58d";
      };

    in
    {
      xdg.configFile."zellij/layouts/default.kdl".text = /* kdl */ ''
        layout {
          default_tab_template {
            children
            pane size=1 borderless=true {
              plugin location="file:${zjstatus}" {
                hide_frame_for_single_pane "true"

                format_left   "{mode}{tabs}"
                format_center ""
                format_right  "{pipe_zjstatus_hints}{datetime}"
                format_space  ""

                // Note: this is necessar
                pipe_zjstatus_hints_format "{output}"

                mode_normal               "#[fg=#${scheme.base00},bg=#${scheme.base0B},bold] {name} "
                mode_locked               "#[fg=#${scheme.base00},bg=#${scheme.base08},bold] {name} "
                mode_resize               "#[fg=#${scheme.base00},bg=#${scheme.base0A},bold] {name} "
                mode_pane                 "#[fg=#${scheme.base00},bg=#${scheme.base0E},bold] {name} "
                mode_tab                  "#[fg=#${scheme.base00},bg=#${scheme.base0D},bold] {name} "
                mode_scroll               "#[fg=#${scheme.base00},bg=#${scheme.base0C},bold] {name} "
                mode_session              "#[fg=#${scheme.base00},bg=#${scheme.base09},bold] {name} "
                mode_move                 "#[fg=#${scheme.base00},bg=#${scheme.base0F},bold] {name} "

                // inactive tabs
                tab_normal                "#[fg=#${scheme.base03},bg=#${scheme.base01}] {index} {floating_indicator}"   
                tab_normal_fullscreen     "#[fg=#${scheme.base03},bg=#${scheme.base01}] {index} {fullscreen_indicator}" 
                tab_normal_sync           "#[fg=#${scheme.base03},bg=#${scheme.base01}] {index} {sync_indicator}"       

                // formatting for the current active tab
                tab_active                "#[fg=#${scheme.base00},bg=#${scheme.base0D},bold] {index} {floating_indicator}"
                tab_active_fullscreen     "#[fg=#${scheme.base00},bg=#${scheme.base0D},bold] {index} {fullscreen_indicator}"
                tab_active_sync           "#[fg=#${scheme.base00},bg=#${scheme.base0D},bold] {index} {sync_indicator}"

                tab_separator             ""
                // format when renaming a tab
                tab_rename                "#[bg=#${scheme.base0E},fg=#${scheme.base00}] {index} {name} {floating_indicator} "

                // indicators
                tab_sync_indicator        "<> "
                tab_fullscreen_indicator  "[] "
                tab_floating_indicator    "⬚ "

                // limit tab display count
                tab_display_count         "3"  // limit number of visible tabs
                tab_truncate_start_format "#[fg=#${scheme.base0A},bg=#${scheme.base03}]#[fg=#${scheme.base00},bg=#${scheme.base0A}]+{count} "
                tab_truncate_end_format   "#[fg=#${scheme.base00},bg=#${scheme.base0A}] +{count}#[fg=#${scheme.base0A}]"

                datetime                  "#[fg=#${scheme.base00},bg=#${scheme.base04},bold] {format} "
                datetime_format           "%l:%M %p"
                datetime_timezone         "America/New_York"
              }
            }
          }
        }
      '';

      programs.zellij = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
        exitShellOnExit = true;

        settings = {
          theme = "everforest-dark";
          pane_frames = false;
          show_startup_tips = false;

          ui.pane_frames.hide_session_name = true;
        };
        extraConfig = /* kdl */ ''
          plugins {
              zjstatus-hints location="file:${zjstatus-hints}" {
                  // Maximum number of characters to display
                  max_length 100 // 0 = unlimited
                  // String to append when truncated
                  overflow_str "..." // default
                  // Name of the pipe for zjstatus integration
                  pipe_name "zjstatus_hints" // default
                  // Hide hints in base mode (a.k.a. default mode)
                  // E.g. if you have set default_mode to "locked", then
                  // you can hide hints in the locked mode by setting this to true
                  hide_in_base_mode true
              }

              autolock location="file:${zjautolock}" {
                  // Enabled at start?
                  is_enabled true
                  // Lock when any open these programs open.
                  triggers "nvim|vim|git|fzf|zoxide|atuin"
                  // Reaction to input occurs after this many seconds. (default=0.3)
                  // (An existing scheduled reaction prevents additional reactions.)
                  reaction_seconds "0.3"
                  // Print to Zellij log? (default=false)
                  print_to_log true
              }
          }

          load_plugins {
              // Load at startup
              zjstatus-hints
          }

          keybinds clear-defaults=true {
              shared_except "locked" {
                  bind "Ctrl h" {
                      MessagePlugin "file:${vim-zellij-navigator}" {
                          name "move_focus_or_tab";
                          payload "left";

                          // Plugin Configuration
                          move_mod "ctrl"; // Optional, should be added on every move command if changed.
                          use_arrow_keys "false"; // Optional, uses arrow keys instead of hjkl. Should be added to every command where you want to use it.
                      };
                  }

                  bind "Ctrl j" {
                      MessagePlugin "file:${vim-zellij-navigator}" {
                          name "move_focus";
                          payload "down";

                          move_mod "ctrl";
                          use_arrow_keys "false";
                      };
                  }

                  bind "Ctrl k" {
                      MessagePlugin "file:${vim-zellij-navigator}" {
                          name "move_focus";
                          payload "up";

                          move_mod "ctrl";
                          use_arrow_keys "false";
                      };
                  }

                  bind "Ctrl l" {
                      MessagePlugin "file:${vim-zellij-navigator}" {
                          name "move_focus_or_tab";
                          payload "right";

                          move_mod "ctrl"; // Optional, should be added on every command if you want to use it
                          use_arrow_keys "false";
                      };
                  }

                  bind "Alt h" {
                      MessagePlugin "file:${vim-zellij-navigator}" {
                          name "resize";
                          payload "left";

                          resize_mod "alt"; 
                      };
                  }

                  bind "Alt j" {
                      MessagePlugin "file:${vim-zellij-navigator}" {
                          name "resize";
                          payload "down";

                          resize_mod "alt";
                      };
                  }

                  bind "Alt k" {
                      MessagePlugin "file:${vim-zellij-navigator}" {
                          name "resize";
                          payload "up";

                          resize_mod "alt";
                      };
                  }

                  bind "Alt l" {
                      MessagePlugin "file:${vim-zellij-navigator}" {
                          name "resize";
                          payload "right";

                          resize_mod "alt";
                      };
                  }
              }

              locked {
                  bind "Ctrl Space" { SwitchToMode "normal"; }
              }
              pane {
                  bind "left" { MoveFocus "left"; }
                  bind "down" { MoveFocus "down"; }
                  bind "up" { MoveFocus "up"; }
                  bind "right" { MoveFocus "right"; }
                  bind "c" { SwitchToMode "renamepane"; PaneNameInput 0; }
                  bind "d" { NewPane "down"; SwitchToMode "locked"; }
                  bind "e" { TogglePaneEmbedOrFloating; SwitchToMode "locked"; }
                  bind "f" { ToggleFocusFullscreen; SwitchToMode "locked"; }
                  bind "h" { MoveFocus "left"; }
                  bind "i" { TogglePanePinned; SwitchToMode "locked"; }
                  bind "j" { MoveFocus "down"; }
                  bind "k" { MoveFocus "up"; }
                  bind "l" { MoveFocus "right"; }
                  bind "n" { NewPane; SwitchToMode "locked"; }
                  bind "p" { SwitchToMode "normal"; }
                  bind "r" { NewPane "right"; SwitchToMode "locked"; }
                  bind "s" { NewPane "stacked"; SwitchToMode "locked"; }
                  bind "w" { ToggleFloatingPanes; SwitchToMode "locked"; }
                  bind "x" { CloseFocus; SwitchToMode "locked"; }
                  bind "z" { TogglePaneFrames; SwitchToMode "locked"; }
                  bind "tab" { SwitchFocus; }
              }
              tab {
                  bind "left" { GoToPreviousTab; }
                  bind "down" { GoToNextTab; }
                  bind "up" { GoToPreviousTab; }
                  bind "right" { GoToNextTab; }
                  bind "1" { GoToTab 1; SwitchToMode "locked"; }
                  bind "2" { GoToTab 2; SwitchToMode "locked"; }
                  bind "3" { GoToTab 3; SwitchToMode "locked"; }
                  bind "4" { GoToTab 4; SwitchToMode "locked"; }
                  bind "5" { GoToTab 5; SwitchToMode "locked"; }
                  bind "6" { GoToTab 6; SwitchToMode "locked"; }
                  bind "7" { GoToTab 7; SwitchToMode "locked"; }
                  bind "8" { GoToTab 8; SwitchToMode "locked"; }
                  bind "9" { GoToTab 9; SwitchToMode "locked"; }
                  bind "[" { BreakPaneLeft; SwitchToMode "locked"; }
                  bind "]" { BreakPaneRight; SwitchToMode "locked"; }
                  bind "b" { BreakPane; SwitchToMode "locked"; }
                  bind "h" { GoToPreviousTab; }
                  bind "j" { GoToNextTab; }
                  bind "k" { GoToPreviousTab; }
                  bind "l" { GoToNextTab; }
                  bind "n" { NewTab; SwitchToMode "locked"; }
                  bind "r" { SwitchToMode "renametab"; TabNameInput 0; }
                  bind "s" { ToggleActiveSyncTab; SwitchToMode "locked"; }
                  bind "t" { SwitchToMode "normal"; }
                  bind "x" { CloseTab; SwitchToMode "locked"; }
                  bind "tab" { ToggleTab; }
              }
              resize {
                  bind "left" { Resize "Increase left"; }
                  bind "down" { Resize "Increase down"; }
                  bind "up" { Resize "Increase up"; }
                  bind "right" { Resize "Increase right"; }
                  bind "+" { Resize "Increase"; }
                  bind "-" { Resize "Decrease"; }
                  bind "=" { Resize "Increase"; }
                  bind "H" { Resize "Decrease left"; }
                  bind "J" { Resize "Decrease down"; }
                  bind "K" { Resize "Decrease up"; }
                  bind "L" { Resize "Decrease right"; }
                  bind "h" { Resize "Increase left"; }
                  bind "j" { Resize "Increase down"; }
                  bind "k" { Resize "Increase up"; }
                  bind "l" { Resize "Increase right"; }
                  bind "r" { SwitchToMode "normal"; }
              }
              move {
                  bind "left" { MovePane "left"; }
                  bind "down" { MovePane "down"; }
                  bind "up" { MovePane "up"; }
                  bind "right" { MovePane "right"; }
                  bind "h" { MovePane "left"; }
                  bind "j" { MovePane "down"; }
                  bind "k" { MovePane "up"; }
                  bind "l" { MovePane "right"; }
                  bind "m" { SwitchToMode "normal"; }
                  bind "n" { MovePane; }
                  bind "p" { MovePaneBackwards; }
                  bind "tab" { MovePane; }
              }
              scroll {
                  bind "Alt left" { MoveFocusOrTab "left"; SwitchToMode "locked"; }
                  bind "Alt down" { MoveFocus "down"; SwitchToMode "locked"; }
                  bind "Alt up" { MoveFocus "up"; SwitchToMode "locked"; }
                  bind "Alt right" { MoveFocusOrTab "right"; SwitchToMode "locked"; }
                  bind "e" { EditScrollback; SwitchToMode "locked"; }
                  bind "f" { SwitchToMode "entersearch"; SearchInput 0; }
                  bind "Alt h" { MoveFocusOrTab "left"; SwitchToMode "locked"; }
                  bind "Alt j" { MoveFocus "down"; SwitchToMode "locked"; }
                  bind "Alt k" { MoveFocus "up"; SwitchToMode "locked"; }
                  bind "Alt l" { MoveFocusOrTab "right"; SwitchToMode "locked"; }
                  bind "s" { SwitchToMode "normal"; }
              }
              search {
                  bind "c" { SearchToggleOption "CaseSensitivity"; }
                  bind "n" { Search "down"; }
                  bind "o" { SearchToggleOption "WholeWord"; }
                  bind "p" { Search "up"; }
                  bind "w" { SearchToggleOption "Wrap"; }
              }
              session {
                  bind "a" {
                      LaunchOrFocusPlugin "zellij:about" {
                          floating true
                          move_to_focused_tab true
                      }
                      SwitchToMode "locked"
                  }
                  bind "c" {
                      LaunchOrFocusPlugin "configuration" {
                          floating true
                          move_to_focused_tab true
                      }
                      SwitchToMode "locked"
                  }
                  bind "d" { Detach; }
                  bind "o" { SwitchToMode "normal"; }
                  bind "p" {
                      LaunchOrFocusPlugin "plugin-manager" {
                          floating true
                          move_to_focused_tab true
                      }
                      SwitchToMode "locked"
                  }
                  bind "s" {
                      LaunchOrFocusPlugin "zellij:share" {
                          floating true
                          move_to_focused_tab true
                      }
                      SwitchToMode "locked"
                  }
                  bind "w" {
                      LaunchOrFocusPlugin "session-manager" {
                          floating true
                          move_to_focused_tab true
                      }
                      SwitchToMode "locked"
                  }
              }
              shared_among "normal" "locked" {
                  bind "Alt left" { MoveFocusOrTab "left"; }
                  bind "Alt down" { MoveFocus "down"; }
                  bind "Alt up" { MoveFocus "up"; }
                  bind "Alt right" { MoveFocusOrTab "right"; }
                  bind "Alt +" { Resize "Increase"; }
                  bind "Alt -" { Resize "Decrease"; }
                  bind "Alt =" { Resize "Increase"; }
                  bind "Alt [" { PreviousSwapLayout; }
                  bind "Alt ]" { NextSwapLayout; }
                  bind "Alt f" { ToggleFloatingPanes; }
                  bind "Alt h" { MoveFocusOrTab "left"; }
                  bind "Alt i" { MoveTab "left"; }
                  bind "Alt j" { MoveFocus "down"; }
                  bind "Alt k" { MoveFocus "up"; }
                  bind "Alt l" { MoveFocusOrTab "right"; }
                  bind "Alt n" { NewPane; }
                  bind "Alt o" { MoveTab "right"; }
                  bind "Alt p" { TogglePaneInGroup; }
                  bind "Alt Shift p" { ToggleGroupMarking; }
              }
              shared_except "locked" "renametab" "renamepane" {
                  bind "Ctrl g" { SwitchToMode "locked"; }
                  bind "Ctrl q" { Quit; }
              }
              shared_except "locked" "entersearch" {
                  bind "enter" { SwitchToMode "locked"; }
              }
              shared_except "locked" "entersearch" "renametab" "renamepane" {
                  bind "esc" { SwitchToMode "locked"; }
              }
              shared_except "locked" "entersearch" "renametab" "renamepane" "move" {
                  bind "m" { SwitchToMode "move"; }
              }
              shared_except "locked" "entersearch" "search" "renametab" "renamepane" "session" {
                  bind "o" { SwitchToMode "session"; }
              }
              shared_except "locked" "tab" "entersearch" "renametab" "renamepane" {
                  bind "t" { SwitchToMode "tab"; }
              }
              shared_among "normal" "resize" "tab" "scroll" "prompt" "tmux" {
                  bind "p" { SwitchToMode "pane"; }
              }
              shared_among "normal" "resize" "search" "move" "prompt" "tmux" {
                  bind "s" { SwitchToMode "scroll"; }
              }
              shared_except "locked" "resize" "pane" "tab" "entersearch" "renametab" "renamepane" {
                  bind "r" { SwitchToMode "resize"; }
              }
              shared_among "scroll" "search" {
                  bind "PageDown" { PageScrollDown; }
                  bind "PageUp" { PageScrollUp; }
                  bind "left" { PageScrollUp; }
                  bind "down" { ScrollDown; }
                  bind "up" { ScrollUp; }
                  bind "right" { PageScrollDown; }
                  bind "Ctrl b" { PageScrollUp; }
                  bind "Ctrl c" { ScrollToBottom; SwitchToMode "locked"; }
                  bind "d" { HalfPageScrollDown; }
                  bind "Ctrl f" { PageScrollDown; }
                  bind "h" { PageScrollUp; }
                  bind "j" { ScrollDown; }
                  bind "k" { ScrollUp; }
                  bind "l" { PageScrollDown; }
                  bind "u" { HalfPageScrollUp; }
              }
              entersearch {
                  bind "Ctrl c" { SwitchToMode "scroll"; }
                  bind "esc" { SwitchToMode "scroll"; }
                  bind "enter" { SwitchToMode "search"; }
              }
              renametab {
                  bind "esc" { UndoRenameTab; SwitchToMode "tab"; }
              }
              shared_among "renametab" "renamepane" {
                  bind "Ctrl c" { SwitchToMode "locked"; }
              }
              renamepane {
                  bind "esc" { UndoRenamePane; SwitchToMode "pane"; }
              }
          }

          // Plugin aliases - can be used to change the implementation of Zellij
          // changing these requires a restart to take effect
          plugins {
              about location="zellij:about"
              compact-bar location="zellij:compact-bar"
              configuration location="zellij:configuration"
              filepicker location="zellij:strider" {
                  cwd "/"
              }
              plugin-manager location="zellij:plugin-manager"
              session-manager location="zellij:session-manager"
              status-bar location="zellij:status-bar"
              strider location="zellij:strider"
              tab-bar location="zellij:tab-bar"
              welcome-screen location="zellij:session-manager" {
                  welcome_screen true
              }
          }

          // Plugins to load in the background when a new session starts
          // eg. "file:/path/to/my-plugin.wasm"
          // eg. "https://example.com/my-plugin.wasm"
          load_plugins {
          }
          web_client {
              font "monospace"
          }

          // Use a simplified UI without special fonts (arrow glyphs)
          // Options:
          //   - true
          //   - false (Default)
          // 
          // simplified_ui true

          // Choose the theme that is specified in the themes section.
          // Default: default
          // 
          // theme "dracula"

          // Choose the base input mode of zellij.
          // Default: normal
          // 
          default_mode "locked"

          // Choose the path to the default shell that zellij will use for opening new panes
          // Default: $SHELL
          // 
          // default_shell "fish"

          // Choose the path to override cwd that zellij will use for opening new panes
          // 
          // default_cwd "/tmp"

          // The name of the default layout to load on startup
          // Default: "default"
          // 
          // default_layout "compact"

          // The folder in which Zellij will look for layouts
          // (Requires restart)
          // 
          // layout_dir "/tmp"

          // The folder in which Zellij will look for themes
          // (Requires restart)
          // 
          // theme_dir "/tmp"

          // Toggle enabling the mouse mode.
          // On certain configurations, or terminals this could
          // potentially interfere with copying text.
          // Options:
          //   - true (default)
          //   - false
          // 
          // mouse_mode false

          // Toggle having pane frames around the panes
          // Options:
          //   - true (default, enabled)
          //   - false
          // 
          // pane_frames false

          // When attaching to an existing session with other users,
          // should the session be mirrored (true)
          // or should each user have their own cursor (false)
          // (Requires restart)
          // Default: false
          // 
          // mirror_session true

          // Choose what to do when zellij receives SIGTERM, SIGINT, SIGQUIT or SIGHUP
          // eg. when terminal window with an active zellij session is closed
          // (Requires restart)
          // Options:
          //   - detach (Default)
          //   - quit
          // 
          // on_force_close "quit"

          // Configure the scroll back buffer size
          // This is the number of lines zellij stores for each pane in the scroll back
          // buffer. Excess number of lines are discarded in a FIFO fashion.
          // (Requires restart)
          // Valid values: positive integers
          // Default value: 10000
          // 
          // scroll_buffer_size 10000

          // Provide a command to execute when copying text. The text will be piped to
          // the stdin of the program to perform the copy. This can be used with
          // terminal emulators which do not support the OSC 52 ANSI control sequence
          // that will be used by default if this option is not set.
          // Examples:
          //
          // copy_command "xclip -selection clipboard" // x11
          // copy_command "wl-copy"                    // wayland
          // copy_command "pbcopy"                     // osx
          // 
          // copy_command "pbcopy"

          // Choose the destination for copied text
          // Allows using the primary selection buffer (on x11/wayland) instead of the system clipboard.
          // Does not apply when using copy_command.
          // Options:
          //   - system (default)
          //   - primary
          // 
          // copy_clipboard "primary"

          // Enable automatic copying (and clearing) of selection when releasing mouse
          // Default: true
          // 
          // copy_on_select true

          // Path to the default editor to use to edit pane scrollbuffer
          // Default: $EDITOR or $VISUAL
          // scrollback_editor "/usr/bin/vim"

          // A fixed name to always give the Zellij session.
          // Consider also setting `attach_to_session true,`
          // otherwise this will error if such a session exists.
          // Default: <RANDOM>
          // 
          // session_name "My singleton session"

          // When `session_name` is provided, attaches to that session
          // if it is already running or creates it otherwise.
          // Default: false
          // 
          // attach_to_session true

          // Toggle between having Zellij lay out panes according to a predefined set of layouts whenever possible
          // Options:
          //   - true (default)
          //   - false
          // 
          // auto_layout false

          // Whether sessions should be serialized to the cache folder (including their tabs/panes, cwds and running commands) so that they can later be resurrected
          // Options:
          //   - true (default)
          //   - false
          // 
          // session_serialization false

          // Whether pane viewports are serialized along with the session, default is false
          // Options:
          //   - true
          //   - false (default)
          // 
          // serialize_pane_viewport false

          // Scrollback lines to serialize along with the pane viewport when serializing sessions, 0
          // defaults to the scrollback size. If this number is higher than the scrollback size, it will
          // also default to the scrollback size. This does nothing if `serialize_pane_viewport` is not true.
          // 
          // scrollback_lines_to_serialize 10000

          // Enable or disable the rendering of styled and colored underlines (undercurl).
          // May need to be disabled for certain unsupported terminals
          // (Requires restart)
          // Default: true
          // 
          // styled_underlines false

          // How often in seconds sessions are serialized
          // 
          // serialization_interval 10000

          // Enable or disable writing of session metadata to disk (if disabled, other sessions might not know
          // metadata info on this session)
          // (Requires restart)
          // Default: false
          // 
          // disable_session_metadata false

          // Enable or disable support for the enhanced Kitty Keyboard Protocol (the host terminal must also support it)
          // (Requires restart)
          // Default: true (if the host terminal supports it)
          // 
          // support_kitty_keyboard_protocol false
          // Whether to make sure a local web server is running when a new Zellij session starts.
          // This web server will allow creating new sessions and attaching to existing ones that have
          // opted in to being shared in the browser.
          // When enabled, navigate to http://127.0.0.1:8082
          // (Requires restart)
          // 
          // Note: a local web server can still be manually started from within a Zellij session or from the CLI.
          // If this is not desired, one can use a version of Zellij compiled without
          // `web_server_capability`
          // 
          // Possible values:
          // - true
          // - false
          // Default: false
          // 
          // web_server false
          // Whether to allow sessions started in the terminal to be shared through a local web server, assuming one is
          // running (see the `web_server` option for more details).
          // (Requires restart)
          // 
          // Note: This is an administrative separation and not intended as a security measure.
          // 
          // Possible values:
          // - "on" (allow web sharing through the local web server if it
          // is online)
          // - "off" (do not allow web sharing unless sessions explicitly opt-in to it)
          // - "disabled" (do not allow web sharing and do not permit sessions started in the terminal to opt-in to it)
          // Default: "off"
          // 
          // web_sharing "off"
          // A path to a certificate file to be used when setting up the web client to serve the
          // connection over HTTPs
          // 
          // web_server_cert "/path/to/cert.pem"
          // A path to a key file to be used when setting up the web client to serve the
          // connection over HTTPs
          // 
          // web_server_key "/path/to/key.pem"
          /// Whether to enforce https connections to the web server when it is bound to localhost
          /// (127.0.0.0/8)
          ///
          /// Note: https is ALWAYS enforced when bound to non-local interfaces
          ///
          /// Default: false
          // 
          // enforce_https_for_localhost false

          // Whether to stack panes when resizing beyond a certain size
          // Default: true
          // 
          // stacked_resize false

          // Whether to show tips on startup
          // Default: true
          // 
          // show_startup_tips false

          // Whether to show release notes on first version run
          // Default: true
          // 
          // show_release_notes false

          // Whether to enable mouse hover effects and pane grouping functionality
          // default is true
          // advanced_mouse_actions false

          // The ip address the web server should listen on when it starts
          // Default: "127.0.0.1"
          // (Requires restart)
          // web_server_ip "127.0.0.1"

          // The port the web server should listen on when it starts
          // Default: 8082
          // (Requires restart)
          // web_server_port 8082

          // A command to run (will be wrapped with sh -c and provided the RESURRECT_COMMAND env variable) 
          // after Zellij attempts to discover a command inside a pane when resurrecting sessions, the STDOUT
          // of this command will be used instead of the discovered RESURRECT_COMMAND
          // can be useful for removing wrappers around commands
          // Note: be sure to escape backslashes and similar characters properly
          // post_command_discovery_hook "echo $RESURRECT_COMMAND | sed <your_regex_here>"
        '';
      };
    };
}
