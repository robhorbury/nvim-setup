vim.g.mapleader = ' '
vim.keymap.set('n', '<leader>po', vim.cmd.Ex)
vim.keymap.set('n', '<leader>so', function()
  vim.cmd 'so'
end)

local o = vim.o

o.expandtab = true
o.smartindent = true
o.tabstop = 4
o.shiftwidth = 4

local harpoon = require 'harpoon'
harpoon:setup()

vim.keymap.set('n', '<leader>a', function()
  harpoon:list():add()
end)

vim.keymap.set('n', '<leader>e', function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end)

vim.keymap.set('n', 'oo', 'o<Esc>')
vim.keymap.set('n', 'OO', 'O<Esc>')

vim.keymap.set('n', '<leader>ga', function()
  vim.cmd 'G add .'
end)

vim.keymap.set('n', '<leader>g', function()
  vim.cmd 'G'
end)

vim.keymap.set('n', '<leader>p[', function()
  vim.cmd 'w'
  vim.cmd 'G add .'
  vim.cmd 'G commit -a'
end)

vim.keymap.set('n', '<leader>pl', function()
  vim.cmd 'G fetch'
  vim.cmd 'G pull'
end)
