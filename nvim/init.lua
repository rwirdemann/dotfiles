-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
vim.opt.spelllang = { "de", "en" }

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "text", "gitcommit", "tex" },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = { "de", "en" }
  end,
})
