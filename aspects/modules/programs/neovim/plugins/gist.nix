{
  tack.inputs.gist-nvim = {
    url = "gh:rawnly/gist.nvim";
    type = "fetch";
  };

  modules.features.neovim =
    {
      pkgs,
      lib,
      config,
      inputs,
      ...
    }:
    let
      cfg = config.plugins.gh-gist;
    in
    {
      options.plugins.gh-gist = {
        enable = lib.mkEnableOption "gist.nvim";
        descriptionPrompt = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Prompt for a Gist description with Snacks input.";
        };
        inputbox = lib.mkOption {
          type = lib.types.enum [
            "top"
            "center"
            "bottom"
          ];
          default = "center";
          description = "Where to place the Snacks input box.";
        };
        inputboxMargin = lib.mkOption {
          type = lib.types.int;
          default = 2;
          apply = toString;
          description = "Distance from the top or bottom edge for the Snacks input box.";
        };
        settings = lib.mkOption {
          type = lib.types.attrsOf lib.types.anything;
          default = { };
          description = "Table passed to require('gist').setup";
        };
      };

      config = lib.mkMerge [
        {
          plugins.gh-gist = {
            enable = true;
            descriptionPrompt = true;
            inputbox = "center"; # "top" | "center" | "bottom"
            inputboxMargin = 2;
            settings = {
              platform = "github";
              clipboard = "+";

              platforms.github = {
                private = true;
                prompts.create.description = config.plugins.gh-gist.enable;
              };
            };
          };
          keymaps = [
            {
              mode = "n";
              key = "<leader>gc";
              action = "<cmd>lua _G.gh_gist_create()<cr>";
              options = {
                desc = "Create Gist";
                silent = true;
                noremap = true;
              };
            }
            {
              mode = "v";
              key = "<leader>gc";
              action = "<cmd>lua _G.gh_gist_create(true)<cr>";
              options = {
                desc = "Create Gist from selection";
                silent = true;
                noremap = true;
              };
            }
            {
              mode = "n";
              key = "<leader>gl";
              action = "<cmd>GistsList<cr>";
              options = {
                desc = "List Gists";
                silent = true;
                noremap = true;
              };
            }
          ];
        }

        (lib.mkIf cfg.enable {
          extraPlugins = [
            (pkgs.vimUtils.buildVimPlugin {
              pname = "gist.nvim";
              version = inputs._meta.gist-nvim.rev;
              src = inputs.gist-nvim;
            })
          ];

          extraConfigLua = # lua
            ''
              require("gist").setup(${lib.nixvim.toLuaObject cfg.settings})

              local description_prompt = ${lib.boolToString cfg.descriptionPrompt}
              local inputbox_position = "${cfg.inputbox}"
              local inputbox_margin = ${cfg.inputboxMargin}

              local function gist_suffix()
                return vim.bo.filetype ~= "" and ("." .. vim.bo.filetype) or ""
              end

              local function visual_range()
                local first, last = vim.fn.line("v"), vim.fn.line(".")
                return math.min(first, last) .. "," .. math.max(first, last)
              end

              local function input_row(self)
                local border = self:border_size()
                local height = (self.opts.height or 1) + border.top + border.bottom

                if inputbox_position == "top" then
                  return inputbox_margin
                end

                if inputbox_position == "bottom" then
                  return math.max(
                    inputbox_margin,
                    vim.o.lines - vim.o.cmdheight - height - inputbox_margin
                  )
                end

                return math.floor((vim.o.lines - height) / 2)
              end

              local function with_suffix(name, suffix)
                if suffix == "" or name:sub(-#suffix):lower() == suffix:lower() then
                  return name
                end

                if name:sub(2):find("%.", 1) then
                  return name
                end

                return name .. suffix
              end

              local function escape(value)
                return (value:gsub("\\", "\\\\"):gsub('"', '\\"'))
              end

              local function submit_gist(name, description, suffix, range)
                name = escape(with_suffix(name, suffix))

                local args = string.format('filename="%s"', name)
                if description ~= nil then
                  args = args .. string.format(' description="%s"', escape(description))
                end

                vim.cmd((range and range .. " " or "") .. "GistCreate " .. args)
              end

              local function focus_input(win)
                vim.schedule(function()
                  if win and win:valid() then
                    vim.api.nvim_win_set_cursor(win.win, { 1, 0 })
                    vim.cmd("startinsert")
                  end
                end)
              end

              local function prompt_description(name, suffix, range)
                local win = Snacks.input({
                  prompt = "Gist description",
                  default = "",
                  win = { row = input_row },
                }, function(value)
                  if not value then
                    return
                  end

                  submit_gist(name, vim.trim(value), suffix, range)
                end)

                focus_input(win)
              end

              _G.gh_gist_create = function(visual)
                local suffix = gist_suffix()
                local range = visual and visual_range() or nil

                local win = Snacks.input({
                  prompt = "Gist name",
                  default = suffix,
                  win = { row = input_row },
                }, function(value)
                  if not value then
                    return
                  end

                  local name = vim.trim(value):gsub("[\r\n]", " ")
                  if name == "" or name == suffix then
                    return
                  end

                  if description_prompt then
                    prompt_description(name, suffix, range)
                  else
                    submit_gist(name, "", suffix, range)
                  end
                end)

                focus_input(win)
              end
            '';
        })
      ];
    };
}
