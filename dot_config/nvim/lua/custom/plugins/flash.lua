---@module 'lazy'
---@type LazySpec
return {
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    ---@module 'flash'
    ---@type Flash.Config
    opts = {},
    keys = {
      { 's',     function() require('flash').jump() end,              desc = 'Flash',              mode = { 'n', 'x', 'o' } },
      { 'S',     function() require('flash').treesitter() end,        desc = 'Flash Treesitter',   mode = { 'n', 'x', 'o' } },
      { 'r',     function() require('flash').remote() end,            desc = 'Remote Flash',       mode = 'o' },
      { 'R',     function() require('flash').treesitter_search() end, desc = 'Treesitter Search',  mode = { 'o', 'x' } },
    },
  },
}
