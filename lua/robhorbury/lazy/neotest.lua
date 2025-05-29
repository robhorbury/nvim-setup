return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/nvim-nio",
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-go",
    },
    config = function()
      require("neotest").setup {
        adapters = {
          require "neotest-python" {
            dap = { justMyCode = false }, -- optional: for debugging
            runner = "pytest", -- use pytest
          },
          require "neotest-go",
        },
      }

      local map = vim.keymap.set
      map("n", "<leader>tt", function()
        require("neotest").run.run()
      end, { desc = "Run nearest test" })
      map("n", "<leader>tf", function()
        require("neotest").run.run(vim.fn.expand "%")
      end, { desc = "Run file tests" })
      map("n", "<leader>ts", function()
        require("neotest").summary.toggle()
      end, { desc = "Toggle test summary" })
      map("n", "<leader>to", function()
        require("neotest").output.open { enter = true }
      end, { desc = "Show test output" })
    end,
  },
}
