vim.g.mapleader = ' '
vim.keymap.set('n', '<leader>po', vim.cmd.Ex)
vim.keymap.set('n', '<leader>so', function()
  vim.cmd 'so'
end)

vim.api.nvim_set_keymap('t', '<ESC>', '<C-\\><C-n>', { noremap = true })

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

-- vim.keymap.set('n', '<leader>e', function()
--   harpoon.ui:toggle_quick_menu(harpoon:list())
-- end)

vim.keymap.set('n', '<C-h>', function()
  harpoon:list():select(1)
end)
vim.keymap.set('n', '<C-j>', function()
  harpoon:list():select(2)
end)
vim.keymap.set('n', '<C-k>', function()
  harpoon:list():select(3)
end)
vim.keymap.set('n', '<C-l>', function()
  harpoon:list():select(4)
end)

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set('n', '<C-S-J>', function()
  harpoon:list():prev()
end)
vim.keymap.set('n', '<C-S-K>', function()
  harpoon:list():next()
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

vim.keymap.set('n', '<leader>p]', function()
  vim.cmd 'G add .'
  vim.cmd 'G commit -a --amend --no-edit'
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

vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)

-- basic telescope configuration
local conf = require('telescope.config').values
local function toggle_telescope(harpoon_files)
  local file_paths = {}
  for _, item in ipairs(harpoon_files.items) do
    table.insert(file_paths, item.value)
  end

  require('telescope.pickers')
    .new({}, {
      prompt_title = 'Harpoon',
      finder = require('telescope.finders').new_table {
        results = file_paths,
      },
      previewer = conf.file_previewer {},
      sorter = conf.generic_sorter {},
    })
    :find()
end

vim.keymap.set('n', '<leader>e', function()
  toggle_telescope(harpoon:list())
end, { desc = 'Open harpoon window' })
