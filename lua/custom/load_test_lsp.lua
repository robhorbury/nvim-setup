local client = vim.lsp.start_client {
  name = 'db_notebook_lsp',
  cmd = { vim.fn.expand '%:p' .. 'lsp/db_notebook_lsp' },
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
