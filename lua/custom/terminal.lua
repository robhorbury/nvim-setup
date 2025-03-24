local uname = vim.loop.os_uname()

_G.OS = uname.sysname
_G.IS_MAC = OS == 'Darwin'
_G.IS_LINUX = OS == 'Linux'
_G.IS_WINDOWS = OS:find 'Windows' and true or false
_G.IS_WSL = IS_LINUX and uname.release:find 'Microsoft' and true or false

if _G.IS_WINDOWS then
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

vim.keymap.set('t', '<esc>', [[<C-\><C-n>]])
vim.keymap.set('n', '<leader>q', 'i<C-d>')
vim.keymap.set('t', 'jj', [[<C-\><C-n>]])
vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]])
vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]])
vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]])
vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]])
vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]])

vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    vim.cmd 'ToggleTerm size=15 dir=git_dir direction=horizontal'
    vim.cmd 'ToggleTermToggleAll'
  end,
})

vim.keymap.set('n', '<leader>tk', '<cmd>ToggleTerm size=15 dir=git_dir direction=horizontal<cr>')
vim.keymap.set('n', '<leader>tl', '<cmd>ToggleTerm size=70 dir=git_dir direction=vertical<cr>')
vim.keymap.set('n', '<leader>tj', '<cmd>ToggleTerm dir=git_dir direction=float<cr>')

vim.keymap.set('n', '<leader>tt', '<cmd>ToggleTermToggleAll<cr>')
vim.keymap.set('n', '<leader>ts', '<cmd>TermSelect<cr>')
vim.keymap.set('n', '<leader>tn', '<cmd>TermNew<cr>')
