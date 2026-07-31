---@module 'lazy'
---@type LazySpec
return {
  {
    'NvChad/nvim-colorizer.lua',
    event = 'BufReadPre',
    opts = {
      user_default_options = {
        css = true,       -- enable all CSS features
        tailwind = true,  -- highlight tailwind color classes
        mode = 'background', -- show color as background swatch
      },
    },
  },
}
