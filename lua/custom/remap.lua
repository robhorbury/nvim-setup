vim.g.mapleader = ' '
vim.keymap.set('n', '<leader>po', vim.cmd.Ex)
vim.keymap.set('n', '<leader>so', function()
  vim.cmd 'so'
end)

vim.api.nvim_set_keymap('t', '<ESC>', '<C-\\><C-n>', { noremap = true })

vim.keymap.set('n', '<leader>dc', function()
  -- mark definition
  vim.api.nvim_command 'normal! mv'

  -- go to end of args:
  vim.api.nvim_command 'normal! f(%0Vj"ay'
  local return_check = vim.fn.getreg 'a'
  if string.find(return_check, '->') ~= nil then
    local function_def = vim.api.nvim_replace_termcodes("'v0/-><CR>/:<CR>j", true, false, true)
    local function_def_2 = vim.api.nvim_replace_termcodes('"ay?def <CR><Esc>', true, false, true)
    vim.api.nvim_feedkeys(function_def, 'xn', false)
    vim.api.nvim_command 'mark b'
    vim.api.nvim_command 'normal! kg_'
    vim.api.nvim_feedkeys(function_def_2, 'xn', false)
  else
    local function_def = vim.api.nvim_replace_termcodes('\'v0/):<CR>j mb k g_ "ay?def <CR><Esc>', true, false, true)
    vim.api.nvim_feedkeys(function_def, 'xn', false)
  end
  local function_def_str = vim.fn.getreg 'a'

  -- go to end of function def
  vim.api.nvim_command "normal! 'b"

  local current_line = vim.api.nvim_get_current_line()

  -- go back to def
  vim.api.nvim_command "normal! 'v"

  if string.find(current_line, '"""') ~= nil then
    vim.api.nvim_command 'normal! j'
  else
    -- Yank args
    vim.api.nvim_command 'normal! k0"ayi('
    -- Now go back to end of function:
    vim.api.nvim_command "normal! 'bk"
    --
    vim.api.nvim_command 'normal! o"""'
    vim.api.nvim_command 'normal! "qyy'
    vim.api.nvim_command 'normal! "qpk'
    vim.api.nvim_command 'normal! o'
    vim.api.nvim_command 'normal! o'
    vim.api.nvim_command 'normal! "qp'
    vim.api.nvim_command 'normal! 0weaArgs:'
    vim.api.nvim_command 'normal! 0w"_dtA'
    local args_line = vim.api.nvim_get_current_line()
    local _, indent_count = string.find(args_line, '^%s*')
    local whitespace = string.rep(' ', indent_count + 4)

    -- Handle args now:
    local args = string.gsub(string.gsub(vim.fn.getreg 'a', '[\n\r\t]', ' '), ' ', '')
    if string.len(args) > 0 then
      local arg_list = {}

      for item in string.gmatch(args, '([^,]+)') do
        -- Remove everything after ':' or '=' if present
        item = string.match(item, '^[^:=]+') or item
        -- Remove all whitespace
        item = string.gsub(item, '%s+', '')
        -- Append ':'
        table.insert(arg_list, '\n' .. whitespace .. item .. ':')
      end

      -- Join the list
      local result = table.concat(arg_list, '')

      -- Store the result back into the register or print it
      vim.fn.setreg('a', result)
      vim.api.nvim_command 'normal! g_"ap'
    else
      vim.api.nvim_command 'normal! "_ddkdd'
    end

    -- Handle returns now
    --
    if string.find(function_def_str, '->') ~= nil then
      vim.api.nvim_command "normal! 'bkO"
      -- local end_of_doc = vim.api.nvim_replace_termcodes('/"""<CR>', true, false, true)
      -- vim.api.nvim_feedkeys(end_of_doc, 'n', false)
      -- vim.api.nvim_command 'normal! :noh'
      vim.api.nvim_command 'normal! "qp'
      vim.api.nvim_command 'normal! 0weaReturns:'
      vim.api.nvim_command 'normal! 0w"_dtR'

      local returns_string_1 = string.gsub(string.gsub(function_def_str, '[\n\r\t]', ' '), ' ', '')
      local returns_string = returns_string_1:match('->(.*)'):gsub('[%s%[%]{}()]+', '')
      local return_list = {}

      for item in string.gmatch(returns_string, '([^,]+)') do
        -- Remove everything after ':' or '=' if present
        -- item = string.match(item, '^[^:=]+') or item
        -- Remove all whitespace
        item = string.gsub(item, '%s+', '')
        -- Append ':'
        table.insert(return_list, '\n' .. whitespace .. item .. ':')
      end

      -- Join the list
      local returns = table.concat(return_list, '')
      vim.fn.setreg('a', returns)
      vim.api.nvim_command 'normal! g_"ap'
    end
  end

  vim.api.nvim_command "normal! 'v"
  vim.api.nvim_command 'noh'
  vim.cmd [[ echon ' ' ]]
end)

