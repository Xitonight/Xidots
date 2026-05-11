dofile(vim.g.base46_cache .. "flash")

return {
  "folke/flash.nvim",
  event = "VeryLazy",
  vscode = true,
  opts = {},
  -- stylua: ignore
  keys = {
    { "S", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    -- Simulate nvim-treesitter incremental selection
    { "<c-s>", mode = { "n", "o", "x" },
      function()
        require("flash").treesitter({
          actions = {
            ["<c-s>"] = "next",
            ["<BS>"] = "prev"
          }
        })
      end, desc = "Treesitter Incremental Selection" },
  },
}
