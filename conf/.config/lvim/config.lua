-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

vim.opt.relativenumber = true -- relative line numbers
vim.opt.undofile = false -- persistent undo
vim.opt.whichwrap = "b,s" -- allow left/right cursor keys to move prev/next

-- https://www.lunarvim.org/docs/troubleshooting#are-you-using-fish
vim.opt.shell = "/bin/sh"

vim.opt.spellfile = os.getenv("HOME") .. "/.local/share/nvim/spell/en.utf-8.add"

vim.g.node_host_prog = "/usr/local/bin/neovim-node-host"

-- https://www.lunarvim.org/docs/configuration/appearance/statusline
-- https://github.com/nvim-lualine/lualine.nvim/blob/master/README.md
-- lvim.builtin.lualine.options.component_separators = { left = '', right = '' }
lvim.builtin.lualine.options.component_separators = nil
lvim.builtin.lualine.options.section_separators = { left = "", right = "" }

-- increase null-ls timeout
-- https://github.com/LunarVim/LunarVim/discussions/2767
lvim.builtin.which_key.mappings["l"]["f"] = {
	function()
		require("lvim.lsp.utils").format({ timeout_ms = 2000 })
	end,
	"Format",
}

lvim.format_on_save.enabled = true
lvim.format_on_save.pattern = {
	"*.go",
	"*.js",
	"*.jsx",
	"*.lua",
	"*.md",
	"*.proto",
	"*.ts",
	"*.tsx",
}

-- https://www.lunarvim.org/docs/configuration/language-features/linting-and-formatting
local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
	{ name = "buf" },
	-- { name = "golines" },
	{
		name = "prettier",
		---@usage arguments to pass to the formatter
		-- these cannot contain whitespace
		-- options such as `--line-width 80` become either `{"--line-width", "80"}` or `{"--line-width=80"}`
		-- args = { "--print-width", "100" },
		---@usage only start in these filetypes, by default it will attach to all filetypes it supports
		-- filetypes = { "typescript", "typescriptreact" },
	},
	{ name = "stylua" },
	{
		name = "terraform_fmt",
		filetypes = { "terraform", "tf", "terraform-vars", "hcl" },
	},
})

local linters = require("lvim.lsp.null-ls.linters")
linters.setup({
	{ name = "buf" },
})

-- https://www.lunarvim.org/docs/configuration/plugins/user-plugins
lvim.plugins = {
	{
		"iamcco/markdown-preview.nvim",
		build = "cd app && npm install",
		ft = "markdown",
		-- https://github.com/iamcco/markdown-preview.nvim#markdownpreview-config
		config = function()
			vim.g.mkdp_auto_start = 0 -- set to 1, nvim will open the preview window after entering the markdown buffer
			vim.g.mkdp_echo_preview_url = 1 -- set to 1, echo preview page url in command line when open preview page
			vim.g.mkdp_port = "8899" -- use a custom port to start server or empty for random
		end,
	},
	{
		"karb94/neoscroll.nvim",
		event = "WinScrolled",
		config = function()
			require("neoscroll").setup({
				-- All these keys will be mapped to their corresponding default scrolling animation
				mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
				hide_cursor = true, -- Hide cursor while scrolling
				stop_eof = true, -- Stop at <EOF> when scrolling downwards
				use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
				respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
				cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
				easing_function = nil, -- Default easing function
				pre_hook = nil, -- Function to run before the scrolling animation starts
				post_hook = nil, -- Function to run after the scrolling animation ends
				performance_mode = false, -- Disable "Performance Mode" on all buffers.
			})
		end,
	},
	{
		"max397574/better-escape.nvim",
		config = function()
			require("better_escape").setup({
				-- mapping = { "jk", "jj" },   -- a table with mappings to use
				-- timeout = vim.o.timeoutlen, -- the time in which the keys must be hit in ms. Use option timeoutlen by default
				-- clear_empty_lines = false,  -- clear line after escaping if there is only whitespace
				-- -- keys used for escaping, if it is a function will use the result everytime
				-- -- keys = "<Esc>",
				-- keys = function()
				--   return vim.api.nvim_win_get_cursor(0)[2] > 1 and '<esc>l' or '<esc>'
				-- end,
			})
		end,
	},
	"mrjones2014/smart-splits.nvim",
}

------------------------------------------------------------------------
-- copilot
-- https://www.lunarvim.org/docs/configuration/plugins/example-configurations#copilotlua-and-copilot-cmp
-- run `:Lazy load copilot-cmp` followed by `:Copilot auth` once the plugin is installed
------------------------------------------------------------------------

table.insert(lvim.plugins, {
	"zbirenbaum/copilot-cmp",
	event = "InsertEnter",
	dependencies = { "zbirenbaum/copilot.lua" },
	config = function()
		vim.defer_fn(function()
			require("copilot").setup() -- https://github.com/zbirenbaum/copilot.lua/blob/master/README.md#setup-and-configuration
			require("copilot_cmp").setup() -- https://github.com/zbirenbaum/copilot-cmp/blob/master/README.md#configuration
		end, 100)
	end,
})

-- mrjones2014/smart-splits.nvim
-- https://github.com/mrjones2014/smart-splits.nvim#key-mappings
-- these keymaps will also accept a range, for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`
-- resizing splits
vim.keymap.set("n", "<A-h>", require("smart-splits").resize_left)
vim.keymap.set("n", "<A-j>", require("smart-splits").resize_down)
vim.keymap.set("n", "<A-k>", require("smart-splits").resize_up)
vim.keymap.set("n", "<A-l>", require("smart-splits").resize_right)
-- moving between splits
vim.keymap.set("n", "<C-h>", require("smart-splits").move_cursor_left)
vim.keymap.set("n", "<C-j>", require("smart-splits").move_cursor_down)
vim.keymap.set("n", "<C-k>", require("smart-splits").move_cursor_up)
vim.keymap.set("n", "<C-l>", require("smart-splits").move_cursor_right)

-- https://www.reddit.com/r/lunarvim/comments/13a72cl/lsp_problem_attachinginstalling_servers/
require("mason-lspconfig").setup_handlers({
	function(server)
		require("lvim.lsp.manager").setup(server)
	end,
})

require("lvim.lsp.manager").setup("marksman")

-- Load local configuration file if it exists
local conf = os.getenv("XENDEV_DIR") .. "/conf.local/lvim.lua"
local f = io.open(conf)
if f then
	io.close(f)
	dofile(conf)
end
