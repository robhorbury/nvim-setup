vim.cmd 'set colorcolumn=100'

local o = vim.o

o.expandtab = true
o.smartindent = true
o.tabstop = 4
o.shiftwidth = 4

vim.cmd 'set foldmethod=indent'
local keymap = vim.api.nvim_replace_termcodes('zR', true, false, true)
vim.api.nvim_feedkeys(keymap, 'n', false)

vim.keymap.set('n', '<leader>yf', '')

vim.keymap.set('n', '<leader>yf', function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  local yank_func = vim.api.nvim_replace_termcodes('zAV?def<CR>yzR', true, false, true)
  vim.api.nvim_feedkeys(yank_func, 'n', false)
  local line_jump = vim.api.nvim_replace_termcodes(':' .. tostring(line) .. '<CR>', true, false, true)
  vim.api.nvim_feedkeys(line_jump, 'n', false)
  local row_jump = vim.api.nvim_replace_termcodes(tostring(col) .. 'l', true, false, true)
  vim.api.nvim_feedkeys(row_jump, 'n', false)
  local clear_ref = vim.api.nvim_replace_termcodes(':<BS>', true, false, true)
  vim.api.nvim_feedkeys(clear_ref, 'n', false)
end)

vim.keymap.set('n', '<leader>yi', function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  local yank_func = vim.api.nvim_replace_termcodes('zaV?:<CR>yzR', true, false, true)
  vim.api.nvim_feedkeys(yank_func, 'n', false)
  local line_jump = vim.api.nvim_replace_termcodes(':' .. tostring(line) .. '<CR>', true, false, true)
  vim.api.nvim_feedkeys(line_jump, 'n', false)
  local row_jump = vim.api.nvim_replace_termcodes(tostring(col) .. 'l', true, false, true)
  vim.api.nvim_feedkeys(row_jump, 'n', false)
  local clear_ref = vim.api.nvim_replace_termcodes(':<BS>', true, false, true)
  vim.api.nvim_feedkeys(clear_ref, 'n', false)
end)
