return {
  {
    "joshuavial/aider.nvim",
    cond = function()
      return vim.fn.executable("aider") == 1
    end,
    opts = {
      auto_manage_context = true,
      default_bindings = false,
    },
    keys = {
      { "<leader>aD", "", desc = "+aider", mode = { "n", "x" } },
      { "<leader>aDo", "<cmd>AiderOpen<CR>", desc = "Open Aider" },
      { "<leader>aDm", "<cmd>AiderAddModifiedFiles<CR>", desc = "Add Modified Files" },
    },
  },
}
