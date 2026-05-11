return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  opts = {
    formatters_by_ft = {
      cmake = { "cmake_format" },
      css = { "prettier", "prettierd", stop_after_first = true },
      go = { "golines" },
      html = { "prettier", "prettierd", stop_after_first = true },
      javascript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      json = { "prettier", "prettierd", stop_after_first = true },
      lua = { "stylua" },
      python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
      sh = { "shfmt" },
      toml = { "taplo" },
      typescript = { "eslint_d" },
      typescriptreact = { "eslint_d" },
    },

    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = false,
    },
  },
}
