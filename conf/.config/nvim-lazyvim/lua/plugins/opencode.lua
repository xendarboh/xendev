return {
  {
    "nickjvandyke/opencode.nvim",
    version = "*",
    cond = function()
      return vim.fn.executable("opencode") == 1
    end,
    dependencies = {
      {
        "folke/snacks.nvim",
        optional = true,
        opts = {
          input = {},
          picker = {
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
    config = function()
      vim.g.opencode_opts = {}
      vim.o.autoread = true
    end,

    keys = {
      -- Enable menu groupings in both Normal and Visual modes.
      { "<leader>a", "", desc = "+ai", mode = { "n", "x" } },
      { "<leader>ao", "", desc = "+opencode", mode = { "n", "x" } },

      {
        "<leader>aot",
        function()
          require("opencode").toggle()
        end,
        desc = "Toggle opencode",
        mode = { "n", "t" },
      },
      {
        "<leader>aoa",
        function()
          require("opencode").ask("@this: ", { submit = true })
        end,
        desc = "Ask opencode",
        mode = { "n", "x" },
      },
      {
        "<leader>aos",
        function()
          require("opencode").select()
        end,
        desc = "Select opencode action",
        mode = { "n", "x" },
      },
      {
        "<leader>aoo",
        function()
          return require("opencode").operator("@this ")
        end,
        desc = "Add range to opencode",
        mode = { "n", "x" },
        expr = true,
      },
    },
  },
}
