return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require "lint"
    lint.linters_by_ft = {
      bash = { "shellcheck" },
      go = { "golangcilint" },
      javascript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescript = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      python = { "ruff" },
      markdown = { "markdownlint" },
      quarto = { "markdownlint" },
    }

    lint.linters.markdownlint.args = {
      "--fix",
      "--disable",
      "MD013",
      "--",
    }

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "BufReadPost", "TextChanged" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })
  end,
  dependencies = { "rshkarin/mason-nvim-lint" },
}
