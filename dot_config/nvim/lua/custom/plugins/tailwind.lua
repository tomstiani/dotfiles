-- Tailwind CSS extras
-- - tailwindcss LSP is configured in kickstart/plugins/lspconfig.lua
-- - nvim-colorizer.lua (colorizer.lua) handles in-buffer class color highlighting
-- - This file adds color swatches inside the blink.cmp completion menu
---@module 'lazy'
---@type LazySpec
return {
  {
    'saghen/blink.cmp',
    optional = true,
    opts = {
      appearance = {
        -- Colour swatches for Tailwind classes in the completion menu.
        -- The tailwindcss LSP encodes the resolved colour in
        -- item.documentation when the item is a colour utility, so we
        -- read it here and paint the kind icon with that colour.
        kind_icons = vim.tbl_extend('force', require('blink.cmp.config').appearance.kind_icons or {}, {}),
      },
      completion = {
        menu = {
          draw = {
            components = {
              kind_icon = {
                text = function(ctx)
                  -- Fall back to the default kind icon text
                  return ctx.kind_icon .. ctx.icon_gap
                end,
                highlight = function(ctx)
                  -- If the LSP supplied a colour (hex string in documentation),
                  -- create a temporary highlight group and return it.
                  local doc = ctx.item.documentation
                  local color = type(doc) == 'string' and doc:match '^#(%x%x%x%x%x%x)$'
                  if color then
                    local hl = 'BlinkTailwind_' .. color
                    if vim.fn.hlID(hl) == 0 then
                      vim.api.nvim_set_hl(0, hl, { fg = '#' .. color })
                    end
                    return hl
                  end
                  -- Default: use the built-in kind highlight
                  return 'BlinkCmpKind' .. ctx.kind
                end,
              },
            },
          },
        },
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
