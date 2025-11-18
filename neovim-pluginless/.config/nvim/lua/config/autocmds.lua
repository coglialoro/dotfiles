-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Flutter Hot Reload
vim.api.nvim_create_autocmd("BufWritePost", {
  desc = "Flutter Hot Reload",
  group = vim.api.nvim_create_augroup("flutter", { clear = true }),
  pattern = "*.dart",
  callback = function()
    vim.cmd(":silent !kill -SIGUSR1 $(pgrep flutter)")
  end,
})
