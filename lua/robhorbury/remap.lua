vim.keymap.set("n", "<leader>po", vim.cmd.Ex, { desc = "exit file" })
vim.keymap.set("n", "<leader>so", function()
  vim.cmd "so"
end, { desc = "Source file" })

vim.keymap.set({ "n" }, "<leader>ww", "<C-w>w")
vim.keymap.set("n", "<leader>wl", "<C-w>v")
vim.keymap.set("n", "<leader>wk", "<C-w>s")
vim.keymap.set("n", "<leader>wq", "<C-w>q")
vim.keymap.set("n", "<leader>wL", "<C-w>L")
vim.keymap.set("n", "<leader>wK", "<C-w>J")

vim.keymap.set("n", "<leader>o", "o<Esc>")
vim.keymap.set("n", "<leader>O", "O<Esc>")
vim.keymap.set("v", "p", '"_dP')
vim.keymap.set("i", "jj", "<Esc>", { desc = "Esc" })

vim.keymap.set("n", "<leader>d", '"_d')
vim.keymap.set("v", "<leader>d", '"_d')

vim.keymap.set("n", "<up>", ":resize -5<CR>")
vim.keymap.set("n", "<down>", ":resize +5<CR>")
vim.keymap.set("n", "<left>", ":vertical resize -5<CR>")
vim.keymap.set("n", "<right>", ":vertical resize +5<CR>")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("v", "R", function()
  -- Exit visual mode first so we can capture the visual selection correctly
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)

  -- Defer to allow <Esc> to take effect
  vim.schedule(function()
    local start_line = vim.fn.line "'<"
    local end_line = vim.fn.line "'>"

    local find_str = vim.fn.input "Find: "
    if find_str == "" then
      return
    end
    local replace_str = vim.fn.input "Replace: "

    -- Loop through lines in visual range and do replacement
    for lnum = start_line, end_line do
      local line = vim.fn.getline(lnum)
      local replaced = line:gsub(find_str, replace_str)
      if replaced ~= line then
        vim.fn.setline(lnum, replaced)
      end
    end

    vim.cmd "nohlsearch"
  end)
end, { silent = true })

vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

vim.keymap.set("n", "<leader>bg", function()
  ColorMyPencils(vim.g.colorscheme, not ThemeTransparency)
end)
