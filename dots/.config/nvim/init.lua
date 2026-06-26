vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)

vim.g.markdown_fenced_languages = {
  "ts=typescript",
}

require("luasnip").config.set_config {
  enable_autosnippets = true,
  store_selection_keys = "<Tab>",
}

local autocmd = vim.api.nvim_create_autocmd

-- Reset kitty font size on leave
-- Useful when quitting in zen-mode
autocmd("VimLeave", {
  pattern = "*",
  callback = function()
    local listen_on = os.getenv "KITTY_LISTEN_ON"
    if listen_on then
      vim.fn.jobstart({
        "kitty",
        "@",
        "--to",
        listen_on,
        "set-font-size",
        "0",
      }, { detach = true })
    end
  end,
})

autocmd("VimLeave", {
  pattern = "*",
  command = "silent !tmux set status on",
})

autocmd("VimLeave", {
  pattern = "*",
  command = "silent !tmux set status 2",
})

autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    local line = vim.fn.line "'\""
    if
      line > 1
      and line <= vim.fn.line "$"
      and vim.bo.filetype ~= "commit"
      and vim.fn.index({ "xxd", "gitrebase" }, vim.bo.filetype) == -1
    then
      vim.cmd 'normal! g`"'
    end
  end,
})

vim.filetype.add {
  pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
}

autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*/swaync/*.css",
  callback = function(ev)
    vim.diagnostic.enable(false, { bufnr = ev.buf })
  end,
})
