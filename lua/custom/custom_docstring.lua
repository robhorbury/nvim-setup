vim.keymap.set('n', '<leader>df', function()
  doc_string_desc = ' '
  local function split_outside_brackets(str)
    local result = {}
    local current = {}
    local depth = 0 -- Tracks nesting level of square brackets

    for i = 1, #str do
      local char = str:sub(i, i)

      if char == '[' then
        depth = depth + 1
      elseif char == ']' then
        depth = depth - 1
      end

      -- Always add the character to the current buffer (preserving brackets)
      table.insert(current, char)

      if char == ',' and depth == 0 then
        -- We've hit a comma outside brackets, store current item and reset
        current[#current] = nil -- Remove the comma before storing
        table.insert(result, table.concat(current))
        current = {}
      end
    end

    -- Add the last collected item
    if #current > 0 then
      table.insert(result, table.concat(current))
    end

    return result
  end

  local function remove_trailing_whitespace_line(str)
    return str:gsub('[%s\t\n\r]+$', '')
  end

  -- mark definition
  vim.api.nvim_command 'normal! mv'

  -- go to end of args:
  vim.api.nvim_command 'normal! f(%0Vj"ay'
  local return_check = vim.fn.getreg 'a'

  if string.find(return_check, '->') ~= nil then
    local function_def = vim.api.nvim_replace_termcodes("'v0/-><CR>/:<CR>$", true, false, true)
    vim.api.nvim_feedkeys(function_def, 'xn', false)
    vim.api.nvim_command 'mark b'
    vim.api.nvim_command 'normal! g_"ay\'v'
  else
    local function_def_1 = vim.api.nvim_replace_termcodes("'v0f(%", true, false, true)
    local function_def_2 = vim.api.nvim_replace_termcodes('g_"ay?def <CR><Esc>', true, false, true)
    vim.api.nvim_feedkeys(function_def_1, 'xn', false)
    vim.api.nvim_command 'mark b'
    vim.api.nvim_feedkeys(function_def_2, 'xn', false)
  end
  local function_def_str = vim.fn.getreg 'a'

  -- go to end of function def
  vim.api.nvim_command "normal! 'bj"

  local current_line = vim.api.nvim_get_current_line()

  -- go back to def
  vim.api.nvim_command "normal! 'v"

  if string.find(current_line, '"""') ~= nil then
    -- In this case we have a docstring
    vim.api.nvim_command "normal! 'v"
    local docstring_start = vim.api.nvim_replace_termcodes('/"""<CR><Esc>', true, false, true)
    vim.api.nvim_feedkeys(docstring_start, 'xn', false)
    vim.api.nvim_command 'normal! j0'

    local docstring_end = vim.api.nvim_replace_termcodes('"ay/"""<CR><Esc>', true, false, true)
    vim.api.nvim_feedkeys(docstring_end, 'xn', false)
    local docstring = vim.fn.getreg 'a'
    -- Check if we have 'Args:'

    if string.find(docstring, 'Args:') ~= nil then
      doc_string_desc = docstring:sub(1, string.find(docstring, 'Args:') - 1)
    elseif string.find(docstring, 'Returns:') ~= nil then
      doc_string_desc = docstring:sub(1, string.find(docstring, 'Returns:') - 1)
    else
      doc_string_desc = ' '
    end

    vim.api.nvim_command "normal! 'v"
    vim.api.nvim_feedkeys(docstring_start, 'xn', false)
    vim.api.nvim_command 'normal! 0j'
    local docstring_end_delete = vim.api.nvim_replace_termcodes('"_d/"""<CR><Esc>', true, false, true)
    vim.api.nvim_feedkeys(docstring_end_delete, 'xn', false)
    vim.api.nvim_command 'normal! Vk"_d\'v'
  else
    doc_string_desc = ' '
  end
  -- Yank args
  vim.api.nvim_command 'normal! 0"ayi('
  -- Now go back to end of function:
  vim.api.nvim_command "normal! 'b"
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
    vim.api.nvim_command "normal! 'b"
    local end_of_doc = vim.api.nvim_replace_termcodes('/"""<CR>', true, false, true)
    vim.api.nvim_feedkeys(end_of_doc, 'nx', false)
    vim.api.nvim_command 'normal! nkg_'
    -- vim.api.nvim_command 'normal! :noh'
    vim.api.nvim_command 'normal! o'
    vim.api.nvim_command 'normal! "qp'
    vim.api.nvim_command 'normal! 0weaReturns:'
    vim.api.nvim_command 'normal! 0w"_dtR'

    local returns_string_1 = string.gsub(string.gsub(function_def_str, '[\n\r\t]', ' '), ' ', '')
    local returns_string = returns_string_1:match('->(.*)'):gsub('[%s{}()]+', '')
    local return_list = {}

    for _, item in ipairs(split_outside_brackets(returns_string)) do
      item = string.match(item, '^[^:=]+') or item
      -- Remove all whitespace
      item = string.gsub(item, '%s+', '')
      item = string.gsub(item, ',', ', ')
      -- Append ':'
      table.insert(return_list, '\n' .. whitespace .. item .. ':')
    end

    -- Join the list
    local returns = table.concat(return_list, '')
    vim.fn.setreg('a', returns)
    vim.api.nvim_command 'normal! g_"ap'
  end
  if doc_string_desc ~= ' ' then
    vim.fn.setreg('r', doc_string_desc)
    doc_string_desc = remove_trailing_whitespace_line(doc_string_desc)
    vim.api.nvim_command "normal! 'bjj0"
    vim.fn.setreg('a', doc_string_desc)
    vim.api.nvim_command 'normal! "ap'
  end
  vim.api.nvim_command "normal! 'v"
  vim.api.nvim_command 'noh'
  vim.cmd [[ echon ' ' ]]
end)
