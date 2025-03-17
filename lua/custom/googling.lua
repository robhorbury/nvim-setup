vim.keymap.set('v', '<leader>gl', function()
  -- Yank selection into register 'g'
  vim.api.nvim_feedkeys('"gy', 'v', false)

  -- Get the yanked text from register 'g'
  local search = vim.fn.getreg 'g'

  -- Trim leading/trailing whitespace and newlines
  search = search:gsub('^%s+', ''):gsub('%s+$', ''):gsub('\n', ' ')

  -- Properly escape quotes
  search = search:gsub('"', ''):gsub("'", '')

  -- Construct the Google search URL
  local search_string = 'Open "https://google.com/search?q=' .. search .. ' &"'

  -- Execute the command in a terminal
  vim.api.nvim_command("TermExec cmd='" .. search_string .. "'")
end)

vim.keymap.set('x', '<leader>gl', function()
  -- Yank selection into register 'g'
  vim.api.nvim_feedkeys('"gy', 'x', false)

  -- Get the yanked text from register 'g'
  local search = vim.fn.getreg 'g'

  -- Trim leading/trailing whitespace and newlines
  search = search:gsub('^%s+', ''):gsub('%s+$', ''):gsub('\n', ' ')

  -- Properly escape quotes
  search = search:gsub('"', ''):gsub("'", '')

  -- Construct the Google search URL
  local search_string = 'Open "https://google.com/search?q=' .. search .. ' &"'

  -- Execute the command in a terminal
  vim.api.nvim_command("TermExec cmd='" .. search_string .. "'")
end)

vim.keymap.set('n', '<leader>gl', function()
  vim.api.nvim_command 'TermExec cmd=\'Open "https://google.com/"\''
end)
