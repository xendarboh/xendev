return {
  {
    "iamcco/markdown-preview.nvim",

    opts = function()
      vim.g.mkdp_echo_preview_url = 1 -- set to 1, echo preview page url in command line when open preview page
      vim.g.mkdp_port = "8899" -- use a custom port to start server or empty for random
    end,
  },
}
