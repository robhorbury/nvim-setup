function ShowFunctionContextPopup()
  local ts_utils = require "nvim-treesitter.ts_utils"
  local node = ts_utils.get_node_at_cursor()

  local function is_call_node(n)
    local t = n:type()
    return t == "call" or t == "function_call" or t == "call_expression"
  end

  local function show_popup_with_lines(lines)
    -- 1) Create a new scratch buffer
    local buf = vim.api.nvim_create_buf(false, true)

    -- 2) Set buffer-local options (keep it modifiable for now)
    vim.bo[buf].filetype = vim.bo.filetype
    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].bufhidden = "wipe"

    -- 3) Write all lines into the buffer
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    -- 4) Now make it non-modifiable
    vim.bo[buf].modifiable = false

    -- 5) Compute maximum popup width (75% of total columns)
    local max_width = math.floor(vim.o.columns * 0.75)

    -- 6) Find the widest line’s display width
    local content_disp_width = 0
    for _, line in ipairs(lines) do
      -- strdisplaywidth accounts for tabs, wide chars, etc.
      local dw = vim.fn.strdisplaywidth(line)
      if dw > content_disp_width then
        content_disp_width = dw
      end
    end

    -- 7) The popup’s total width is either content_disp_width+4 or capped at max_width
    local total_width = math.min(content_disp_width + 4, max_width)

    -- 8) To wrap correctly, the text area width is total_width - padding (4 chars)
    local text_width = total_width - 4
    if text_width < 10 then
      text_width = 10 -- ensure a minimum text area width
    end

    -- 9) Compute the required popup height by summing how many wrapped lines each original line needs
    local total_lines_needed = 0
    for _, line in ipairs(lines) do
      local dw = vim.fn.strdisplaywidth(line)
      local wraps = math.ceil(dw / text_width)
      total_lines_needed = total_lines_needed + math.max(1, wraps)
    end

    -- 10) Now we have both width and height
    local win_opts = {
      relative = "cursor",
      width = total_width,
      height = total_lines_needed,
      col = 1,
      row = 1,
      style = "minimal",
      border = "rounded",
    }

    -- 11) Open the floating window
    local win = vim.api.nvim_open_win(buf, false, win_opts)

    -- 12) Disable folding in that window
    vim.api.nvim_win_set_option(win, "foldenable", false)
    -- 13) Enable wrapping and break at word boundaries
    vim.api.nvim_win_set_option(win, "wrap", true)
    vim.api.nvim_win_set_option(win, "linebreak", true)

    -- 14) Auto-close the popup on any cursor move
    vim.cmd(string.format(
      [[
      autocmd CursorMoved * ++once lua vim.api.nvim_win_close(%d, true)
    ]],
      win
    ))
  end

  local function show_signature_help()
    vim.lsp.buf_request(
      0,
      "textDocument/signatureHelp",
      vim.lsp.util.make_position_params(),
      function(err, result, ctx, _)
        if err or not result or not result.signatures or #result.signatures == 0 then
          vim.notify("No signature info available", vim.log.levels.INFO)
          return
        end

        local sig = result.signatures[1]
        -- Split on newline so we preserve formatting
        local lines = vim.split(sig.label, "\n", { trimempty = true })
        show_popup_with_lines(lines)
      end
    )
  end

  local function show_function_definition_params(n)
    while n do
      local t = n:type()
      -- Catch anything that looks like a function-definition node
      if t:match "function" or t:match "method" or t == "function_definition" or t == "function_declaration" then
        for i = 0, n:child_count() - 1 do
          local child = n:child(i)
          if child and child:type():match "parameters" then
            -- Get the lines of the parameter node exactly, preserving newlines
            local sr, _, er, _ = child:range()
            local lines = vim.api.nvim_buf_get_lines(0, sr, er + 1, false)
            show_popup_with_lines(lines)
            return
          end
        end
      end
      n = n:parent()
    end
    vim.notify("No function definition found", vim.log.levels.INFO)
  end

  -- 1) First, look for a function call under the cursor
  local call_node = node
  while call_node and not is_call_node(call_node) do
    call_node = call_node:parent()
  end

  if call_node then
    -- If we found a call node anywhere above the cursor, show its signature
    show_signature_help()
  else
    -- Otherwise, show the current function’s parameters (definition scope)
    show_function_definition_params(node)
  end
end

-- Create a :ShowFunctionContext command and a <leader>fu mapping
vim.api.nvim_create_user_command("ShowFunctionContext", ShowFunctionContextPopup, {})
vim.keymap.set("n", "F", ShowFunctionContextPopup, { desc = "Show function usage or definition" })
