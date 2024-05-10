local client = vim.lsp.start_client {
  name = 'myfirstlsp',
  cmd = { '/Users/roberthorbury/.config/nvim/lsp/mac/main' },
}

if not client then
  vim.notify 'error in client'
  return
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'python',
  callback = function()
    vim.lsp.buf_attach_client(0, client)
  end,
})
