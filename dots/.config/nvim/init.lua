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

vim.g.lua_snippets_path = vim.fn.stdpath "config" .. "/lua/snippets"
vim.g.vscode_snippets_exclude = { "tex", "typescriptreact" }

require("luasnip").config.set_config {
  enable_autosnippets = true,
  store_selection_keys = "<Tab>",
}

os.execute "python ~/.config/nvim/pywal/chadwal.py &> /dev/null &"

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

autocmd("Signal", {
  pattern = "SIGUSR1",
  callback = function()
    require("nvchad.utils").reload()
  end,
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

autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    local params = vim.lsp.util.make_range_params(0, "utf-8")
    params.context = { only = { "source.organizeImports" } }
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
    vim.lsp.buf.format { async = false }
  end,
})
