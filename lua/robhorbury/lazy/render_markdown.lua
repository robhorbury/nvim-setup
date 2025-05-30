return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {},

  config = function()
    local markdown = require "render-markdown"
    markdown.setup {
      completions = { lsp = { enabled = false } },
    }

    vim.keymap.set("n", "<leader>md", function()
      markdown.buf_toggle()
    end, { desc = "Toggle markdown render" })
  end,
}
