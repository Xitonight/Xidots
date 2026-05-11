return {
  "lervag/vimtex",
  lazy = false,
  init = function()
    vim.g.vimtex_imaps_enabled = false

    vim.g.vimtex_compiler_latexmk = {
      aux_dir = function()
        return vim.fn.expand "~" .. "/.cache/texfiles/" .. vim.fn.expand "%:t:r"
      end,
      out_dir = function()
        return vim.fn.expand "%:t:r"
      end,
    }

    vim.g.vimtex_view_method = "zathura"

    vim.g.vimtex_format_enabled = true
    vim.g.vimtex_format_method = "latexindent"
    vim.g.vimtex_quickfix_open_on_warning = false
    vim.g.vimtex_view_forward_search_on_start = false
  end,
}
