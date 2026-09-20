{
  exo.mods.neovim =
    { lib, ... }:
    let
      inherit (lib.nixvim) mkRaw;

      root_patterns = ''
        {
          -- directories
          'client',
          'server',

          -- version control systems
          '_darcs',
          '.hg',
          '.bzr',
          '.svn',
          '.git',

          -- build tools
          'Makefile',
          'CMakeLists.txt',
          'build.gradle',
          'build.gradle.kts',
          'pom.xml',
          'build.xml',

          -- node.js and javascript
          'package.json',
          'package-lock.json',
          'yarn.lock',
          '.nvmrc',
          'gulpfile.js',
          'Gruntfile.js',

          -- python
          'requirements.txt',
          'Pipfile',
          'pyproject.toml',
          'setup.py',
          'tox.ini',

          -- rust
          'Cargo.toml',

          -- go
          'go.mod',

          -- elixir
          'mix.exs',

          -- configuration files
          '.prettierrc',
          '.prettierrc.json',
          '.prettierrc.yaml',
          '.prettierrc.yml',
          '.eslintrc',
          '.eslintrc.json',
          '.eslintrc.js',
          '.eslintrc.cjs',
          '.eslintignore',
          '.stylelintrc',
          '.stylelintrc.json',
          '.stylelintrc.yaml',
          '.stylelintrc.yml',
          '.editorconfig',
          '.gitignore',

          -- html projects
          'index.html',

          -- miscellaneous
          'README.md',
          'README.rst',
          'LICENSE',
          'Vagrantfile',
          'Procfile',
          '.env',
          '.env.example',
          'config.yaml',
          'config.yml',
          '.terraform',
          'terraform.tfstate',
          '.kitchen.yml',
          'Berksfile',
        }
      '';
    in
    {
      keymaps = [
        {
          key = "<leader>bd";
          action = mkRaw ''
            function()
              Snacks.bufdelete()
            end
          '';
          options = {
            desc = "Delete Buffer";
          };
        }
        {
          key = "<leader>bo";
          action = mkRaw ''
            function()
              Snacks.bufdelete.other()
            end
          '';
          options = {
            desc = "Delete Other Buffers";
          };
        }

        # Scratch buffers
        {
          key = "<leader>.";
          action = mkRaw ''
            function()
              Snacks.scratch()
            end
          '';
          options = {
            desc = "Toggle Scratch Buffer";
          };
        }
        {
          key = "<leader>S";
          action = mkRaw ''
            function()
              Snacks.scratch.select()
            end
          '';
          options = {
            desc = "Select Scratch Buffer";
          };
        }
        {
          key = "<leader>dps";
          action = mkRaw ''
            function()
              Snacks.profiler.scratch()
            end
          '';
          options = {
            desc = "Profiler Scratch Buffer";
          };
        }

        {
          key = "<leader>,";
          action = mkRaw ''
            function()
              Snacks.picker.buffers()
            end
          '';
          options = {
            desc = "Buffers";
          };
        }

        {
          key = "<leader>/";
          action = mkRaw ''
            function()
              local root_dir = vim.fs.dirname(vim.fs.find(${root_patterns}, { upward = true })[1]) or vim.fn.getcwd()
              Snacks.picker.grep { cwd = root_dir }
            end
          '';
          options = {
            desc = "Grep (Root Dir)";
          };
        }

        {
          key = "<leader><space>";
          action = mkRaw ''
            function()
              local root_dir = vim.fs.dirname(vim.fs.find(${root_patterns}, { upward = true })[1]) or vim.fn.getcwd()
              Snacks.picker.files { cwd = root_dir }
            end
          '';
          options = {
            desc = "Find Files (Root Dir)";
          };
        }

        {
          key = "<leader>:";
          action = mkRaw ''
            function()
              Snacks.picker.command_history()
            end
          '';
          options = {
            desc = "Command History";
          };
        }

        {
          key = "<leader>n";
          action = mkRaw ''
            function()
              Snacks.picker.notifications()
            end
          '';
          options = {
            desc = "Notification History";
          };
        }
        {
          key = "<leader>un";
          action = mkRaw ''
            function()
              Snacks.notifier.hide()
            end
          '';
          options = {
            desc = "Dismiss All Notifications";
          };
        }

        # find
        {
          key = "<leader>fB";
          action = mkRaw ''
            function()
              Snacks.picker.buffers { hidden = true, nofile = true }
            end
          '';
          options = {
            desc = "Buffers (all)";
          };
        }
        {
          key = "<leader>fc";
          action = mkRaw ''
            function()
              Snacks.picker.files { cwd = vim.fn.stdpath('config') }
            end
          '';
          options = {
            desc = "Find Config File";
          };
        }
        {
          key = "<leader>ff";
          action = mkRaw ''
            function()
              Snacks.picker.files()
            end
          '';
          options = {
            desc = "Find Files";
          };
        }
        {
          key = "<leader>fs";
          action = mkRaw ''
            function()
              Snacks.picker.smart()
            end
          '';
          options = {
            desc = "Find Files (Smart)";
          };
        }
        {
          key = "<leader>fg";
          action = mkRaw ''
            function()
              Snacks.picker.git_files()
            end
          '';
          options = {
            desc = "Find Files (git-files)";
          };
        }
        {
          key = "<leader>fr";
          action = mkRaw ''
            function()
              Snacks.picker.recent()
            end
          '';
          options = {
            desc = "Recent";
          };
        }
        {
          key = "<leader>fR";
          action = mkRaw ''
            function()
              Snacks.picker.recent { filter = { cwd = true } }
            end
          '';
          options = {
            desc = "Recent (cwd)";
          };
        }
        {
          key = "<leader>fp";
          action = mkRaw ''
            function()
              Snacks.picker.projects()
            end
          '';
          options = {
            desc = "Projects";
          };
        }

        # git
        {
          key = "<leader>gd";
          action = mkRaw ''
            function()
              Snacks.picker.git_diff()
            end
          '';
          options = {
            desc = "Git Diff (hunks)";
          };
        }
        {
          key = "<leader>gD";
          action = mkRaw ''
            function()
              Snacks.picker.git_diff { base = 'origin', group = true }
            end
          '';
          options = {
            desc = "Git Diff (origin)";
          };
        }
        {
          key = "<leader>gs";
          action = mkRaw ''
            function()
              Snacks.picker.git_status()
            end
          '';
          options = {
            desc = "Git Status";
          };
        }
        {
          key = "<leader>gS";
          action = mkRaw ''
            function()
              Snacks.picker.git_stash()
            end
          '';
          options = {
            desc = "Git Stash";
          };
        }
        {
          key = "<leader>gi";
          action = mkRaw ''
            function()
              Snacks.picker.gh_issue()
            end
          '';
          options = {
            desc = "GitHub Issues (open)";
          };
        }
        {
          key = "<leader>gI";
          action = mkRaw ''
            function()
              Snacks.picker.gh_issue { state = 'all' }
            end
          '';
          options = {
            desc = "GitHub Issues (all)";
          };
        }
        {
          key = "<leader>gp";
          action = mkRaw ''
            function()
              Snacks.picker.gh_pr()
            end
          '';
          options = {
            desc = "GitHub Pull Requests (open)";
          };
        }
        {
          key = "<leader>gP";
          action = mkRaw ''
            function()
              Snacks.picker.gh_pr { state = 'all' }
            end
          '';
          options = {
            desc = "GitHub Pull Requests (all)";
          };
        }

        # Grep
        {
          key = "<leader>sb";
          action = mkRaw ''
            function()
              Snacks.picker.lines()
            end
          '';
          options = {
            desc = "Buffer Lines";
          };
        }
        {
          key = "<leader>sB";
          action = mkRaw ''
            function()
              Snacks.picker.grep_buffers()
            end
          '';
          options = {
            desc = "Grep Open Buffers";
          };
        }
        {
          key = "<leader>sg";
          action = mkRaw ''
            function()
              Snacks.picker.grep()
            end
          '';
          options = {
            desc = "Grep";
          };
        }
        {
          key = "<leader>sp";
          action = mkRaw ''
            function()
              Snacks.picker.lazy()
            end
          '';
          options = {
            desc = "Search for Plugin Spec";
          };
        }
        {
          mode = [
            "n"
            "x"
          ];
          key = "<leader>sw";
          action = mkRaw ''
            function()
              Snacks.picker.grep_word()
            end
          '';
          options = {
            desc = "Visual selection or word";
          };
        }

        # search
        {
          key = "<leader>s\"";
          action = mkRaw ''
            function()
              Snacks.picker.registers()
            end
          '';
          options = {
            desc = "Registers";
          };
        }
        {
          key = "<leader>s/";
          action = mkRaw ''
            function()
              Snacks.picker.search_history()
            end
          '';
          options = {
            desc = "Search History";
          };
        }
        {
          key = "<leader>sa";
          action = mkRaw ''
            function()
              Snacks.picker.autocmds()
            end
          '';
          options = {
            desc = "Autocmds";
          };
        }
        {
          key = "<leader>sc";
          action = mkRaw ''
            function()
              Snacks.picker.command_history()
            end
          '';
          options = {
            desc = "Command History";
          };
        }
        {
          key = "<leader>sC";
          action = mkRaw ''
            function()
              Snacks.picker.commands()
            end
          '';
          options = {
            desc = "Commands";
          };
        }
        {
          key = "<leader>sd";
          action = mkRaw ''
            function()
              Snacks.picker.diagnostics()
            end
          '';
          options = {
            desc = "Diagnostics";
          };
        }
        {
          key = "<leader>sD";
          action = mkRaw ''
            function()
              Snacks.picker.diagnostics_buffer()
            end
          '';
          options = {
            desc = "Buffer Diagnostics";
          };
        }
        {
          key = "<leader>sh";
          action = mkRaw ''
            function()
              Snacks.picker.help()
            end
          '';
          options = {
            desc = "Help Pages";
          };
        }
        {
          key = "<leader>sH";
          action = mkRaw ''
            function()
              Snacks.picker.highlights()
            end
          '';
          options = {
            desc = "Highlights";
          };
        }
        {
          key = "<leader>si";
          action = mkRaw ''
            function()
              Snacks.picker.icons()
            end
          '';
          options = {
            desc = "Icons";
          };
        }
        {
          key = "<leader>sj";
          action = mkRaw ''
            function()
              Snacks.picker.jumps()
            end
          '';
          options = {
            desc = "Jumps";
          };
        }
        {
          key = "<leader>sk";
          action = mkRaw ''
            function()
              Snacks.picker.keymaps()
            end
          '';
          options = {
            desc = "Keymaps";
          };
        }
        {
          key = "<leader>sl";
          action = mkRaw ''
            function()
              Snacks.picker.loclist()
            end
          '';
          options = {
            desc = "Location List";
          };
        }
        {
          key = "<leader>sM";
          action = mkRaw ''
            function()
              Snacks.picker.man()
            end
          '';
          options = {
            desc = "Man Pages";
          };
        }
        {
          key = "<leader>sm";
          action = mkRaw ''
            function()
              Snacks.picker.marks()
            end
          '';
          options = {
            desc = "Marks";
          };
        }
        {
          key = "<leader>sR";
          action = mkRaw ''
            function()
              Snacks.picker.resume()
            end
          '';
          options = {
            desc = "Resume";
          };
        }
        {
          key = "<leader>sq";
          action = mkRaw ''
            function()
              Snacks.picker.qflist()
            end
          '';
          options = {
            desc = "Quickfix List";
          };
        }
        {
          key = "<leader>su";
          action = mkRaw ''
            function()
              Snacks.picker.undo()
            end
          '';
          options = {
            desc = "Undotree";
          };
        }

        # ui
        {
          key = "<leader>uC";
          action = mkRaw ''
            function()
              Snacks.picker.colorschemes()
            end
          '';
          options = {
            desc = "Colorschemes";
          };
        }
        {
          key = "<leader>st";
          action = mkRaw ''
            function()
              Snacks.picker.todo_comments()
            end
          '';
          options = {
            desc = "Todo";
          };
        }
        {
          key = "<leader>sT";
          action = mkRaw ''
            function()
              Snacks.picker.todo_comments { keywords = { 'TODO', 'FIX', 'FIXME' } }
            end
          '';
          options = {
            desc = "Todo/Fix/Fixme";
          };
        }

        # lazygit (only mapped when lazygit is executable, in the original Lua;
        # a conditional key isn't representable directly in this attrset list,
        # so this entry is kept as-is -- gate it in your Nix config if needed)
        {
          key = "<leader>gg";
          action = mkRaw ''
            function()
              Snacks.lazygit()
            end
          '';
          options = {
            desc = "Lazygit (cwd)";
          };
        }

        {
          key = "<leader>gL";
          action = mkRaw ''
            function()
              Snacks.picker.git_log()
            end
          '';
          options = {
            desc = "Git Log (cwd)";
          };
        }
        {
          key = "<leader>gb";
          action = mkRaw ''
            function()
              Snacks.picker.git_log_line()
            end
          '';
          options = {
            desc = "Git Blame Line";
          };
        }
        {
          key = "<leader>gf";
          action = mkRaw ''
            function()
              Snacks.picker.git_log_file()
            end
          '';
          options = {
            desc = "Git Current File History";
          };
        }
        {
          mode = [
            "n"
            "x"
          ];
          key = "<leader>gB";
          action = mkRaw ''
            function()
              Snacks.gitbrowse()
            end
          '';
          options = {
            desc = "Git Browse (open)";
          };
        }
        {
          mode = [
            "n"
            "x"
          ];
          key = "<leader>gY";
          action = mkRaw ''
            function()
              Snacks.gitbrowse {
                open = function(url)
                  vim.fn.setreg('+', url)
                end,
                notify = false,
              }
            end
          '';
          options = {
            desc = "Git Browse (copy)";
          };
        }

        # debug
        {
          mode = [
            "n"
            "x"
          ];
          key = "<localleader>r";
          action = mkRaw ''
            function()
              Snacks.debug.run()
            end
          '';
          options = {
            desc = "Run Lua";
          };
        }
      ];

      extraConfigLua = /* lua */ ''
        Snacks.toggle.option('spell', { name = 'Spelling' }):map('<leader>us')
        Snacks.toggle.option('wrap', { name = 'Wrap' }):map('<leader>uw')
        Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map('<leader>uL')
        Snacks.toggle.diagnostics():map('<leader>ud')
        Snacks.toggle.line_number():map('<leader>ul')
        Snacks.toggle
          .option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = 'Conceal Level' })
          :map('<leader>uc')
        Snacks.toggle.dim():map('<leader>uD')
        Snacks.toggle.treesitter():map('<leader>uT')
        -- Snacks.toggle.animate():map('<leader>ua')
        -- Snacks.toggle.indent():map('<leader>ug')
        -- Snacks.toggle.scroll():map('<leader>uS')
        Snacks.toggle.profiler():map('<leader>dpp')
        Snacks.toggle.profiler_highlights():map('<leader>dph')

        if vim.lsp.inlay_hint then
          Snacks.toggle.inlay_hints():map('<leader>uh')
        end

        Snacks.toggle.zoom():map('<leader>wm'):map('<leader>uZ')
        Snacks.toggle.zen():map('<leader>uz')

        -- gitsigns
        Snacks.toggle({
          name = 'Git Signs',
          get = function()
            return require('gitsigns.config').config.signcolumn
          end,
          set = function(state)
            require('gitsigns').toggle_signs(state)
          end,
        }):map('<leader>uG')
      '';
    };
}
