return {
  {
    "hrsh7th/nvim-cmp",
    enabled = false,
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = function()
      return require "configs.nvimtree"
    end,
    -- enabled = false,
  },

  {
    "nvim-telescope/telescope.nvim",
    enabled = false,
  },

  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },

  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup {}
    end,
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = { "markdown", "quarto" },
    opts = {
      sign = { enabled = false },
    },
  },

  {
    "NStefan002/screenkey.nvim",
    lazy = false,
    version = "*", -- or branch = "dev", to use the latest commit
  },

  {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    event = {
      "BufReadPre " .. vim.fn.expand "~" .. "Documents/Notes/Uni/*.md",
      "BufNewFile " .. vim.fn.expand "~" .. "Documents/Notes/Uni/*.md",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      workspaces = {
        {
          name = "Uni",
          path = "~/Documents/Notes/Uni",
        },
      },
    },
  },

  -- Autoclose HTML tags
  {
    "windwp/nvim-ts-autotag",
    lazy = false,
    event = { "BufWritePre", "BufNewFile" },
    opts = {},
  },
}
