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
    end, { desc = "Document method" })
  end,
}
