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
  if vim.fn.has 'win32' then
    local search_string = 'start https://google.com/search?q=' .. search
    vim.api.nvim_command('TermExec cmd="' .. search_string .. '"')
  else
    local search_string = 'Open "https://google.com/search?q=' .. search .. ' &"'
    vim.api.nvim_command("TermExec cmd='" .. search_string .. "'")
  end
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
  if vim.fn.has 'win32' then
    vim.api.nvim_command 'TermExec cmd="start https://google.com/"'
    vim.api.nvim_command 'ToggleTermToggleAll'
  else
    vim.api.nvim_command 'TermExec cmd=\'Open "https://google.com/"\''
  end
end)
