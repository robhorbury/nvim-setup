local embedded_sql = vim.treesitter.query.parse(
  'python',
  [[
  (call
  function: (attribute) @name (#eq? @name "spark.sql")
  (argument_list
    (string 
      (string_content) @sql)))
]]
)

local get_root = function(bufnr)
  local parser = vim.treesitter.get_parser(bufnr, 'python', {})
  local tree = parser:parse()[1]
  return tree:root()
end

local format_sql = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  if vim.bo[bufnr].filetype ~= 'python' then
    vim.notify 'Can only be used in python'
    return
  end
  local root = get_root(bufnr)
  local changes = {}

  for id, node in embedded_sql:iter_captures(root, bufnr, 0, -1) do
    local name = embedded_sql.captures[id]
    if name == 'spark.sql' then
      local range = { node:range() }
      local indentation = string.rep(' ', range[2])

      local formatted = run_formatter(vim.treesitter.get_node_text(node, bufnr))

      for idx, line in ipairs(formatted) do
        formatted[idx] = indentation .. line
      end

      table.insert(changes, 1, {
        start = range[1] + 1,
        final = range[3],
        formatted = formatted,
      })
    end
  end

  for _, change in ipairs(changes) do
    vim.api.nvim_buf_set_lines(bufnr, change.start, change.final, false, change.formatted)
  end
end

vim.api.nvim_create_user_command('SqlMagic', function()
  format_sql()
end, {})
