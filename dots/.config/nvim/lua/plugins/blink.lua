dofile(vim.g.base46_cache .. "blink")

local highlights = {
  BlinkCmpKindKeyword = { link = "BlinkCmpKindReference" },
}

for group, settings in pairs(highlights) do
  vim.api.nvim_set_hl(0, group, settings)
end

return {
  {
    "hrsh7th/nvim-cmp",
    enabled = false,
  },
  {
    "saghen/blink.cmp",
    build = function()
      -- build the fuzzy matcher, wait up to 60 seconds
      -- you can use `gb` in `:Lazy` to rebuild the plugin as needed
      require("blink.cmp").build():wait(60000)
    end,
    opts_extend = {
      "sources.completion.enabled_providers",
      "sources.compat",
      "sources.default",
    },
    dependencies = {
      "rafamadriz/friendly-snippets",
      "saghen/blink.lib",
      {
        "saghen/blink.compat",
        lazy = true,
        opts = {},
      },
    },
    event = { "InsertEnter", "CmdlineEnter" },

    opts = {
      snippets = { preset = "default" },
      appearance = { nerd_font_variant = "normal" },
      signature = { enabled = false },
      completion = {
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
        -- menu = require("nvchad.blink").menu,
        menu = require("configs.blink-ui").menu,
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 500,
          window = { border = "rounded" },
        },
        ghost_text = {
          enabled = true,
        },
      },

      cmdline = {
        keymap = {
          ["<C-f>"] = { "select_and_accept", "fallback" },
        },
        completion = {
          menu = {
            auto_show = true,
          },
          ghost_text = { enabled = true },
        },
      },

      sources = {
        default = { "lsp", "path", "snippets", "buffer", "vimtex", "luasnip" },
        providers = {
          cmdline = {
            min_keyword_length = function(ctx)
              -- when typing a command, only show when the keyword is 3 characters or longer
              if ctx.mode == "cmdline" and string.find(ctx.line, " ") == nil then
                return 3
              end
              return 0
            end,
          },
          vimtex = {
            name = "vimtex",
            module = "blink.compat.source",
          },
          luasnip = {
            name = "luasnip",
            module = "blink.compat.source",
          },
        },
      },

      keymap = {
        preset = "default",
        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      },
    },
  },
}
