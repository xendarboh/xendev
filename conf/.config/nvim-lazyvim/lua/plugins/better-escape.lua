return {
  {
    "max397574/better-escape.nvim",
    opts = {
      -- https://github.com/max397574/better-escape.nvim/issues/81#issuecomment-2226773326
      mappings = {
        t = { j = { false } }, -- lazygit navigation fix
        v = { j = { k = false } }, -- visual select fix
      },
    },
    config = function(_, opts)
      require("better_escape").setup(opts)
    end,
  },
}
