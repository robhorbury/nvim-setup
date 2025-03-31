if vim.fn.has 'win32' then
  local bash_options = {
    shell = 'bash.exe',
    shellcmdflag = '--login -i -c',
    shellredir = '',
    shellpipe = '2>&1',
    shellquote = '',
    shellxquote = '',
  }

  for option, value in pairs(bash_options) do
    vim.opt[option] = value
  end
end
