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
local plugins = {
  'EdenEast/nightfox.nvim',
--  'rockerBOO/boo-colorscheme-nvim',
  'foxoman/vim-helix',
  'shaunsingh/moonlight.nvim',
  'nvim-tree/nvim-tree.lua',
  'nvim-tree/nvim-web-devicons',
  'nyoom-engineering/oxocarbon.nvim',
  'mathofprimes/nightvision-nvim',
  'ribru17/bamboo.nvim',
  'rockerBOO/boo-colorscheme-nvim',
  'mlochbaum/BQN',
  {
    'cameron-wags/rainbow_csv.nvim',
    config = true,
    ft = {
        'csv',
        'tsv',
        'csv_semicolon',
        'csv_whitespace',
        'csv_pipe',
        'rfc_csv',
        'rfc_semicolon'
    },
    cmd = {
        'RainbowDelim',
        'RainbowDelimSimple',
        'RainbowDelimQuoted',
        'RainbowMultiDelim'
    }
  },
  {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function () 
        local configs = require("nvim-treesitter.configs")

        configs.setup({
            ensure_installed = { "python", "c", "lua", "vim", "vimdoc", "query", "elixir", "erlang", "heex", "javascript", "html" },
            sync_install = false,
            highlight = { enable = true },
            indent = { enable = true },  
          })
      end
  },
  {
    "https://git.sr.ht/~swaits/zellij-nav.nvim",
    lazy = true,
    event = "VeryLazy",
    keys = {
      { "<c-h>", "<cmd>ZellijNavigateLeft<cr>",  { silent = true, desc = "navigate left"  } },
      { "<c-j>", "<cmd>ZellijNavigateDown<cr>",  { silent = true, desc = "navigate down"  } },
      { "<c-k>", "<cmd>ZellijNavigateUp<cr>",    { silent = true, desc = "navigate up"    } },
      { "<c-l>", "<cmd>ZellijNavigateRight<cr>", { silent = true, desc = "navigate right" } },
    },
    opts = {},
  },
  'hrsh7th/nvim-cmp',
  'github/copilot.vim',
  {
    'nvim-telescope/telescope.nvim', branch = '0.1.x',
      dependencies = { 'nvim-lua/plenary.nvim' }
  }
}

local opts = {}
local copilot_opts = {}

-- setup
--
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
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})

-- Global settings
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

vim.g.mapleader = ","


-- Mappings

vim.keymap.set('n', '<Leader>ne', '<cmd>NvimTreeOpen<cr>')
vim.keymap.set('n', '<Right>', ':tabn<cr>')
vim.keymap.set('n', '<Left>', ':tabp<cr>')


local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fz', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})


-- Buffer autocmds

vim.api.nvim_create_autocmd(
  {
      "BufEnter", "BufRead",
  },
  {
    pattern = "*.py",
    callback = function()
      vim.opt.shiftwidth = 4
      vim.opt.tabstop = 4
      vim.opt.background = 'dark'
      vim.cmd.colorscheme('oxocarbon')
    end
  }
)

vim.api.nvim_create_autocmd(
  {
      "BufEnter", "BufRead",
  },
  {
    pattern = "*.exs",
    callback = function()
      vim.opt.shiftwidth = 2
      vim.opt.tabstop = 2
      vim.opt.background = 'dark'
      vim.g.nv_contrast = 'medium'
      vim.cmd.colorscheme('nightvision')

    end
  }
)

 vim.api.nvim_create_autocmd(
  {
      "BufEnter", "BufRead",
  },
  {
    pattern = "*.ex",
    callback = function()
      vim.opt.shiftwidth = 2
      vim.opt.tabstop = 2
      vim.opt.background = 'dark'
      require("boo-colorscheme").use({
	italic = true, -- toggle italics
	theme = "boo"
      })
    end
  }
)

-- colorscheme per file in first 5 lines
--
local function analyzeBufferContents()
  local lines = vim.api.nvim_buf_get_lines(0, 0, 5, false)
  -- Example: Check if a specific string exists in the file
  for _, line in ipairs(lines) do
    if line:find("colorscheme") then
      local pattern = "colorscheme ([%w-_]+)"
      local match = string.match(line, pattern)
      -- Perform actions like setting options, calling functions, etc.
      vim.cmd.colorscheme(match)
      break
    end
  end
end

vim.api.nvim_create_autocmd(
  {
      "BufEnter", "BufRead"
  },
  {
    callback = analyzeBufferContents
  }
)
