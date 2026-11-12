top: {
  tack.inputs.nixvim = {
    url = "gh:nix-community/nixvim";
    group = "tui";
  };

  modules.core =
    {
      inputs,
      config,
      scheme,
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.my.nixvim;

      nvimFindScript =
        pkgs.writeText "nvim-find.lua" # lua
          ''
            local target = vim.uv.fs_realpath(arg[1]) or vim.fn.fnamemodify(arg[1], ":p")
            local line = tonumber(arg[2]) or 0
            local pos = line > 0 and { line, 0 } or nil

            for _, socket in ipairs(vim.fn.serverlist({ peer = true })) do
              if socket ~= vim.v.servername then
                local ok, chan = pcall(vim.fn.sockconnect, "pipe", socket, { rpc = true })
                if ok and chan > 0 then
                  local req_ok, result = pcall(
                    vim.rpcrequest, chan, "nvim_exec_lua",
                    "return _G.nvim_focus_file(...)", { target, pos }
                  )
                  pcall(vim.fn.chanclose, chan)
                  if req_ok and type(result) == "table" and result.found and result.kitty_id then
                    io.write(result.kitty_id)
                    os.exit(0)
                  end
                end
              end
            end
            os.exit(1)
          '';

      nvimFocus = pkgs.writeShellApplication {
        name = "nvim-focus";
        runtimeInputs = [ config.my.kitty.package ];
        text = ''
          file=""
          line=0
          for arg in "$@"; do
            case $arg in
              +[0-9]*) line=''${arg#+} ;;
              -*) ;;
              *) file=$arg ;;
            esac
          done

          if [ -n "$file" ] && [ -f "$file" ]; then
            id=$(${lib.getExe cfg.package} -l ${nvimFindScript} "$file" "$line" 2>/dev/null) || id=""
            if [ -n "$id" ] && kitty @ focus-window -m "id:$id" >/dev/null 2>&1; then
              exit 0
            fi
          fi

          exec ${lib.getExe cfg.package} "$@"
        '';
      };
    in
    {
      config = lib.mkIf cfg.enable {
        hj.packages = [
          cfg.package
          nvimFocus
        ];

        my.kitty.settings = {
          allow_remote_control = "password";
          # Passwordless requests may only focus a window.
          remote_control_password = "\"\" focus-window";
          listen_on = "unix:/tmp/kitty-\${kitty_pid}";
        };

        my.lazygit.settings = {
          os =
            let
              lazygitEdit = pkgs.writeShellApplication {
                name = "lazygit-edit";
                runtimeInputs = [ pkgs.coreutils ];
                text = ''
                  file=$(realpath -m -- "$1")
                  line=''${2:-0}

                  if [ -n "''${NVIM:-}" ]; then
                    ${lib.getExe cfg.package} --server "$NVIM" --remote-send '<C-\><C-n><cmd>close<cr>'
                    ${lib.getExe cfg.package} --server "$NVIM" --remote-expr "v:lua.LazygitEdit([==[$file]==], $line)" >/dev/null
                  elif [ "$line" -gt 0 ]; then
                    exec nvim-focus "+$line" "$file"
                  else
                    exec nvim-focus "$file"
                  fi
                '';
              };
            in
            {
              editInTerminal = true;
              edit = "${lib.getExe lazygitEdit} {{filename}}";
              editAtLine = "${lib.getExe lazygitEdit} {{filename}} {{line}}";
            };
        };

        environment.variables = {
          EDITOR = "nvim-focus";
          VISUAL = "nvim-focus";
          MANPAGER = "nvim +Man!";
        };

        hj.xdg.mime-apps.default-applications = {
          "text/*" = [ "nvim.desktop" ];
        };

        my.xdg.desktopEntries = {
          nvim = {
            noDisplay = true;
            exec = "nvim %F";
            terminal = true;
            type = "Application";
            startupNotify = false;
            mimeType = [
              "text/english"
              "text/plain"
              "text/x-makefile"
              "text/x-c++hdr"
              "text/x-c++src"
              "text/x-chdr"
              "text/x-csrc"
              "text/x-java"
              "text/x-moc"
              "text/x-pascal"
              "text/x-tcl"
              "text/x-tex"
              "application/x-shellscript"
              "text/x-c"
              "text/x-c++"
            ];
            settings = {
              TryExec = "nvim";
            };
          };
        };
      };

      options.my.nixvim = {
        enable = lib.mkEnableOption { } // {
          default = true;
        };

        package = lib.mkOption {
          default =
            let
              nixvim = inputs.nixvim.lib.evalNixvim {
                extraSpecialArgs = {
                  inherit scheme inputs pkgs;

                  dependencies = lib.genAttrs [ "yazi" "lazygit" ] (pkg: {
                    package = config.my.${pkg}.package;
                  });
                };
                modules = [
                  top.config.modules.features.neovim
                  (
                    { dependencies, pkgs, ... }:
                    {
                      inherit dependencies;
                      nixpkgs = { inherit pkgs; };
                      enableMan = false;
                      luaLoader.enable = false;
                      performance.byteCompileLua = {
                        enable = true;
                        plugins = true;
                        nvimRuntime = true;
                      };
                    }
                  )
                ];
              };
            in
            nixvim.config.build.package;
        };
      };
    };
}
