 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#1a1111',
    base01 = '#271d1d',
    base02 = '#332626',
    base03 = '#715d5d',
    base04 = '#d7c1c0',
    base05 = '#f0dedd',
    base06 = '#f0dedd',
    base07 = '#f0dedd',
    base08 = '#ffb4ab',
    base09 = '#e4c18d',
    base0A = '#e6bdbb',
    base0B = '#ffb3b2',
    base0C = '#e9c796',
    base0D = '#ff8180',
    base0E = '#e99a96',
    base0F = '#f71b00',
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  hi('TelescopeNormal',         { fg = '#f0dedd',          bg = '#1a1111' })
  hi('TelescopeBorder',         { fg = '#715d5d',             bg = '#1a1111' })
  hi('TelescopePromptNormal',   { fg = '#f0dedd',          bg = '#1a1111' })
  hi('TelescopePromptBorder',   { fg = '#715d5d',             bg = '#1a1111' })
  hi('TelescopePromptPrefix',   { fg = '#ffb3b2',             bg = '#1a1111' })
  hi('TelescopePromptCounter',  { fg = '#d7c1c0',  bg = '#1a1111' })
  hi('TelescopePromptTitle',    { fg = '#1a1111',             bg = '#ffb3b2' })
  hi('TelescopePreviewTitle',   { fg = '#1a1111',             bg = '#e6bdbb' })
  hi('TelescopeResultsTitle',   { fg = '#1a1111',             bg = '#e4c18d' })
  hi('TelescopeSelection',      { fg = '#f0dedd',          bg = '#332626' })
  hi('TelescopeSelectionCaret', { fg = '#ffb3b2',             bg = '#332626' })
  hi('TelescopeMatching',       { fg = '#ffb3b2',             bold = true })
end

 -- Register a signal handler for SIGUSR1 (matugen updates)
 local signal = vim.uv.new_signal()
 signal:start(
   'sigusr1',
   vim.schedule_wrap(function()
     package.loaded['matugen'] = nil
     require('matugen').setup()
   end)
 )

 return M
