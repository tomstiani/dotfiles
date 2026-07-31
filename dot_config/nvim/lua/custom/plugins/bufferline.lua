---@module 'lazy'
---@type LazySpec
return {
  {
    'akinsho/bufferline.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    keys = {
      { '<leader>bd', function() Snacks.bufdelete() end,           desc = 'Delete Buffer' },
      { '<leader>bo', function() Snacks.bufdelete.other() end,     desc = 'Delete Other Buffers' },
      { '<leader>bp', '<Cmd>BufferLineTogglePin<CR>',              desc = 'Toggle Pin' },
      { '<leader>bP', '<Cmd>BufferLineGroupClose ungrouped<CR>',   desc = 'Delete Non-Pinned Buffers' },
      { '<leader>br', '<Cmd>BufferLineCloseRight<CR>',             desc = 'Delete Buffers to the Right' },
      { '<leader>bl', '<Cmd>BufferLineCloseLeft<CR>',              desc = 'Delete Buffers to the Left' },
      { '<leader>bj', '<cmd>BufferLinePick<cr>',                   desc = 'Pick Buffer' },
      { '<S-h>',      '<cmd>BufferLineCyclePrev<cr>',              desc = 'Prev Buffer' },
      { '<S-l>',      '<cmd>BufferLineCycleNext<cr>',              desc = 'Next Buffer' },
      { '[b',         '<cmd>BufferLineCyclePrev<cr>',              desc = 'Prev Buffer' },
      { ']b',         '<cmd>BufferLineCycleNext<cr>',              desc = 'Next Buffer' },
      { '[B',         '<cmd>BufferLineMovePrev<cr>',               desc = 'Move Buffer Prev' },
      { ']B',         '<cmd>BufferLineMoveNext<cr>',               desc = 'Move Buffer Next' },
    },
    opts = {
      options = {
        -- Use Snacks (already in your config) for safe buffer deletion
        close_command = function(n) Snacks.bufdelete(n) end,
        right_mouse_command = function(n) Snacks.bufdelete(n) end,

        -- Show LSP diagnostics badges on tabs
        diagnostics = 'nvim_lsp',
        diagnostics_indicator = function(_, _, diag)
          local ret = (diag.error   and ' ' .. diag.error   .. ' ' or '')
                   .. (diag.warning and ' ' .. diag.warning        or '')
          return vim.trim(ret)
        end,

        -- Only show the tabline when there are 2+ buffers open
        always_show_bufferline = false,

        -- Reserve space so bufferline doesn't overlap sidebar-style windows.
        -- Add entries here if you use neo-tree, aerial, etc.
        offsets = {
          {
            filetype   = 'snacks_layout_box',
          },
        },
      },
    },
    config = function(_, opts)
      require('bufferline').setup(opts)
      -- Fix bufferline when restoring a session (e.g. with persistence.nvim)
      vim.api.nvim_create_autocmd({ 'BufAdd', 'BufDelete' }, {
        callback = function()
          vim.schedule(function()
            pcall(nvim_bufferline)
          end)
        end,
      })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
