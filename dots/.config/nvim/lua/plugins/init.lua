return {
  {
    "hrsh7th/nvim-cmp",
    opts = function()
      require "configs.cmp"
    end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = function()
      return require "configs.nvimtree"
    end,
  },

  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = require "configs.conform",
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
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
    "karb94/neoscroll.nvim",
    lazy = false,
    opts = {},
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "cpp",
        "css",
        "html",
        "hyprlang",
        "javascript",
        "json",
        "kotlin",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "svelte",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      },
    },
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

  -- Fast code snippets
  {
    "mistricky/codesnap.nvim",
    tag = "v2.0.0-beta.17",
    lazy = false,
  },

  -- Zen mode (remove number column, disable tmux statusline, increase font)
  {
    "folke/zen-mode.nvim",
    lazy = false,
    opts = {
      window = {
        width = 100,
        backdrop = 1,
        options = {
          number = false, -- disable number column
          relativenumber = false, -- disable relative numbers
        },
      },
      plugins = {
        tmux = { enabled = true },
        kitty = {
          enabled = true,
          font = "+2", -- font size increment
        },
        twilight = { enabled = true },
      },
    },
    dependencies = {
      "folke/twilight.nvim",
    },
  },

  -- File manager
  {
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      keymaps = {
        ["g?"] = { "actions.show_help", mode = "n" },
        ["<CR>"] = "actions.select",
        ["<C-s>"] = { "actions.select", opts = { vertical = true } },
        ["<C-t>"] = { "actions.select", opts = { tab = true } },
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = { "actions.close", mode = "n" },
        ["-"] = { "actions.parent", mode = "n" },
        ["_"] = { "actions.open_cwd", mode = "n" },
        ["`"] = { "actions.cd", mode = "n" },
        ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
        ["gs"] = { "actions.change_sort", mode = "n" },
        ["gx"] = "actions.open_external",
        ["g."] = { "actions.toggle_hidden", mode = "n" },
        ["g\\"] = { "actions.toggle_trash", mode = "n" },
      },
      -- Set to false to disable all of the above keymaps
      use_default_keymaps = false,
    },
    -- Optional dependencies
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "benomahony/oil-git.nvim",
    }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
  },

  -- UI enhancer (floating cmdline, notifications)
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = false, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false, -- add a border to hover docs and signature help
      },
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      -- "rcarriga/nvim-notify",
    },
  },
}
