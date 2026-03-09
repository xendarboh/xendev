return {
  {
    "joshuavial/aider.nvim",
    opts = {
      auto_manage_context = true,
      default_bindings = false,
    },
    keys = {
      { "<leader>A", "", desc = "+aider", mode = { "n", "x" } },
      { "<leader>Ao", "<cmd>AiderOpen<CR>", desc = "Open Aider" },
      { "<leader>Am", "<cmd>AiderAddModifiedFiles<CR>", desc = "Add Modified Files" },
    },
  },
}
