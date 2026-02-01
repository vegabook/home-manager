local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- map leader 
vim.g.mapleader = ","
vim.g.maplocalleader = ","
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
if vim.fn.has("termguicolors") then
  vim.opt.termguicolors = true
end
-- lazy plugins 
--
local plugins = {
  "EdenEast/nightfox.nvim",
  "foxoman/vim-helix",
  "shaunsingh/moonlight.nvim",
  "nvim-tree/nvim-tree.lua",
  "nyoom-engineering/oxocarbon.nvim",
  "mathofprimes/nightvision-nvim",
  "ribru17/bamboo.nvim",
  "rockerBOO/boo-colorscheme-nvim",
  "mlochbaum/BQN",
	"https://git.sr.ht/~detegr/nvim-bqn",
  "slugbyte/lackluster.nvim",
  "water-sucks/darkrose.nvim",
  "github/copilot.vim",
  {
    "hat0uma/csvview.nvim",
    ---@module "csvview"
    ---@type CsvView.Options
    opts = {
      parser = { comments = { "#", "//" } },
      keymaps = {
        -- Text objects for selecting fields
        textobject_field_inner = { "if", mode = { "o", "x" } },
        textobject_field_outer = { "af", mode = { "o", "x" } },
        -- Excel-like navigation:
        -- Use <Tab> and <S-Tab> to move horizontally between fields.
        -- Use <Enter> and <S-Enter> to move vertically between rows and place the cursor at the end of the field.
        -- Note: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
        jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
        jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
        jump_next_row = { "<Enter>", mode = { "n", "v" } },
        jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
      },
    },
    cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
  },
  {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function () 
        local configs = require("nvim-treesitter.configs")

        configs.setup({
            ensure_installed = { "python", "c", "lua", "vim", "vimdoc", 
              "query", "erlang", "heex", "eex", "elixir", "javascript", "html", "r", "zig"},
            sync_install = false,
            highlight = { 
              enable = true, 
            },
            indent = { 
              enable = true,
            },  
          })
          local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
      ts_update()
      end
  },

  {
    'nvim-telescope/telescope.nvim', branch = '0.1.x',
      dependencies = { 'nvim-lua/plenary.nvim' }
  },

}

-- add bqn filetype
--
vim.filetype.add({
  extension = {
    bqn = "bqn",
  },
})

-- copilot
local opts = {}
local copilot_opts = {}
-- setup secion ------------------------------------------

require("lazy").setup(plugins, opts)

require("nvim-tree").setup({
  actions = {
    open_file = {
        quit_on_open = true,
    },
  },
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 30,
    adaptive_size = true,
  },
  renderer = {
    group_empty = true,
    icons = {
      show = {
        git = false,
        folder = false,
        file = false,
        folder_arrow = false,
      },
    },
  },
  git = {
    enable = true,
  },
  filters = {
    dotfiles = true,
    git_ignored = false,
  },
})


-- Global settings -----------------------
vim.opt.modifiable = true
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.wrap = false
vim.opt.cursorline = true
vim.opt.showmatch = true
vim.opt.termguicolors = true
vim.opt.mouse = 'a'
vim.opt.clipboard = 'unnamedplus'
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.ttimeoutlen = 50

vim.opt.guicursor = {
  "n-v-c:block",
  "i-ci-ve:ver25",
  "r-cr:hor20",
  "o:hor50",
  "a:blinkwait300-blinkoff200-blinkon220-Cursor/lCursor",
  "sm:block-blinkwait175-blinkoff150-blinkon175"
}


vim.g.mapleader = ","


