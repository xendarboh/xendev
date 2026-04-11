local dev_path = vim.fn.expand("~/src/github/xendarboh/tuicr.nvim")
local dev = vim.fn.isdirectory(dev_path) == 1

return {
  {
    "xendarboh/tuicr.nvim",
    dir = dev and dev_path or nil,
    dev = dev,
    cond = function()
      return vim.fn.executable("tuicr") == 1
    end,
    opts = {},
    keys = {
      { "<leader>a", "", desc = "+ai", mode = { "n", "x" } },
      {
        "<leader>ar",
        function()
          require("tuicr").run()
        end,
        desc = "Tuicr review",
      },
    },
  },
}
