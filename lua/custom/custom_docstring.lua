vim.keymap.set('n', '<leader>df', function()
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
