local nvlsp = require "nvchad.configs.lspconfig"

nvlsp.defaults()

local servers = {
  basedpyright = {},
  bashls = {},
  cmake = {},
  clangd = {},
  cssls = {},
  denols = {},
  gopls = {},
  html = {},
  jsonls = {},
  kotlin_lsp = {},
  lua_ls = {},
  prismals = {},
  qmlls = {},
  svelte = {},
  taplo = {},
  vtsls = {},
  yamlls = {},
}

for name, opts in pairs(servers) do
  vim.lsp.enable(name)
  vim.lsp.config(name, opts)
end

return {
  "neovim/nvim-lspconfig",
}
