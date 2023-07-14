require 'albertocerrone.lazy'
require 'albertocerrone.set'
require 'albertocerrone.keymap'
require 'albertocerrone.util'

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})
-- Create a command `:Format` local to the LSP buffer
vim.api.nvim_create_user_command('Format', function(_)
  vim.lsp.buf.format()
end, { desc = 'Format current buffer with LSP' })

-- Automatically resize buffers
vim.api.nvim_command 'autocmd VimResized * wincmd ='
