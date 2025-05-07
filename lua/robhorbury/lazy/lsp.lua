return {

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
        -- used for completion, annotations and signatures of Neovim apis
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          library = {
            -- Load luvit types when the `vim.uv` word is found
            { path = "luvit-meta/library", words = { "vim%.uv" } },
            { path = "/usr/share/awesome/lib/", words = { "awesome" } },
          },
        },
      },
      { "Bilal2453/luvit-meta", lazy = true },
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",

      { "j-hui/fidget.nvim", opts = {} },
      { "https://git.sr.ht/~whynothugo/lsp_lines.nvim" },

      -- Autoformatting
      "stevearc/conform.nvim",

      -- Schema information
      "b0o/SchemaStore.nvim",
    },
    config = function()
      local extend = function(name, key, values)
        local mod = require(string.format("lspconfig.configs.%s", name))
        local default = mod.default_config
        local keys = vim.split(key, ".", { plain = true })
        while #keys > 0 do
          local item = table.remove(keys, 1)
          default = default[item]
        end

        if vim.islist(default) then
          for _, value in ipairs(default) do
            table.insert(values, value)
          end
        else
          for item, value in pairs(default) do
            if not vim.tbl_contains(values, item) then
              values[item] = value
            end
          end
        end
        return values
      end

      local capabilities = nil
      if pcall(require, "cmp_nvim_lsp") then
        capabilities = require("cmp_nvim_lsp").default_capabilities()
      end

      local lspconfig = require "lspconfig"

      -- Function to determine the correct `pylsp` path
      local function get_pylsp_cmd()
        -- 1. Use VIRTUAL_ENV if set
        local venv = os.getenv "VIRTUAL_ENV"
        if venv then
          local pylsp_path = venv .. "/bin/pylsp"
          if vim.fn.filereadable(pylsp_path) == 1 then
            return { pylsp_path }
          end
        end

        -- 2. Fallback to Mason path
        local mason_pylsp = vim.fn.stdpath "data" .. "/mason/bin/pylsp"
        if vim.fn.filereadable(mason_pylsp) == 1 then
          return { mason_pylsp }
        end

        -- 3. Fallback to system pylsp
        return { "pylsp" }
      end

      local servers = {
        -- yamllint = {
        --   filetypes = { "yaml" },
        --
        --   settings = {
        --     yamllint = {
        --       yaml = { keyOrdering = false },
        --     },
        --   },
        -- },
        --
        pylsp = {
          cmd = get_pylsp_cmd(),
          settings = {
            pylsp = {
              plugins = {
                pycodestyle = {
                  enabled = true,
                  maxLineLength = 100,
                },
                ruff = {
                  enabled = true, -- Enable the plugin
                  formatEnabled = true, -- Enable formatting using ruffs formatter
                  -- cmd = "python -m ruff",
                  -- executable = "/Users/robert.horbury/.local/share/uv/python/cpython-3.10.17-macos-aarch64-none/bin/ruff", -- Custom path to ruff
                  unsafeFixes = false, -- Whether or not to offer unsafe fixes as code actions. Ignored with the "Fix All" action
                  select = { "E", "F", "UP", "B", "SIM", "I", "D", "FIX" },
                  format = { "E", "F", "I" },
                  ignore = { "D212", "D200", "D415" },
                  -- Rules that are ignored when a pyproject.toml or ruff.toml is present:
                  lineLength = 100, -- Line length to pass to ruff checking and formatting
                  targetVersion = "py310", -- The minimum python version to target (applies for both linting and formatting).
                },
              },
              flake8 = {
                enabled = false,
                maxLineLength = 100,
              },
              black = {
                enabled = false,
              },
              isort = {
                enabled = false,
              },
              pyflakes = {
                enabled = false,
              },
            },
          },
        },
        gopls = {
          settings = {
            gopls = {
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
            },
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = "Replace",
              },
              format = {
                enable = true,
                defaultConfig = {
                  indent_style = "space",
                  indent_size = "2",
                },
              },
            },
          },
        },
      }

      local servers_to_install = vim.tbl_filter(function(key)
        local t = servers[key]
        if type(t) == "table" then
          return not t.manual_install
        else
          return t
        end
      end, vim.tbl_keys(servers))

      require("mason").setup()
      local ensure_installed = {
        "pylsp",
        "stylua",
        "lua_ls",
      }

      vim.list_extend(ensure_installed, servers_to_install)
      require("mason-tool-installer").setup { ensure_installed = ensure_installed }

      for name, config in pairs(servers) do
        if config == true then
          config = {}
        end
        config = vim.tbl_deep_extend("force", {}, {
          capabilities = capabilities,
        }, config)

        lspconfig[name].setup(config)
      end

      require("robhorbury.custom.autoformat").setup()

      require("lsp_lines").setup()
      vim.diagnostic.config { virtual_text = true, virtual_lines = false }

      vim.keymap.set("", "<leader>l", function()
        local config = vim.diagnostic.config() or {}
        if config.virtual_text then
          vim.diagnostic.config { virtual_text = false, virtual_lines = true }
        else
          vim.diagnostic.config { virtual_text = true, virtual_lines = false }
        end
      end, { desc = "Toggle lsp_lines" })
    end,
  },
}
