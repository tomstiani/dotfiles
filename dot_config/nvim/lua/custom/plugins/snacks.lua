---@module 'lazy'
---@type LazySpec
return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      -- Fuzzy picker (replaces telescope)
      picker = { enabled = true },
      -- Notifications
      notifier = { enabled = true },
      -- Image preview
      -- env: SNACKS_GHOSTTY=true skips the runtime Kitty protocol probe that
      -- was causing "ghostty 1.3.1" to leak into the buffer on first file open
      image = { enabled = false, env = { GHOSTTY = true } },
      -- Git UI
      lazygit = { enabled = true },
      -- Nice input/select UI
      input = { enabled = true },
      -- Indent guides
      indent = { enabled = true },
      -- Word highlighting
      words = { enabled = true },
    },
    keys = {
      -- Files
      { '<leader>sf', function() Snacks.picker.files() end, desc = '[S]earch [F]iles' },
      { '<leader>s.', function() Snacks.picker.recent() end, desc = '[S]earch Recent Files' },
      { '<leader>sn', function() Snacks.picker.files { cwd = vim.fn.stdpath 'config' } end, desc = '[S]earch [N]eovim files' },

      -- Search / grep
      { '<leader>sg', function() Snacks.picker.grep() end, desc = '[S]earch by [G]rep' },
      { '<leader>sw', function() Snacks.picker.grep_word() end, desc = '[S]earch current [W]ord', mode = { 'n', 'v' } },
      { '<leader>s/', function() Snacks.picker.grep { filter = { cwd = true } } end, desc = '[S]earch [/] in Open Files' },
      { '<leader>/', function() Snacks.picker.lines() end, desc = '[/] Fuzzily search in current buffer' },

      -- Neovim meta
      { '<leader>sh', function() Snacks.picker.help() end, desc = '[S]earch [H]elp' },
      { '<leader>sk', function() Snacks.picker.keymaps() end, desc = '[S]earch [K]eymaps' },
      { '<leader>sd', function() Snacks.picker.diagnostics() end, desc = '[S]earch [D]iagnostics' },
      { '<leader>sr', function() Snacks.picker.resume() end, desc = '[S]earch [R]esume' },
      { '<leader>sc', function() Snacks.picker.commands() end, desc = '[S]earch [C]ommands' },

      -- Buffers
      { '<leader><leader>', function() Snacks.picker.recent() end, desc = '[ ] Recent files' },
      { '<leader>sb', function() Snacks.picker.buffers() end, desc = '[S]earch [B]uffers' },

      -- Git
      { '<leader>gg', function() Snacks.lazygit() end, desc = 'Lazy[G]it' },
      { '<leader>gB', function() Snacks.picker.git_branches() end, desc = '[G]it [B]ranches' },
      { '<leader>gl', function() Snacks.picker.git_log() end, desc = '[G]it [L]og' },
      { '<leader>gf', function() Snacks.picker.git_log_file() end, desc = '[G]it log [f]ile' },
    },
    init = function()
      -- Wire up LSP pickers (replaces telescope's LspAttach block)
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('snacks-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc) vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc }) end

          map('grr', function() Snacks.picker.lsp_references() end, '[G]oto [R]eferences')
          map('gri', function() Snacks.picker.lsp_implementations() end, '[G]oto [I]mplementation')
          map('grd', function() Snacks.picker.lsp_definitions() end, '[G]oto [D]efinition')
          map('grt', function() Snacks.picker.lsp_type_definitions() end, '[G]oto [T]ype Definition')
          map('gO', function() Snacks.picker.lsp_symbols() end, 'Open Document Symbols')
          map('gW', function() Snacks.picker.lsp_workspace_symbols() end, 'Open Workspace Symbols')
        end,
      })
    end,
  },
}
