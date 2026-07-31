---@module 'lazy'
---@type LazySpec
return {
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = 'cd app && bash install.sh',
    keys = {
      { '<leader>mp', '<cmd>MarkdownPreviewToggle<cr>', desc = 'Preview Toggle', ft = 'markdown' },
    },
    config = function()
      vim.g.mkdp_auto_close = 1
      vim.g.mkdp_open_to_the_world = 0
      vim.g.mkdp_browser = ''
    end,
  },
}
