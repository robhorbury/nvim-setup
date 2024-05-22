local M = {}

local orig_diag_virt_handler = vim.diagnostic.handlers.virtual_text
local ns = vim.api.nvim_create_namespace 'my_diagnostics'

local filter_diagnostics = function(diagnostics, on)
  local filtered_diag = {}
  for _, d in ipairs(diagnostics) do
    if d.message ~= "undefined name 'spark'" and d.message ~= "undefined name 'dbutils'" and not string.find(d.message, 'display') and on == true then
      table.insert(filtered_diag, 1, d)
    elseif on == false then
      table.insert(filtered_diag, 1, d)
    end
  end
  return filtered_diag
end

M.spark_filter = function(on)
  -- hide all diagnostics
  vim.diagnostic.hide(nil, 0)

  -- vim.diagnostic.reset()
  vim.diagnostic.handlers.virtual_text = {
    show = function(_, bufnr, _, opts)
      -- get all diagnostics for local buffer
      local diagnostics = vim.diagnostic.get(bufnr)
      filtered = filter_diagnostics(diagnostics, on)
      -- filter diags based on severity
      orig_diag_virt_handler.show(ns, bufnr, filtered, opts)
    end,
    hide = function(_, bufnr)
      orig_diag_virt_handler.hide(ns, bufnr)
    end,
  }

  bufnr = vim.api.nvim_get_current_buf()
  local diags = vim.diagnostic.get(bufnr)
  if #diags > 0 then
    filtered = filter_diagnostics(diags, on)
    vim.diagnostic.show(ns, bufnr, filtered)
  end
end

return M
