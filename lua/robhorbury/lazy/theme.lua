function ColorMyPencils(color)
  color = color or "kanagawa"
  vim.cmd.colorscheme(color)

  if color == "kanagawa" then
    local border_fg = vim.api.nvim_get_hl(0, { name = "FloatBorder" }).fg

    vim.api.nvim_set_hl(0, "StatusLine", { fg = border_fg, bg = "none" })
    vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "none" })
    vim.api.nvim_set_hl(0, "HarpoonWindow", { bg = "none" })
    vim.api.nvim_set_hl(0, "HarpoonBorder", { bg = "none" })
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "FloatBorder", {
      bg = "none",
      fg = border_fg,
    })
    vim.api.nvim_set_hl(0, "Pmenu", { bg = "none" })
    vim.api.nvim_set_hl(0, "FloatTitle", { bg = "none" })
    vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "none" })
    vim.api.nvim_set_hl(0, "VertSplit", { fg = border_fg, bg = "none" })

    -- Also for WinSeparator (used in newer Neovim)
    vim.api.nvim_set_hl(0, "WinSeparator", { fg = border_fg, bg = "none" })
  end
end

return {
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,

    config = function()
      require("kanagawa").setup {
        transparent = true,
        dimInactive = false, -- optional: disable dimming of inactive windows
        colors = {
          theme = { all = { ui = { bg_gutter = "none" } } },
        },
      }
    end,
  },
  {
    "folke/tokyonight.nvim",
    config = function()
      require("tokyonight").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        style = "storm", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
        transparent = true, -- Enable this to disable setting the background color
        terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
        styles = {
          -- Style to be applied to different syntax groups
          -- Value is any valid attr-list value for `:help nvim_set_hl`
          comments = { italic = false },
          keywords = { italic = false },
          -- Background styles. Can be "dark", "transparent" or "normal"
          sidebars = "dark", -- style for sidebars, see below
          floats = "dark", -- style for floating windows
        },
      }
    end,
  },
}
