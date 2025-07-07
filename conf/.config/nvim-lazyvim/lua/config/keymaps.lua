-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- https://github.com/mrjones2014/smart-splits.nvim#key-mappings
-- resizing splits
vim.keymap.set("n", "<A-h>", require("smart-splits").resize_left, { desc = "smart resize left" })
vim.keymap.set("n", "<A-j>", require("smart-splits").resize_down, { desc = "smart resize down" })
vim.keymap.set("n", "<A-k>", require("smart-splits").resize_up, { desc = "smart resize up" })
vim.keymap.set("n", "<A-l>", require("smart-splits").resize_right, { desc = "smart resize right" })
-- moving between splits
vim.keymap.set("n", "<C-h>", require("smart-splits").move_cursor_left, { desc = "smart cursor left" })
vim.keymap.set("n", "<C-j>", require("smart-splits").move_cursor_down, { desc = "smart cursor down" })
vim.keymap.set("n", "<C-k>", require("smart-splits").move_cursor_up, { desc = "smart cursor up" })
vim.keymap.set("n", "<C-l>", require("smart-splits").move_cursor_right, { desc = "smart cursor right" })
vim.keymap.set("n", "<C-\\>", require("smart-splits").move_cursor_previous, { desc = "smart cursor prev" })
-- swapping buffers between windows
vim.keymap.set("n", "<leader><C-h>", require("smart-splits").swap_buf_left, { desc = "smart swap buffer left" })
vim.keymap.set("n", "<leader><C-j>", require("smart-splits").swap_buf_down, { desc = "smart swap buffer down" })
vim.keymap.set("n", "<leader><C-k>", require("smart-splits").swap_buf_up, { desc = "smart swap buffer up" })
vim.keymap.set("n", "<leader><C-l>", require("smart-splits").swap_buf_right, { desc = "smart swap buffer right" })
