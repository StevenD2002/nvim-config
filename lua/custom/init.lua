-- local autocmd = vim.api.nvim_create_autocmd

vim.g.copilot_assume_mapped = true
vim.opt.scrolloff = 10
--
-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })
-- Define the function for formatting
function run_formatting()
  local current_file = vim.fn.expand "%:p"
  local current_directory = vim.fn.expand "%:p:h"

  -- Check if the file has a .templ extension
  if vim.fn.match(current_file, ".templ$") > 0 then
    -- Run templ formatter for .templ files in the current directory
    vim.fn.system("templ fmt " .. current_directory)
  else
    -- Run your LSP formatter for other file types
    vim.lsp.buf.format { async = true }
  end

  -- Reload the current buffer to see the changes
  vim.cmd "e"
end

-- Map the formatting function to the BufWritePost autocommand
vim.api.nvim_exec(
  [[
  augroup FormatOnSave
    autocmd!
    autocmd BufWritePost * lua run_formatting()
  augroup END
]],
  false
)
