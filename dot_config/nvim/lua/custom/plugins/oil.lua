---@module 'lazy'
---@type LazySpec
return {
  {
    'stevearc/oil.nvim',
    lazy = false,
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      -- Use icons if you have a Nerd Font
      columns = { 'icon' },
      -- Show hidden files by default
      view_options = {
        show_hidden = true,
      },
      -- Keymaps inside the oil buffer
      keymaps = {
        ['<C-c>'] = { 'actions.close', mode = 'n' },
        ['<BS>']  = { 'actions.parent', mode = 'n' },
        ['<C-s>'] = false, -- disable default horizontal split (conflicts with tmux)
        ['<C-h>'] = false, -- disable default vertical split (conflicts with tmux)
      },
    },
    init = function()
      vim.api.nvim_create_autocmd('VimEnter', {
        callback = function()
          if #vim.api.nvim_list_uis() == 0 then return end
          local arg = vim.fn.argv(0)
          if vim.fn.argc() == 0 then
            -- nvim opened with no arguments
            require('oil').open()
          elseif vim.fn.argc() == 1 and vim.fn.isdirectory(arg) == 1 then
            -- nvim opened with a directory: `nvim .` or `nvim /some/dir`
            require('oil').open(arg)
          end
        end,
      })
    end,
    keys = {
      { '<leader>e', '<cmd>Oil<cr>', desc = 'Open [E]xplorer (parent dir)' },
    },
  },
}
