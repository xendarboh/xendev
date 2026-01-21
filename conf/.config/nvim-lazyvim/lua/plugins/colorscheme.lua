return {
  -- Add colorschemes
  { "ellisonleao/gruvbox.nvim" },
  { "folke/tokyonight.nvim" },

  -- Configure LazyVim to load a default colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight-night",
    },
  },

  -- Sync neovim native colorscheme with tinted theming
  {
    "tinted-theming/tinted-nvim",
    lazy = false,
    priority = 1000,
    opts = {
      supports = {
        tinty = true,
        live_reload = true,
      },
    },
    config = function(_, opts)
      local tinted = require("tinted-colorscheme")

      -- suppress noisy notifications during setup about custom themes not found
      local notify = vim.notify
      vim.notify = function() end
      tinted.setup(opts)
      vim.notify = notify

      local last_applied = nil

      local slug_transforms = {
        { "^tokyo%-night%-dark$", "tokyonight-night" },
        { "^tokyo%-night%-light$", "tokyonight-day" },
        { "^tokyo%-night%-", "tokyonight-" },
      }

      local function apply_native_theme()
        local name = vim.fn.system("tinty current"):gsub("%s+", "")
        if name == "" or name == last_applied then
          return
        end
        last_applied = name

        local slug = name:gsub("base%d+%-", "")

        for _, transform in ipairs(slug_transforms) do
          local new = slug:gsub(transform[1], transform[2])
          if new ~= slug then
            slug = new
            break
          end
        end

        local applied
        if slug:find("^gruvbox") then
          require("gruvbox").setup({ contrast = slug:match("soft") or slug:match("medium") or "hard" })
          vim.cmd.colorscheme("gruvbox")
          applied = "gruvbox (.nvim)"
        elseif pcall(vim.cmd.colorscheme, slug) then
          applied = slug .. " (.nvim)"
        else
          applied = slug
        end

        vim.notify(name .. " → " .. applied, vim.log.levels.INFO, { title = "tinted colorscheme" })
      end

      vim.api.nvim_create_autocmd("User", {
        pattern = "TintedColorsPost",
        callback = function()
          vim.schedule(apply_native_theme)
        end,
      })

      vim.schedule(apply_native_theme)
    end,
  },
}
