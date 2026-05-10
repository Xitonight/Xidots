-- require "nvchad.mappings"

local map = vim.keymap.set

-- General Vim actions
map({ "n", "v" }, ";", ":", { desc = "CMD enter command mode" })
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "general clear highlights" })
map("n", "<leader>vui", vim.show_pos, { desc = "Inspect Pos" })
map("n", "<leader>vuI", function()
  vim.treesitter.inspect_tree()
  vim.api.nvim_input "I"
end, { desc = "Inspect Tree" })

-- Vim options
map("n", "<leader>vn", "<cmd>set nu!<CR>", { desc = "toggle line number" })
map("n", "<leader>vrn", "<cmd>set rnu!<CR>", { desc = "toggle relative number" })

-- which-key
map("n", "<leader>wk", "<cmd>WhichKey <CR>", { desc = "whichkey all keymaps" })

-- NvChad related
map("n", "<leader>th", function()
  require("nvchad.themes").open()
end, { desc = "telescope nvchad themes" })

-- Better n/N navigation
-- -- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- Comment
map("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })

-- Window navigation (integration with tmux)
map("n", "<C-h>", function()
  vim.cmd "TmuxNavigateLeft"
end, { desc = "window left" })
map("n", "<C-l>", function()
  vim.cmd "TmuxNavigateRight"
end, { desc = "window right" })
map("n", "<C-j>", function()
  vim.cmd "TmuxNavigateDown"
end, { desc = "window down" })
map("n", "<C-k>", function()
  vim.cmd "TmuxNavigateUp"
end, { desc = "window up" })

-- Lazy
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

map("n", "<leader>e", function()
  vim.cmd "NvimTreeToggle"
end, { desc = "toggle NvimTree" })

map("n", "<leader>ca", function()
  vim.lsp.buf.code_action {
    apply = false,
    context = {
      diagnostics = {},
    },
  }
end, { desc = "Open Code Action Menu" })

map("v", "<C-c>", '"+y', { desc = "Yank into system clipboard" })
map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "general copy whole file" })

map({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr>", { desc = "Save current open buffer" })

map("n", "<leader>o", "<CMD>Oil<CR>", { desc = "Open parent directory" })
