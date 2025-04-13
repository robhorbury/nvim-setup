return {
  "tpope/vim-fugitive",
  branch = "master",

  config = function()
    vim.keymap.set("n", "<leader>ga", function()
      vim.cmd "G add ."
    end)

    vim.keymap.set("n", "<leader>g", function()
      vim.cmd "G"
    end)

    vim.keymap.set("n", "<leader>gb", function()
      vim.cmd "G fetch -p"
      vim.cmd "G branch -a"
    end)

    vim.keymap.set("n", "<leader>p[", function()
      vim.cmd "G add ."
      vim.cmd "G commit -a"
    end)

    vim.keymap.set("n", "<leader>p]", function()
      vim.cmd "G add ."
      vim.cmd "G commit -a --amend --no-edit"
    end)

    vim.keymap.set("n", "<leader>pl", function()
      vim.cmd "G fetch -p"
      vim.cmd "G pull --rebase"
    end)

    vim.keymap.set("n", "<leader>pp", function()
      vim.cmd "G push"
    end)

    vim.keymap.set("n", "<leader>di", function()
      vim.cmd "Gvdiffsplit HEAD"
      local keys = vim.api.nvim_replace_termcodes("<C-w>p", false, false, true)
      vim.api.nvim_feedkeys(keys, "n", true)
    end)
  end,
}
