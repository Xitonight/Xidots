return {
  "nickjvandyke/opencode.nvim",
  lazy = true,
  version = "*", -- Latest stable release
  dependencies = {
    {
      -- `snacks.nvim` integration is recommended, but optional
      ---@module "snacks" <- Loads `snacks.nvim` types for configuration intellisense
      "folke/snacks.nvim",
      optional = true,
      opts = {
        input = {}, -- Enhances `ask()`
        picker = { -- Enhances `select()`
          actions = {
            opencode_send = function(...)
              return require("opencode").snacks_picker_send(...)
            end,
          },
          win = {
            input = {
              keys = {
                ["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
              },
            },
          },
        },
      },
    },
  },
  keys = {
    {
      mode = { "n", "x" },
      "<leader>oa",
      function()
        require("opencode").ask("@this: ", { submit = true })
      end,
      desc = "Ask opencode…",
    },
    {
      mode = { "n", "x" },
      "<leader>ox",
      function()
        require("opencode").select()
      end,
      desc = "Execute opencode action…",
    },
    {
      "<leader>os",
      function()
        require("opencode").select_server()
      end,
      desc = "Select opencode server",
      mode = { "n", "t" },
    },
    {
      "go",
      function()
        return require("opencode").operator "@this "
      end,
      desc = "Add range to opencode",
      expr = true,
      mode = { "n", "x" },
    },
    {
      "goo",
      function()
        return require("opencode").operator "@this " .. "_"
      end,
      desc = "Add line to opencode",
      expr = true,
      mode = "n",
    },
  },
  config = function()
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      -- Your configuration, if any; goto definition on the type or field for details
    }

    vim.o.autoread = true -- Required for `opts.events.reload`

    -- Recommended/example keymaps
  end,
}
