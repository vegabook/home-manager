-- map leader 
vim.g.mapleader = ","
vim.g.maplocalleader = ","
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
if vim.fn.has("termguicolors") then
  vim.opt.termguicolors = true
end
-- add bqn filetype
--
vim.filetype.add({
  extension = {
    bqn = "bqn",
  },
})

-- setup section ------------------------------------------
require("csvview").setup({
  parser = { comments = { "#", "//" } },
  keymaps = {
    textobject_field_inner = { "if", mode = { "o", "x" } },
    textobject_field_outer = { "af", mode = { "o", "x" } },
    jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
    jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
    jump_next_row = { "<Enter>", mode = { "n", "v" } },
    jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
  },
})

-- enable classic syntax groups alongside treesitter so colorschemes have
-- something consistent to target even when TS coverage is incomplete
vim.cmd("syntax enable")

-- treesitter highlighting (parsers installed via nix)
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    local buf = args.buf
    local ft = vim.bo[buf].filetype

    if ft ~= "" and vim.bo[buf].syntax == "" then
      vim.bo[buf].syntax = ft
    end

    pcall(vim.treesitter.start, buf)
  end,
})

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
        vim.cmd.colorscheme("base16-greenscreen")

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

  -- keep the generic tab line style, but preserve the red selected-tab highlight
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


-- Claude integration -----------------------

-- Auto-reload files when Claude edits them
vim.opt.autoread = true
vim.opt.updatetime = 1000
vim.api.nvim_create_autocmd({ "FocusGained", "TermLeave" }, {
  callback = function() vim.cmd("checktime") end,
})
-- Poll for file changes every second even when Neovim pane is unfocused (tmux)
local _claude_timer = vim.loop.new_timer()
_claude_timer:start(0, 750, vim.schedule_wrap(function()
  vim.cmd("silent! checktime")
end))

-- Skip the "file has changed on disk" prompt and silently reload
vim.api.nvim_create_autocmd("FileChangedShell", {
  callback = function()
    vim.v.fcs_choice = "reload"
  end,
})

local _claude_ns = vim.api.nvim_create_namespace("claude_key_listener")
local _claude_changed = false
local _claude_prev_scheme = nil
local _claude_prev_bg = nil
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  callback = function()
    if _claude_changed then
      vim.cmd.colorscheme("codered")
      return
    end
    _claude_changed = true
    _claude_prev_scheme = vim.g.colors_name
    _claude_prev_bg = vim.opt.background:get()
    vim.cmd.colorscheme("codered")
    vim.on_key(function(key)
      if key ~= "" then
        vim.on_key(nil, _claude_ns)
        vim.schedule(function()
          vim.opt.background = _claude_prev_bg
          vim.cmd.colorscheme(_claude_prev_scheme)
          _claude_changed = false
        end)
      end
    end, _claude_ns)
  end,
})

-- One-key yank: file path + current buffer (or visual selection)
vim.keymap.set("n", "<leader>yc", function()
  local path = vim.fn.expand("%:p")
  local content = table.concat(vim.fn.getline(1, "$"), "\n")
  vim.fn.setreg("+", path .. "\n\n" .. content)
  print("✓ Yanked path + buffer to clipboard for Claude")
end, { desc = "Yank for Claude" })

vim.keymap.set("v", "<leader>yc", function()
  local path = vim.fn.expand("%:p")
  -- Exit visual mode first so '< and '> marks are set correctly
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", false)
  local start = vim.fn.line("'<")
  local finish = vim.fn.line("'>")
  local content = table.concat(vim.fn.getline(start, finish), "\n")
  vim.fn.setreg("+", path .. "\n\n" .. content)
  print("✓ Yanked path + selection to clipboard for Claude")
end, { desc = "Yank selection for Claude" })
