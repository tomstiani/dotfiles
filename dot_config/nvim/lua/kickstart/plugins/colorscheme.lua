---@module 'lazy'
---@type LazySpec
return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    ---@module 'catppuccin'
    ---@type CatppuccinOptions
    opts = {
      flavour = 'mocha',
      transparent_background = true,
      lsp_styles = {
        underlines = {
          errors = { 'undercurl' },
          hints = { 'undercurl' },
          warnings = { 'undercurl' },
          information = { 'undercurl' },
        },
      },
      integrations = {
        blink_cmp = true,
        bufferline = true,
        flash = true,
        gitsigns = true,
        grug_far = true,
        lsp_trouble = true,
        mason = true,
        mini = { enabled = true },
        neotest = true,
        noice = true,
        notify = true,
        snacks = true,
        treesitter = true,
        which_key = true,
      },
    },
    config = function(_, opts)
      require('catppuccin').setup(opts)
      vim.cmd.colorscheme 'catppuccin'
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
