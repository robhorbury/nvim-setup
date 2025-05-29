return {
  "danymat/neogen",
  version = "*",

  config = function()
    local neogen = require "neogen"

    neogen.setup {
      enabled = true,
      languages = {
        ["python.google_docstrings"] = require "neogen.configurations.python",
      },
    }

    vim.keymap.set("n", "<leader>dm", function()
      neogen.generate { type = "func" }
      local keymap_with_termcodes_replaced = vim.api.nvim_replace_termcodes("<Esc>mfV", true, false, true)
      vim.api.nvim_feedkeys(keymap_with_termcodes_replaced, "m", false)

      local keymap_with_termcodes_replaced_2 =
        vim.api.nvim_replace_termcodes('/"""<CR>:s/ ()//<CR>\'f', true, false, true)
      vim.api.nvim_feedkeys(keymap_with_termcodes_replaced_2, "m", false)
    end, { desc = "Document method" })
  end,
}
