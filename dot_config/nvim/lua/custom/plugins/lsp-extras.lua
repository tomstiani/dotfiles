---@module 'lazy'
---@type LazySpec
return {
  -- Lua LSP completions for your neovim config
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },

  -- JSON/YAML schema completions (tsconfig, package.json, etc.)
  {
    'b0o/SchemaStore.nvim',
    lazy = true,
    -- Wired into jsonls and yamlls in lspconfig.lua
  },
}
