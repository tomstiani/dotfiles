---@module 'lazy'
---@type LazySpec
return {
  {
    'ibhagwan/fzf-lua',
    -- fzf-lua is installed here primarily to power deltaview.nvim's DeltaMenu picker.
    -- snacks.picker handles all other fuzzy-finding in this config.
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      -- Use a minimal profile — snacks owns the primary picker UX
      'default',
      winopts = {
        height = 0.6,
        width = 0.8,
        preview = { layout = 'vertical', vertical = 'up:60%' },
      },
    },
  },
}
