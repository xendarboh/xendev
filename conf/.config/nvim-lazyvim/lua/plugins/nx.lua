return {
  {
    "Equilibris/nx.nvim",

    dependencies = {
      "nvim-telescope/telescope.nvim",
    },

    opts = {
      nx_cmd_root = "nx",
    },

    keys = {
      { "<leader>_nxa", "<cmd>Telescope nx actions<CR>", desc = "nx actions" },
      { "<leader>_nxr", "<cmd>Telescope nx run_many<CR>", desc = "nx run-many" },
      { "<leader>_nxf", "<cmd>Telescope nx affected<CR>", desc = "nx affected" },
      { "<leader>_nxg", "<cmd>Telescope nx generators<CR>", desc = "nx generators" },
      { "<leader>_nxw", "<cmd>Telescope nx workspace_generators<CR>", desc = "nx workspace generators" },
      { "<leader>_nxe", "<cmd>Telescope nx external_generators<CR>", desc = "nx external generators" },
    },
  },
}
