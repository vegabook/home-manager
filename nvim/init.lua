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
  'nyoom-engineering/oxocarbon.nvim',
  'mathofprimes/nightvision-nvim',
  'ribru17/bamboo.nvim',
  'rockerBOO/boo-colorscheme-nvim',
  'mlochbaum/BQN',
  'slugbyte/lackluster.nvim',
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
            ensure_installed = { "python", "c", "lua", "vim", "vimdoc", 
              "query", "erlang", "heex", "eex", "elixir", "javascript", "html", "r"},
            sync_install = false,
            highlight = { enable = true, 
              additional_vim_regex_highlighting = { "elixir" }, 
            },
            indent = { enable = true,
            disable = { "elixir"}, 
            },  
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
  {
    'nvim-telescope/telescope.nvim', branch = '0.1.x',
      dependencies = { 'nvim-lua/plenary.nvim' }
  },

  {
    "folke/sidekick.nvim",
    opts = {
      -- add any options here
      cli = {
        mux = {
          backend = "zellij",
          enabled = true,
        },
      },
    },
    keys = {
      {
        "<tab>",
        function()
          -- if there is a next edit, jump to it, otherwise apply it if any
          if not require("sidekick").nes_jump_or_apply() then
            return "<Tab>" -- fallback to normal tab
          end
        end,
        expr = true,
        desc = "Goto/Apply Next Edit Suggestion",
      },
      {
        "<c-.>",
        function() require("sidekick.cli").toggle() end,
        desc = "Sidekick Toggle",
        mode = { "n", "t", "i", "x" },
      },
      {
        "<leader>aa",
        function() require("sidekick.cli").toggle() end,
        desc = "Sidekick Toggle CLI",
      },
      {
        "<leader>as",
        function() require("sidekick.cli").select() end,
        -- Or to select only installed tools:
        -- require("sidekick.cli").select({ filter = { installed = true } })
        desc = "Select CLI",
      },
      {
        "<leader>ad",
        function() require("sidekick.cli").close() end,
        desc = "Detach a CLI Session",
      },
      {
        "<leader>at",
        function() require("sidekick.cli").send({ msg = "{this}" }) end,
        mode = { "x", "n" },
        desc = "Send This",
      },
      {
        "<leader>af",
        function() require("sidekick.cli").send({ msg = "{file}" }) end,
        desc = "Send File",
      },
      {
        "<leader>av",
        function() require("sidekick.cli").send({ msg = "{selection}" }) end,
        mode = { "x" },
        desc = "Send Visual Selection",
      },
      {
        "<leader>ap",
        function() require("sidekick.cli").prompt() end,
        mode = { "n", "x" },
        desc = "Sidekick Select Prompt",
      },
      -- Example of a keybinding to open Claude directly
      {
        "<leader>ac",
        function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end,
        desc = "Sidekick Toggle Claude",
      },
    },
  }

}

local opts = {}
local copilot_opts = {}

-- setup
--
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
    git_ignored = true,
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


-- Mappings

vim.keymap.set('n', '<Leader>ne', '<cmd>NvimTreeOpen<cr>')
vim.keymap.set('n', '<Right>', ':tabn<cr>')
vim.keymap.set('n', '<Left>', ':tabp<cr>')


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
    end

  end,
})


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
      if line:find("dark") then
        vim.opt.background = 'dark'
      else
        vim.opt.background = 'light'
      end
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
