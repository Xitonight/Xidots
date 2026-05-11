local nvlsp = require "nvchad.configs.lspconfig"

nvlsp.defaults()

local servers = {
  bashls = {},
  cmake = {},
  clangd = {},
  cssls = {},
  denols = {},
  gopls = {
    settings = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      gofumpt = true,
    },
  },
  html = {},
  jsonls = {},
  kotlin_lsp = {},
  lua_ls = {},
  prismals = {},
  pyright = {
    settings = {
      pyright = {
        disableOrganizeImports = true,
      },
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        useLibraryCodeForTypes = true,
      },
    },
    root_markers = {
      "main.py",
      "pyproject.toml",
      "setup.py",
      "setup.cfg",
      "requirements.txt",
      "Pipfile",
      "pyrightconfig.json",
      ".git",
    },
  },
  svelte = {},
  taplo = {},
  vtsls = {},
}

for name, opts in pairs(servers) do
  vim.lsp.enable(name)
  vim.lsp.config(name, opts)
end

return {
  "neovim/nvim-lspconfig",
}
