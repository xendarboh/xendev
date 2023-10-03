-- sourced by lunarvim's `config.lua`
-- useful for machine-specific overrides, run-time annoyances, or private info not included in container image

table.insert(lvim.plugins, {
  -- run-time annoyance: this plugin will prompt for wakatime API key if not set when starting lvim
  -- preserve config from container host with `conf.local/wakatime.cfg`
  -- "wakatime/vim-wakatime",
})
