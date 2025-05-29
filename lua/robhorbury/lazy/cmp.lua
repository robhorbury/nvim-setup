return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
  },
  config = function()
    local cmp = require "cmp"
    local luasnip = require "luasnip"

    luasnip.config.setup {}

    -- Toggles
    local cmp_menu_autocomplete = true
    local cmp_ghost_text_enabled = true

    local function apply_cmp_config()
      cmp.setup {
        enabled = true, -- always enabled for ghost text
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm { select = true },
          ["<C-e>"] = cmp.mapping.abort(),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        },
        sources = cmp.config.sources {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        },
        experimental = {
          ghost_text = cmp_ghost_text_enabled,
        },
        completion = {
          autocomplete = cmp_menu_autocomplete and { "InsertEnter", "TextChanged" } or false,
        },
      }
    end

    apply_cmp_config()

    -- Toggle menu autocomplete (popup menu auto open)
    vim.keymap.set("n", "<leader>ac", function()
      cmp_menu_autocomplete = not cmp_menu_autocomplete
      apply_cmp_config()
      vim.notify("Autocomplete menu " .. (cmp_menu_autocomplete and "enabled" or "disabled"))
    end, { desc = "Toggle autocomplete menu (popup only)" })

    -- Toggle both menu and ghost text
    vim.keymap.set("n", "<leader>at", function()
      cmp_menu_autocomplete = not cmp_menu_autocomplete
      cmp_ghost_text_enabled = not cmp_ghost_text_enabled
      apply_cmp_config()
      vim.notify("Autocomplete menu + ghost text " .. (cmp_menu_autocomplete and "enabled" or "disabled"))
    end, { desc = "Toggle autocomplete menu + ghost text" })
  end,
}
