return {
  "yetone/avante.nvim",
  opts = {
    provider = "copilot",
  },
  keys = {
    -- Disable default LazyVim avante keymaps under <leader>a
    { "<leader>aa", false },
    { "<leader>ac", false },
    { "<leader>ae", false },
    { "<leader>af", false },
    { "<leader>ah", false },
    { "<leader>am", false },
    { "<leader>an", false },
    { "<leader>ap", false },
    { "<leader>ar", false },
    { "<leader>as", false },
    { "<leader>at", false },

    -- Enable menu groupings in both Normal and Visual modes.
    { "<leader>a", "", desc = "+ai", mode = { "n", "x" } },
    { "<leader>av", "", desc = "+avante", mode = { "n", "x" } },

    -- Ensure relevant commands are also in Visual mode.
    { "<leader>ava", "<cmd>AvanteAsk<CR>", desc = "Ask Avante", mode = { "n", "v" } },
    { "<leader>avc", "<cmd>AvanteChat<CR>", desc = "Chat with Avante" },
    { "<leader>ave", "<cmd>AvanteEdit<CR>", desc = "Edit Avante", mode = { "n", "v" } },
    { "<leader>avf", "<cmd>AvanteFocus<CR>", desc = "Focus Avante" },
    { "<leader>avh", "<cmd>AvanteHistory<CR>", desc = "Avante History" },
    { "<leader>avm", "<cmd>AvanteModels<CR>", desc = "Select Avante Model" },
    { "<leader>avn", "<cmd>AvanteChatNew<CR>", desc = "New Avante Chat" },
    { "<leader>avp", "<cmd>AvanteSwitchProvider<CR>", desc = "Switch Avante Provider" },
    { "<leader>avr", "<cmd>AvanteRefresh<CR>", desc = "Refresh Avante" },
    { "<leader>avs", "<cmd>AvanteStop<CR>", desc = "Stop Avante" },
    { "<leader>avt", "<cmd>AvanteToggle<CR>", desc = "Toggle Avante" },
  },
}
