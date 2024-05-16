if vim.fn.exists 'g:os' == 0 then
  local is_windows = vim.fn.has 'win64' == 1 or vim.fn.has 'win32' == 1 or vim.fn.has 'win16' == 1
  if is_windows then
    Path = vim.fn.expand '%:p:h' .. '/lsp/windows/main.exe'
  else
    Path = '/Users/roberthorbury/.config/nvim' .. '/lsp/mac/main'
  end

  if not is_windows and is_windows then
    local client = vim.lsp.start_client {
      name = 'myfirstlsp',
      --cmd = { '/Users/roberthorbury/.config/nvim/lsp/mac/main' },
      cmd = { Path },
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
  end
end
