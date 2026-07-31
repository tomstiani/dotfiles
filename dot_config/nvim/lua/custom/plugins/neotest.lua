---@module 'lazy'
---@type LazySpec
return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'nvim-neotest/neotest-jest',
      'marilari88/neotest-vitest',
      'sidlatau/neotest-dart',
    },
    keys = {
      { '<leader>tt', function() require('neotest').run.run() end,                       desc = '[T]est Nearest' },
      { '<leader>tf', function() require('neotest').run.run(vim.fn.expand('%')) end,     desc = '[T]est [F]ile' },
      { '<leader>ta', function() require('neotest').run.run(vim.fn.getcwd()) end,        desc = '[T]est [A]ll' },
      { '<leader>ts', function() require('neotest').summary.toggle() end,                desc = '[T]est [S]ummary' },
      { '<leader>to', function() require('neotest').output.open({ enter = true }) end,   desc = '[T]est [O]utput' },
      { '<leader>tl', function() require('neotest').run.run_last() end,                  desc = '[T]est [L]ast' },
    },
    opts = function()
      return {
        adapters = {
          require('neotest-jest')({
            jestCommand = 'npm test --',
            env = { CI = true },
            cwd = function(path)
              return vim.fs.root(path, 'package.json')
            end,
          }),
          require('neotest-vitest')({
            cwd = function(path)
              return vim.fs.root(path, 'package.json')
            end,
          }),
          require('neotest-dart')({
            command = 'flutter',
          }),
        },
      }
    end,
  },
}
