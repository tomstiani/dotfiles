---@module 'lazy'
---@type LazySpec
return {
  {
    'folke/trouble.nvim',
    cmd = 'Trouble',
    opts = {},
    keys = {
      { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>',                        desc = 'Diagnostics (Trouble)' },
      { '<leader>xd', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',           desc = 'Buffer Diagnostics (Trouble)' },
      { '<leader>xs', '<cmd>Trouble symbols toggle focus=false<cr>',                desc = 'Symbols (Trouble)' },
      { '<leader>xl', '<cmd>Trouble loclist toggle<cr>',                            desc = 'Location List (Trouble)' },
      { '<leader>xq', '<cmd>Trouble qflist toggle<cr>',                             desc = 'Quickfix List (Trouble)' },
    },
  },
}
