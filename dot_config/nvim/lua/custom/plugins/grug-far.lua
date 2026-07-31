---@module 'lazy'
---@type LazySpec
return {
  {
    'MagicDuck/grug-far.nvim',
    cmd = 'GrugFar',
    keys = {
      { '<leader>fr', '<cmd>GrugFar<cr>',                                                                         desc = '[F]ind and [R]eplace' },
      { '<leader>fw', function() require('grug-far').open({ prefills = { search = vim.fn.expand('<cword>') } }) end, desc = '[F]ind and replace current [W]ord' },
    },
    opts = {},
  },
}
