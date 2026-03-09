local function send(text)
  local job_id = require("aider").aider_job_id
  if not job_id then
    vim.notify("Aider: not running — open it first", vim.log.levels.WARN)
    return
  end
  vim.fn.chansend(job_id, text .. "\n")
end

local function toggle(window_type)
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].filetype == "AiderConsole" then
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_buf(win) == buf then
          vim.api.nvim_win_close(win, false)
          return
        end
      end
      break
    end
  end
  require("aider").AiderOpen("", window_type or "vsplit")
end

local function current_file()
  return vim.fn.expand("%:.")
end

local function visual_selection()
  local s = vim.fn.getpos("'<")
  local e = vim.fn.getpos("'>")
  local lines = vim.api.nvim_buf_get_lines(0, s[2] - 1, e[2], false)
  if #lines == 0 then
    return ""
  end
  if vim.fn.visualmode() == "v" then
    lines[#lines] = lines[#lines]:sub(1, math.min(e[3], #lines[#lines]))
    lines[1] = lines[1]:sub(s[3])
  end
  return table.concat(lines, "\n")
end

return {
  {
    "joshuavial/aider.nvim",
    cond = function()
      return vim.fn.executable("aider") == 1
    end,
    opts = {
      auto_manage_context = true,
      default_bindings = false,
    },
    keys = {
      { "<leader>aD", "", desc = "+aider", mode = { "n", "v" } },

      {
        "<leader>aDo",
        function()
          toggle("vsplit")
        end,
        desc = "Toggle vsplit",
      },
      {
        "<leader>aDf",
        function()
          toggle("editor")
        end,
        desc = "Toggle float",
      },

      {
        "<leader>aDa",
        function()
          send("/add " .. current_file())
        end,
        desc = "Add file",
      },
      {
        "<leader>aDr",
        function()
          send("/read-only " .. current_file())
        end,
        desc = "Add file (readonly)",
      },
      {
        "<leader>aDd",
        function()
          send("/drop " .. current_file())
        end,
        desc = "Drop file",
      },
      { "<leader>aDm", "<cmd>AiderAddModifiedFiles<CR>", desc = "Add modified files" },
      {
        "<leader>aDB",
        function()
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            local name = vim.api.nvim_buf_get_name(buf)
            if vim.bo[buf].buflisted and name ~= "" and vim.fn.filereadable(name) == 1 then
              send("/add " .. vim.fn.fnamemodify(name, ":."))
            end
          end
        end,
        desc = "Add all buffers",
      },
      {
        "<leader>aDR",
        function()
          send("/reset")
        end,
        desc = "Reset session",
      },

      {
        "<leader>aDs",
        function()
          local path = vim.fn.expand("%:.")
          local sl, el = vim.fn.line("'<"), vim.fn.line("'>")
          local ft = vim.bo.filetype
          local sel = visual_selection()
          send(("# File: %s (lines %d-%d)\n```%s\n%s\n```"):format(path, sl, el, ft, sel))
        end,
        desc = "Send selection",
        mode = "v",
      },
      {
        "<leader>aDx",
        function()
          local diags = vim.diagnostic.get(0)
          if #diags == 0 then
            vim.notify("Aider: no diagnostics in current buffer", vim.log.levels.INFO)
            return
          end
          local sev = { "ERROR", "WARN", "INFO", "HINT" }
          local lines = { "Fix these diagnostics in " .. current_file() .. ":" }
          for _, d in ipairs(diags) do
            table.insert(lines, ("  line %d [%s]: %s"):format(d.lnum + 1, sev[d.severity] or "?", d.message))
          end
          send(table.concat(lines, "\n"))
        end,
        desc = "Send diagnostics",
      },
      {
        "<leader>aDp",
        function()
          send("/paste")
        end,
        desc = "Paste clipboard",
      },

      {
        "<leader>aDc",
        function()
          send("/chat-mode code")
        end,
        desc = "Code mode",
      },
      {
        "<leader>aDt",
        function()
          send("/chat-mode architect")
        end,
        desc = "Architect mode",
      },

      {
        "<leader>aDu",
        function()
          send("/undo")
        end,
        desc = "Undo",
      },
      {
        "<leader>aDl",
        function()
          send("/clear")
        end,
        desc = "Clear history",
      },
    },
  },
}
