---@module 'lazy'
---@type LazySpec
return {
  {
    'alexghergh/nvim-tmux-navigation',
    event = 'VeryLazy',
    opts = {
      disable_when_zoomed = true,
    },
    keys = {
      { '<C-h>', '<cmd>NvimTmuxNavigateLeft<cr>',  desc = 'Navigate left' },
      { '<C-j>', '<cmd>NvimTmuxNavigateDown<cr>',  desc = 'Navigate down' },
      { '<C-k>', '<cmd>NvimTmuxNavigateUp<cr>',    desc = 'Navigate up' },
      { '<C-l>', '<cmd>NvimTmuxNavigateRight<cr>', desc = 'Navigate right' },
    },
  },
}
