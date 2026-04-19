-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local version = vim.version().minor
local M = {}

M.stbufnr = function()
  return vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)
end

M.base46 = {
  theme = "chadwal",
  transparency = false,
}

M.mason = {
  pkgs = {
    "shellcheck",
  },
}

M.nvdash = {
  load_on_startup = true,
}

M.ui = {
  tabufline = {
    enabled = false,
    order = { "buffers", "treeOffset" },
  },
  cmp = {
    lspkind_text = true,
    style = "default",
    icons_left = true,
  },
  telescope = { style = "bordered" },
  statusline = {
    theme = "minimal",
    separator_style = "round",
    order = { "mode", "file", "git", "%=", "lsp_msg", "%=", "diagnostics", "lsp", "cwd" },
    modules = {
      file = function()
        local icon = "󰈚"
        local path = vim.api.nvim_buf_get_name(M.stbufnr())
        local name = (path == "" and "Empty ") or path:match "([^/\\]+)[/\\]*$"

        if name ~= "Empty " then
          local devicons_present, devicons = pcall(require, "nvim-web-devicons")

          if devicons_present then
            local ft_icon = devicons.get_icon(name)
            icon = (ft_icon ~= nil and ft_icon) or icon
          end
        end

        return "%#St_file_sep#" .. icon .. " " .. name
      end,
      lsp = function()
        if rawget(vim, "lsp") and version >= 10 then
          for _, client in ipairs(vim.lsp.get_clients()) do
            if client.attached_buffers[M.stbufnr()] then
              return (vim.o.columns > 100 and "   " .. client.name .. " ") or "   LSP "
            end
          end
        end

        return ""
      end,
    },
  },
}

M.lsp = {
  signature = false,
}

return M
