return {
  "tpope/vim-fugitive",
  branch = "master",

  config = function()
    vim.keymap.set("n", "<leader>ga", function()
      vim.cmd "G add ."
    end, { desc = "git add" })

    vim.keymap.set("n", "<leader>g", function()
      vim.cmd "G"
    end, { desc = "git" })

    vim.keymap.set("n", "<leader>gb", function()
      vim.cmd "G blame"
    end, { desc = "git blame" })

    vim.keymap.set("n", "<leader>gl", function()
      vim.cmd "G log --oneline --all --decorate --graph -50"
    end, { desc = "git log" })

    vim.keymap.set("n", "<leader>gr", function()
      vim.cmd "G reflog"
    end, { desc = "git reflog" })

    vim.keymap.set("n", "<leader>p[", function()
      vim.cmd "G add ."
      vim.cmd "G commit -a"
    end, { desc = "git add and commit" })

    vim.keymap.set("n", "<leader>p]", function()
      vim.cmd "G add ."
      vim.cmd "G commit -a --amend --no-edit"
    end, { desc = "git add and amend last commit" })

    vim.keymap.set("n", "<leader>pl", function()
      vim.cmd "G fetch -p"
      vim.cmd "G pull --rebase"
    end, { desc = "git pull rebase" })

    vim.keymap.set("n", "<leader>pp", function()
      vim.cmd "G push"
    end, { desc = "git push" })
  end,
}
