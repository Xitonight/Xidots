local nvlsp = require "nvchad.configs.lspconfig"

nvlsp.defaults()

local servers = {
  bashls = {},
  cmake = {},
  clangd = {},
  cssls = {},
  denols = {},
  eslint = {},
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
  tailwindcss = {},
  ts_ls = {},
}

for name, opts in pairs(servers) do
  vim.lsp.enable(name)
  vim.lsp.config(name, opts)
end

local base_on_attach = vim.lsp.config.eslint.on_attach
vim.lsp.config("eslint", {
  on_attach = function(client, bufnr)
    if not base_on_attach then
      return
    end

    base_on_attach(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "LspEslintFixAll",
    })
  end,
})
