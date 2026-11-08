{
  exo.mods.desktop =
    { pkgs, ... }:
    let
      hyprprop = pkgs.writeShellScriptBin "hyprprop" ''
        #
        # hypr-window-props.sh - click a window and print its Hyprland properties.
        #
        # Usage:
        #   ./hypr-window-props.sh                    # full client object as JSON
        #   ./hypr-window-props.sh '.class, .title'   # apply any jq filter
        #
        # Move the pointer over a window to highlight it, then click. Press Esc to cancel.
        #
        # Requires: hyprctl (Hyprland), slurp, jq. Must run inside the Hyprland session.

        set -euo pipefail

        die() {
          printf 'hypr-window-props: %s\n' "$*" >&2
          exit 1
        }

        if [[ ''${1:-} == -h || ''${1:-} == --help ]]; then
          sed -n '3,11p' "$0" | sed 's/^# \{0,1\}//'
          exit 0
        fi

        for dep in hyprctl slurp jq; do
          command -v "$dep" >/dev/null 2>&1 ||
            die "required command not found: $dep"
        done

        [[ -n ''${WAYLAND_DISPLAY:-} ]] ||
          die 'WAYLAND_DISPLAY is not set; run this inside your Hyprland session'

        clients=$(hyprctl -j clients) || die 'could not read clients from Hyprland'
        monitors=$(hyprctl -j monitors) || die 'could not read monitors from Hyprland'

        # Only consider windows shown on a monitor: the monitor's active workspace
        # or a special workspace that is currently visible.
        shown=$(
          jq --argjson monitors "$monitors" '
            def shown:
              .workspace as $w
              | if $w == null then false
                elif ($w.type // "") == "special" then
                any($monitors[]; .specialWorkspace.name == $w.name)
                else
                any($monitors[]; .activeWorkspace.id == $w.id)
                end;

            [ .[]
              | select(.mapped and (.hidden | not) and (.acceptsInput != false))
              | select(shown)
            ]
          ' <<<"$clients"
        )

        # Give each candidate a numeric label so slurp can tell us which one was
        # clicked without relying on geometry.
        boxes=$(
          jq -r '
            to_entries[]
            | "\(.value.at[0]),\(.value.at[1]) \(.value.size[0])x\(.value.size[1]) \(.key)"
          ' <<<"$shown"
        )

        [[ -n $boxes ]] || die 'no visible windows to select'

        # slurp flags:
        #   -o             also make each output selectable (requested)
        #   -b 00000000    transparent background: no dimming/greying of the screen
        #   -B 00000000    transparent candidate fill: only the hover border is drawn
        #   -c ffffffcc    hover border colour
        #   -w 2           hover border width
        if ! selection=$(
          printf '%s\n' "$boxes" |
            slurp -o \
              -b '#dddddd22' \
              -B '#00000000' \
              -c '#ff9933cc' \
              -w 2 \
              -f '%x %y %w %h %l' 2>/dev/null
        ); then
          exit 1 # selection cancelled (Esc)
        fi

        read -r sx sy sw sh label <<<"$selection"

        [[ $sx =~ ^-?[0-9]+$ && $sy =~ ^-?[0-9]+$ &&
          $sw =~ ^[0-9]+$ && $sh =~ ^[0-9]+$ ]] ||
          die "could not parse slurp output: ''${selection:-<empty>}"

        if [[ $label =~ ^[0-9]+$ ]]; then
          client=$(jq --argjson i "$label" '.[$i] // empty' <<<"$shown")
        else
          # An output rectangle (label is a monitor name) or a dragged selection.
          # Fall back to an exact geometry match, which also covers a fullscreen
          # window whose rectangle equals the monitor's.
          client=$(
            jq --argjson x "$sx" --argjson y "$sy" \
              --argjson w "$sw" --argjson h "$sh" '
              [ .[]
                | select(.at[0] == $x and .at[1] == $y
                        and .size[0] == $w and .size[1] == $h)
              ]
              | sort_by(.focusHistoryID // 999999)
              | first // empty
            ' <<<"$shown"
          )
        fi

        [[ -n $client ]] || die 'no window selected'

        if (($#)); then
          jq "$@" <<<"$client"
        else
          jq . <<<"$client"
        fi
      '';
    in
    {
      hj.packages = [ hyprprop ];
    };
}
