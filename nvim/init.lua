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
