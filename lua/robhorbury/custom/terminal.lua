if vim.fn.has 'win32' == 1 then
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
elseif vim.fn.has 'unix' == 1 then
  local bash_options = {
    shell = '/bin/bash',
    shellcmdflag = '-c',
    shellredir = '>%s 2>&1',
    shellpipe = '2>&1| tee',
    shellquote = '',
    shellxquote = '',
  }

  for option, value in pairs(bash_options) do
    vim.opt[option] = value
  end
end

