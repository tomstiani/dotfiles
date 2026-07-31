---@module 'lazy'
---@type LazySpec
return {
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = { 'MunifTanjim/nui.nvim' },
    ---@module 'noice'
    ---@type NoiceConfig
    opts = {
      -- Only the floating cmdline — nothing else
      cmdline = {
        enabled = true,
        view = 'cmdline_popup',
      },
      -- Leave messages, notifications, and LSP alone
      messages = { enabled = false },
      notify = { enabled = false },   -- snacks handles notifications
      popupmenu = { enabled = false },
      lsp = {
        progress = { enabled = false },  -- fidget handles this
        hover = { enabled = false },
        signature = { enabled = false }, -- blink.cmp handles this
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = false,
          ['vim.lsp.util.stylize_markdown'] = false,
        },
      },
      presets = {
        bottom_search = false,
        command_palette = false,
        long_message_to_split = false,
      },
    },
  },
}
