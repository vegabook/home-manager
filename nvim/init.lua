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

-- lazy plugins 
local plugins = {
  'nvim-tree/nvim-tree.lua',
  'nvim-tree/nvim-web-devicons',
  'nvim-treesitter/nvim-treesitter',
  'hrsh7th/nvim-cmp',
  'github/copilot.vim'
}

local opts = {}
local copilot_opts = {}

-- setup
require("lazy").setup(plugins, opts)

-- Global settings
vim.opt.modifiable = true
vim.opt.number = true
vim.opt.relativenumber = true
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

-- Functions for mapping

function map(mode, shortcut, command)
  vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
end

function nmap(shortcut, command)
  map('n', shortcut, command)
end

function imap(shortcut, command)
  map('i', shortcut, command)
end

-- Mappings

vim.api.nvim_create_autocmd(
  {
      "BufEnter",
  },
  {
    pattern = "*.py",
    callback = function()
      vim.opt.shiftwidth = 4
      vim.opt.tabstop = 4
    end
  }
)
