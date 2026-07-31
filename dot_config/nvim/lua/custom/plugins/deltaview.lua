return {
  -- delta.lua: required dependency for two-tier diff + treesitter highlighting
  {
    'kokusenz/delta.lua',
    lazy = true,
  },

  -- deltaview.nvim: inline/unified diff view using delta highlighting
  {
    'kokusenz/deltaview.nvim',
    dependencies = { 'kokusenz/delta.lua', 'ibhagwan/fzf-lua' },
    keys = {
      { '<leader>gd', desc = '[G]it [d]iff current file' },
      { '<leader>gD', desc = '[G]it [D]iff with context' },
      { '<leader>gM', desc = '[G]it changed files [m]enu' },
    },
    opts = {
      fzf_picker = 'fzf-lua', -- use fzf-lua for DeltaMenu
      keyconfig = {
        dv_toggle_keybind = '<leader>gd', -- :DeltaView  — git diff current file
        d_toggle_keybind  = '<leader>gD', -- :Delta      — git diff path/context view
        dm_toggle_keybind = '<leader>gM', -- :DeltaMenu  — browse all changed files
        next_hunk = '<tab>',              -- next hunk (consistent with ]h feel)
        prev_hunk = '<s-tab>',            -- prev hunk
        next_diff = ']f',                 -- next file in menu
        prev_diff = '[f',                 -- prev file in menu
        help_legend = 'd?',
      },
    },
  },
}
