---@module 'lazy'
---@type LazySpec
return {
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = true },
    keys = {
      { '<leader>st', function() Snacks.picker.todo_comments() end, desc = '[S]earch [T]odo comments' },
      { ']t', function() require('todo-comments').jump_next() end,  desc = 'Next [T]odo comment' },
      { '[t', function() require('todo-comments').jump_prev() end,  desc = 'Previous [T]odo comment' },
    },
  },
}
