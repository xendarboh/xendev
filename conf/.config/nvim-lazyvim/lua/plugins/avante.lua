return {
  "yetone/avante.nvim",
  opts = {
    provider = "copilot",
  },
  keys = {
    -- Enable menu grouping for "ai" commands in both Normal and Visual modes.
    { "<leader>a", "", desc = "+ai", mode = { "n", "x" } },

    -- Ensure relevant commands are also in Visual mode.
    { "<leader>aa", "<cmd>AvanteAsk<CR>", desc = "Ask Avante", mode = { "n", "v" } },
    { "<leader>ae", "<cmd>AvanteEdit<CR>", desc = "Edit Avante", mode = { "n", "v" } },
  },
}
