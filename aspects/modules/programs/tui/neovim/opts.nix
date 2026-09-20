{
  exo.mods.neovim =
    { lib, ... }:
    let
      inherit (lib.nixvim) mkRaw;
    in
    {
      opts = {
        # Search down into subfolders
        path = mkRaw "vim.o.path .. '**'";

        number = true;
        relativenumber = true;
        cursorline = true; # Enable highlighting of the current line
        showmatch = true; # Highlight matching parentheses, etc
        incsearch = true;
        hlsearch = true;

        spell = false;
        spelllang = "en";

        expandtab = true;

        fillchars = "foldopen:,foldclose:,diff:╱,fold: ,foldsep: ,eob: ";

        tabstop = 2;
        softtabstop = 2;
        shiftwidth = 2; # Size of an indent
        shiftround = true; # Round indent

        foldenable = true;
        foldlevel = 99;

        history = 2000;
        nrformats = "bin,hex";
        undofile = true;
        splitright = true;
        splitbelow = true;
        cmdheight = 0;

        clipboard = mkRaw "vim.env.SSH_CONNECTION and '' or 'unnamedplus'"; # Sync with system clipboard
        completeopt = [
          "menu"
          "menuone"
          "noselect"
        ];

        conceallevel = 2; # Hide * markup for bold and italic, but not markers with substitutions
        confirm = true; # Confirm to save changes before exiting modified buffer

        autowrite = true;
        formatoptions = "jcroqlnt"; # tcqj

        grepformat = "%f:%l:%c:%m";
        grepprg = "rg --vimgrep";

        ignorecase = true; # Ignore case
        inccommand = "nosplit"; # preview incremental substitute
        jumpoptions = "view";
        laststatus = 3; # global statusline
        list = true; # Show some invisible characters (tabs...

        pumheight = 10; # Maximum number of entries in a popup

        ruler = false; # Disable the default ruler
        scrolloff = 10;
        sessionoptions = "buffers,curdir,tabpages,winsize,help,globals,skiprtp,folds";

        shortmess = "ltToOCFWIcC";
        showmode = false; # Dont show mode since we have a statusline
        sidescrolloff = 8; # Columns of context
        signcolumn = "yes"; # Always show the signcolumn, otherwise it would shift the text each time

        smartcase = true; # Don't ignore case with capitals
        smartindent = true; # Insert indents automatically

        termguicolors = true; # True color support
        timeoutlen = mkRaw "vim.g.vscode and 1000 or 300"; # Lower than default (1000) to quickly trigger which-key
        undolevels = 10000;
        updatetime = 200; # Save swap file and trigger CursorHold
        wildmode = "longest:full,full"; # Command-line completion mode
        winminwidth = 5; # Minimum window width
        winborder = "single";
        mousemodel = "extend";
        virtualedit = "block";
        wrap = false;
        linebreak = true;
        breakindent = true;
        breakindentopt = "sbr,shift:5";
        mousescroll = "ver:1,hor:0";
        showbreak = "   󱞵 ";

        smoothscroll = true;

        cpoptions = "aABceFs_n";
      };

      _file = ./opts.nix;
    };
}
