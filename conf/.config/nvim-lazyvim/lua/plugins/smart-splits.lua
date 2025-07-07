return {
  {
    "mrjones2014/smart-splits.nvim",

    -- make sure to be loaded at the first time
    lazy = false,
    opts = {
      at_edge = "stop",
    },
    config = function(_, opts)
      require("smart-splits").setup(opts)
    end,
  },
}
