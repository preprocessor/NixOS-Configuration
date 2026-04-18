{

  flake.modules.nixos.default =
    { pkgs, ... }:
    let
      tomlFormat = pkgs.formats.toml { };
    in
    {
      hj.packages = [ pkgs.lla ];

      hj.xdg.config.files."lla/config.toml".source = tomlFormat.generate "lla-config" {
        default_sort = "name";
        default_format = "grid";

        show_icons = true;
        include_dirs = false;
        permission_format = "octal";

        # Place custom themes in ~/.config/lla/themes/
        # Default: "default"
        theme = "default";

        # List of enabled plugins
        # Each plugin provides additional functionality
        # Examples:
        #   - "git_status": Show Git repository information
        #   - "file_hash": Calculate and display file hashes
        #   - "file_tagger": Add and manage file tags
        enabled_plugins = [ ];

        # Directory where plugins are stored
        # Default: ~/.config/lla/plugins
        plugins_dir = "~/.config/lla/plugins";

        # Paths to exclude from listings (tilde is supported)
        # Examples:
        #   - "~/Library/Mobile Documents"  # macOS iCloud Drive (Mobile Documents)
        #   - "~/Library/CloudStorage"      # macOS cloud storage providers
        # Default: [] (no exclusions)
        exclude_paths = [ ];

        # Maximum depth for recursive directory traversal
        # Controls how deep lla will go when showing directory contents
        # Set to None for unlimited depth (may impact performance)
        # Default: 3 levels deep
        default_depth = 3;

        # Sorting configuration
        sort = {
          # List directories before files
          # Default: false
          dirs_first = true;

          # Enable case-sensitive sorting
          # Default: false
          case_sensitive = false;

          # Use natural sorting for numbers (e.g., 2.txt before 10.txt)
          # Default: true
          natural = true;
        };

        # Filtering configuration
        filter = {
          # Enable case-sensitive filtering by default
          # Default: false
          case_sensitive = false;

          # Hide dot files and directories by default
          # Default: false
          no_dotfiles = true;

          # Respect .gitignore (and git exclude) rules when listing files
          # Default: false
          respect_gitignore = true;
        };

        # Formatter-specific configurations
        formatters.tree.max_lines = 20000;
        # Grid formatter configuration
        formatters.grid = {
          # Whether to ignore terminal width by default
          # When true, grid view will use max_width instead of terminal width
          # Default: false
          ignore_width = false;
          max_width = 200;
        };

        # Long formatter configuration
        formatters.long = {
          hide_group = false;
          relative_dates = true;
          columns = [
            "permissions"
            "size"
            "modified"
            "user"
            "group"
            "name"
          ];
        };

        formatters.table.columns = [
          "name"
          "size"
          "modified"
          "permissions"
        ];

        listers.recursive.max_entries = 20000;

        listers.fuzzy = {
          # Patterns to ignore when listing files in fuzzy mode
          # Can be:
          #  - Simple substring match: "node_modules"
          #  - Glob pattern: "glob:*.min.js"
          #  - Regular expression: "regex:.*\\.pyc$"
          ignore_patterns = [
            "result"
            "node_modules"
            "target"
            ".git"
            ".idea"
            ".vscode"
          ];

          editor = "";
        };
      };

    };
}
