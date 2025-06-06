return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },

  config = function()
    local harpoon = require "harpoon"
    harpoon:setup()

    vim.keymap.set("n", "<leader>w", function()
      harpoon:list():add()
    end, { desc = "Harpoon: Append file" })
    vim.keymap.set("n", "<leader>W", function()
      harpoon:list():prepend()
    end, { desc = "Harpoon: Prepend file" })
    vim.keymap.set("n", "<leader>z", function()
      harpoon:list():remove()
    end, { desc = "Harpoon: Remove file" })

    -- vim.keymap.set('n', '<leader>e', function()
    --   harpoon.ui:toggle_quick_menu(harpoon:list())
    -- end)

    vim.keymap.set("n", "<leader>a", function()
      harpoon:list():select(1)
    end, { desc = "Harpoon: Select file 1" })
    vim.keymap.set("n", "<leader>s", function()
      harpoon:list():select(2)
    end, { desc = "Harpoon: Select file 2" })
    vim.keymap.set("n", "<leader>d", function()
      harpoon:list():select(3)
    end, { desc = "Harpoon: Select file 3" })
    vim.keymap.set("n", "<leader>f", function()
      harpoon:list():select(4)
    end, { desc = "Harpoon: Select file 4" })

    vim.keymap.set("n", "<leader>A", function()
      harpoon:list():replace_at(1)
    end, { desc = "Harpoon: Replace file 1" })
    vim.keymap.set("n", "<leader>S", function()
      harpoon:list():replace_at(2)
    end, { desc = "Harpoon: Replace file 2" })
    vim.keymap.set("n", "<leader>D", function()
      harpoon:list():replace_at(3)
    end, { desc = "Harpoon: Replace file 3" })
    vim.keymap.set("n", "<leader>F", function()
      harpoon:list():replace_at(4)
    end, { desc = "Harpoon: Replace file 4" })

    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set("n", "<leader>[", function()
      harpoon:list():prev()
    end, { desc = "Harpoon: Go to previous file" })
    vim.keymap.set("n", "<leader>]", function()
      harpoon:list():next()
    end, { desc = "Harpoon: Go to next file" })

    -- basic telescope configuration
    local conf = require("telescope.config").values

    -- local function toggle_telescope(harpoon_files)
    --   local file_paths = {}
    --   for _, item in ipairs(harpoon_files.items) do
    --     table.insert(file_paths, item.value)
    --   end
    --
    --   require("telescope.pickers")
    --     .new({}, {
    --       prompt_title = "Harpoon",
    --       finder = require("telescope.finders").new_table {
    --         results = file_paths,
    --       },
    --       previewer = conf.file_previewer {},
    --       sorter = conf.generic_sorter {},
    --     })
    --     :find()
    -- end

    -- vim.keymap.set("n", "<leader>e", function()
    --   toggle_telescope(harpoon:list())
    -- end, { desc = "Open harpoon window" })

    vim.keymap.set("n", "<leader>e", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = "Harpoon: Open menu" })
  end,
}
