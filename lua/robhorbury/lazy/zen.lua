return {
  "folke/zen-mode.nvim",
  config = function()
    vim.keymap.set("n", "<leader>zz", function()
      require("zen-mode").setup {
        window = {
          width = 105,
          options = {},
        },
      }
      require("zen-mode").toggle()
      vim.wo.wrap = false
      vim.wo.number = true
      vim.wo.rnu = true
      ColorMyPencils()
    end, { desc = "Zen mode" })

    vim.keymap.set("n", "<leader>zZ", function()
      require("zen-mode").setup {
        window = {
          width = 95,
          options = {},
        },
      }
      require("zen-mode").toggle()
      vim.wo.wrap = false
      vim.wo.number = false
      vim.wo.rnu = false
      vim.opt.colorcolumn = "0"
      ColorMyPencils()
    end, { desc = "Zen mode - no line numbers" })
  end,
}
