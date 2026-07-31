---@module 'lazy'
---@type LazySpec
return {
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    opts = {
      options = {
        -- 'auto' detects the theme from vim.g.colors_name, set by catppuccin
        theme = 'auto',
        globalstatus = true,
        disabled_filetypes = { statusline = { 'oil' } },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { { 'filename', path = 1 } }, -- relative path
        lualine_x = { 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
    },
  },
}