-- Mappings -------------------------

  vim.keymap.set('n', '<Leader>ne', '<cmd>NvimTreeOpen<cr>')
  vim.keymap.set('n', '<Right>', ':tabn<cr>') 
  vim.keymap.set('n', '<Left>', ':tabp<cr>')

  vim.keymap.set('n', '<Leader>cv', function()
    math.randomseed(os.time())
    local schemes = vim.fn.getcompletion('', 'color')
    vim.cmd.colorscheme(schemes[math.random(#schemes)])
  end, { desc = "Random colorscheme now" })

  local builtin = require('telescope.builtin')
  vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
  vim.keymap.set('n', '<leader>fz', builtin.live_grep, {})
  vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
  vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
  vim.keymap.set({'n', 'i'}, '<F1>', '<nop>', {})


  -- Buffer filetype settings

  vim.api.nvim_create_autocmd({"BufEnter", "BufNewFile", "BufRead"}, {
    callback = function()
      local ft = vim.bo.filetype
      local file_ext = vim.fn.expand("%:e")
      local buftype  = vim.bo.buftype

      -- List of filetypes and buftypes to not change colorscheme for
      local ignored_filetypes = {
        ["nvimtree"]       = true,
        ["TelescopePrompt"]= true,
        ["lazy"]           = true,
        ["mason"]          = true,
        ["alpha"]          = true,
        ["dashboard"]      = true,
        ["neo-tree"]       = true,
        ["oil"]            = true,
        ["toggleterm"]     = true,
        ["minifiles"]      = true,
        ["notify"]         = true,
        ["fzf"]            = true,
      }

      local ignored_buftypes = {
        ["nofile"]   = true,
        ["prompt"]   = true,
        ["terminal"] = true,
        ["help"]     = true,
      }

      if ignored_filetypes[ft] or ignored_buftypes[buftype] then
        return  -- skip if filetype shouldn't change colour scheme
      end
      
      if ft == "python" then
        vim.opt_local.shiftwidth = 4
        vim.opt_local.tabstop = 4
        vim.opt.background = "dark"
        vim.cmd.colorscheme("oxocarbon")

      elseif ft == "elixir" then
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
        vim.opt.background = "dark"
        
        if file_ext == "ex" then
          local file_path = vim.fn.expand("%:p:h")
          if file_path:find("/deps/") then
            require("boo-colorscheme").use({
              italic = true,
              theme = "crimson_moonlight",
            })
          else
            require("boo-colorscheme").use({
              italic = true,
              theme = "boo",
            })
          end

        elseif file_ext == "exs" then
          vim.g.nv_contrast = "medium"
          vim.cmd.colorscheme("nightvision")
        end

      elseif ft == "typst" then
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
        vim.cmd.colorscheme("colorful")

      elseif ft == "markdown" then
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
        vim.cmd.colorscheme("twilight")
        vim.opt.background = "light"

      elseif ft == "r" then
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
        vim.opt.background = "dark"
        vim.cmd.colorscheme("3dglasses")

      elseif ft == "json" then
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
        vim.opt.background = "dark"
        vim.cmd.colorscheme("dw_purple")

      elseif ft == "swift" then
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
        vim.opt.background = "dark"
        vim.cmd.colorscheme("blue-mood")

      elseif ft == "zig" then
        vim.opt_local.shiftwidth = 4
        vim.opt_local.tabstop = 4
        vim.opt.background = "dark"
        vim.cmd.colorscheme("darkrose")

      elseif ft == "html" then
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
        vim.opt.background = "dark"
        vim.cmd.colorscheme("atom")

      elseif ft == "bqn" then
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
        vim.opt.background = "dark"
        vim.cmd.colorscheme("golded")

      else
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
        vim.opt.background = "dark"
        vim.cmd.colorscheme("revolutions")

      end

        vim.api.nvim_set_hl(0, "TabLineSel", {
      fg = "#ff0000",          -- bright red foreground
      bg = "#000000",          -- black background
      -- bold = true,          -- remove or comment this if you don't want bold either
      -- No gui= at all → defaults to normal/plain
      -- OR explicitly: gui = "none"  (same effect)
    })

    end,
  })


-- colorscheme per file in first 5 lines
--
local function analyzeBufferContents()
  -- now check for colorscheme or vimcmd in first 5 lines
  local lines = vim.api.nvim_buf_get_lines(0, 0, 5, false)
  -- Example: Check if a specific string exists in the file
  for _, line in ipairs(lines) do
    if line:find("colorscheme") then
      local pattern = "colorscheme ([%w-_]+)"
      local match = string.match(line, pattern)
      -- Perform actions like setting options, calling functions, etc.
      vim.cmd.colorscheme(match)
      if line:find("dark") then
        vim.opt.background = 'dark'
      else
        vim.opt.background = 'light'
      end
  
    -- run arbitrary vim.cmd 
    elseif line:find("vimcmd") then
      -- strip out everything before and including "vimcmd" to extract the command 
      local vcresults = line:match(".*vimcmd (.*)")
      -- can have multiple in same line
      for vcresult in string.gmatch(vcresults, "([^;]+)") do
        vim.cmd(vcresult)
      end
    end
  end

  -- always override colors whatever the colorscheme
  vim.api.nvim_set_hl(0, "TabLineSel", {
    fg = "#dddddd",        
    bg = "#000000",       
  })
  vim.api.nvim_set_hl(0, "TabLine", {
    fg = "#999999",          
    bg = "#333333",         
  })
end

vim.api.nvim_create_autocmd(
  {
      "BufEnter", "BufRead", "BufNewFile"
  },
  {
    callback = analyzeBufferContents
  }





)
