-- Formatting: dprint/prettier mutual exclusion
-- When a project has a dprint config, use dprint instead of prettier.

-- Filetypes that the LazyVim prettier extra covers
local prettier_fts = {
  "css",
  "graphql",
  "handlebars",
  "html",
  "javascript",
  "javascriptreact",
  "json",
  "jsonc",
  "less",
  "markdown",
  "markdown.mdx",
  "scss",
  "typescript",
  "typescriptreact",
  "vue",
  "yaml",
}

---@param ctx {filename: string}
local function has_dprint_config(ctx)
  return vim.fs.find(
    { "dprint.json", ".dprint.json", "dprint.jsonc", ".dprint.jsonc" },
    { path = ctx.filename, upward = true }
  )[1]
end

return {
  {
    "stevearc/conform.nvim",
    ---@param opts conform.setupOpts
    opts = function(_, opts)
      -- Add dprint to every filetype that prettier handles
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      for _, ft in ipairs(prettier_fts) do
        opts.formatters_by_ft[ft] = opts.formatters_by_ft[ft] or {}
        table.insert(opts.formatters_by_ft[ft], "dprint")
      end

      -- Formatter conditions: mutual exclusion
      opts.formatters = opts.formatters or {}
      opts.formatters.dprint = {
        condition = function(_, ctx)
          return has_dprint_config(ctx)
        end,
      }
      opts.formatters.prettier = {
        condition = function(_, ctx)
          return not has_dprint_config(ctx)
        end,
      }
    end,
  },
}