local harpoon = require 'harpoon'
harpoon:setup()

vim.keymap.set({ 'n' }, '<leader>ww', '<C-w>w')
vim.keymap.set('n', '<leader>wl', '<C-w>v')
vim.keymap.set('n', '<leader>wk', '<C-w>s')
vim.keymap.set('n', '<leader>wq', '<C-w>q')
vim.keymap.set('n', '<leader>wL', '<C-w>L')
vim.keymap.set('n', '<leader>wK', '<C-w>J')

vim.keymap.set('n', '<leader>a', function()
  harpoon:list():add()
end)

vim.keymap.set('n', '<leader>e', function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end)

vim.keymap.set('n', '<leader>o', 'o<Esc>')
vim.keymap.set('n', '<leader>O', 'O<Esc>')
vim.keymap.set('v', 'p', '"_dP')
vim.keymap.set('i', 'jj', '<Esc>', { desc = 'Esc' })

vim.keymap.set('n', '<leader>d', '"_d')
vim.keymap.set('v', '<leader>d', '"_d')

vim.keymap.set('n', '<leader>ga', function()
  vim.cmd 'G add .'
end)

vim.keymap.set('n', '<leader>g', function()
  vim.cmd 'G'
end)

vim.keymap.set('n', '<leader>gb', function()
  vim.cmd 'G fetch -p'
  vim.cmd 'G pull'
  vim.cmd 'G branch -a'
end)

vim.keymap.set('n', '<leader>p[', function()
  vim.cmd 'G add .'
  vim.cmd 'G commit -a'
end)

vim.keymap.set('n', '<leader>pl', function()
  vim.cmd 'G fetch -p'
  vim.cmd 'G pull'
end)

vim.keymap.set('n', '<leader>pp', function()
  vim.cmd 'G push'
end)

vim.keymap.set('n', '<up>', ':resize -5<CR>')
vim.keymap.set('n', '<down>', ':resize +5<CR>')
vim.keymap.set('n', '<left>', ':vertical resize -5<CR>')
vim.keymap.set('n', '<right>', ':vertical resize +5<CR>')

vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

vim.keymap.set('n', '<leader>v', '0vg_')
vim.keymap.set('n', '<leader>tt', ':vsplit +term<CR>')

vim.keymap.set('v', '/', '*N<Esc>')

local function set_diangnostics_keymap(on)
  local dfilter = require 'custom.diagnostic_filter'
  dfilter.spark_filter(on)
end

vim.keymap.set('n', '<leader>nn', function()
  set_diangnostics_keymap(false)
end)

vim.keymap.set('n', '<leader>ne', function()
  set_diangnostics_keymap(true)
end)

vim.keymap.set('n', '<leader>di', function()
  vim.cmd 'Gvdiffsplit HEAD'
  local keys = vim.api.nvim_replace_termcodes('<C-w>p', false, false, true)
  vim.api.nvim_feedkeys(keys, 'n', true)
end)
