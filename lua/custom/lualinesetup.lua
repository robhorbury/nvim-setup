local git_blame = require 'gitblame'
-- This disables showing of the blame text next to the cursor
vim.g.gitblame_display_virtual_text = 0
vim.g.gitblame_date_format = '%x %X'
vim.g.gitblame_message_template = '<author> <date>'

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    disabled_filetypes = { statusline = {}, winbar = {} },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    },
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = { 'filename' },
    lualine_x = {
      'searchcount',
      {
        function()
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_get_option(buf, 'modified') then
              return '*' -- any message or icon
            end
          end
          return ''
        end,
      },
      'filetype',
    },
    lualine_y = { 'progress' },
    lualine_z = {
      function()
        if (vim.o.filetype ~= 'netrw') and git_blame.is_blame_text_available then
          return git_blame.get_current_blame_text()
        else
          return ''
        end
      end,
    },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {},
}
