local setup = function()
  -- Autoformatting Setup
  local conform = require "conform"
  conform.setup {
    formatters = {},
    formatters_by_ft = {
      lua = { "stylua" },
    },
  }

  conform.formatters.injected = {
    options = {
      ignore_errors = false,
      lang_to_formatters = {
        sql = { "sleek" },
      },
    },
  }

  vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("custom-conform", { clear = true }),
    callback = function(args)
      local ft = vim.bo.filetype

      -- if ft == "yaml" then
      --   local fileName = vim.api.nvim_buf_get_name(0)
      --   vim.cmd(
      --     ":!yamllint -c "
      --       .. os.getenv "XDG_CONFIG_HOME"
      --       .. "/yamllint/config/default "
      --       .. fileName
      --       .. " --format parsable"
      --   )
      -- end

      require("conform").format {
        bufnr = args.buf,
        lsp_fallback = true,
        quiet = true,
      }
    end,
  })
end

setup()

return { setup = setup }
