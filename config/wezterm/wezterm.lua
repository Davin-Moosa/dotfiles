local wezterm = require('wezterm')
local act = wezterm.action

local config = wezterm.config_builder()

wezterm.on("split", function(window, pane)
  local dims = pane:get_dimensions()
  if dims.pixel_height > dims.pixel_width then
    window:perform_action(act.SplitVertical({ domain = 'CurrentPaneDomain' }), pane)
  else
    window:perform_action(act.SplitHorizontal({ domain = 'CurrentPaneDomain' }), pane)
  end
end)

config = {
  adjust_window_size_when_changing_font_size = false,
  color_scheme = 'tokyonight_night',
  disable_default_key_bindings = true,
  font_size = 10,
  show_new_tab_button_in_tab_bar = false,
  tab_max_width = 48,
  use_fancy_tab_bar = false,

  keys = {
    { key = 'd', mods = 'ALT', action = act.ShowDebugOverlay },

    { key = 'f', mods = 'ALT', action = act.Search('CurrentSelectionOrEmptyString') },

    { key = 'p', mods = 'ALT', action = act.ActivateCommandPalette },

    { key = 's', mods = 'ALT', action = wezterm.action.EmitEvent('split') },

    { key = 't', mods = 'ALT', action = act.SpawnTab('CurrentPaneDomain') },

    { key = 'w', mods = 'ALT', action = act.CloseCurrentPane({ confirm = true }) },

    { key = 'x', mods = 'ALT', action = act.ActivateCopyMode },

    { key = 'z', mods = 'ALT', action = act.TogglePaneZoomState },

    { key = '[', mods = 'ALT', action = act.ActivateTabRelative(-1) },

    { key = ']', mods = 'ALT', action = act.ActivateTabRelative(1) },

    { key = 'H', mods = 'ALT',      action = act.AdjustPaneSize({ 'Left', 3 }) },
    { key = 'h', mods = 'ALT|CTRL', action = act.ActivatePaneDirection('Left') },

    { key = 'J', mods = 'ALT',      action = act.AdjustPaneSize({ 'Down', 3 }) },
    { key = 'j', mods = 'ALT|CTRL', action = act.ActivatePaneDirection('Down') },

    { key = 'K', mods = 'ALT',      action = act.AdjustPaneSize({ 'Up', 3 }) },
    { key = 'k', mods = 'ALT|CTRL', action = act.ActivatePaneDirection('Up') },

    { key = 'L', mods = 'ALT',      action = act.AdjustPaneSize({ 'Right', 3 }) },
    { key = 'l', mods = 'ALT|CTRL', action = act.ActivatePaneDirection('Right') },

    { key = 'U', mods = 'CTRL', action = act.CharSelect({ copy_on_select = true, copy_to =  'ClipboardAndPrimarySelection' }) },

    { key = 'C', mods = 'CTRL', action = act.CopyTo('Clipboard') },
    { key = 'V', mods = 'CTRL', action = act.PasteFrom('Clipboard') },

    { key = 'Copy',  mods = 'NONE', action = act.CopyTo('Clipboard') },
    { key = 'Paste', mods = 'NONE', action = act.PasteFrom('Clipboard') },

    { key = 'Insert', mods = 'CTRL',  action = act.CopyTo('PrimarySelection') },
    { key = 'Insert', mods = 'SHIFT', action = act.PasteFrom('PrimarySelection') },

    { key = 'phys:Space', mods = 'ALT', action = act.QuickSelect },

    { key = '=', mods = 'CTRL', action = act.IncreaseFontSize },
    { key = '-', mods = 'CTRL', action = act.DecreaseFontSize },
  },

  key_tables = {
    copy_mode = {
      { key = 'Tab', mods = 'NONE', action = act.CopyMode('MoveForwardWord') },
      { key = 'Tab', mods = 'SHIFT', action = act.CopyMode('MoveBackwardWord') },
      { key = 'Enter', mods = 'NONE', action = act.CopyMode('MoveToStartOfNextLine') },
      { key = 'Escape', mods = 'NONE', action = act.Multiple({ 'ScrollToBottom', { CopyMode =  'Close' } }) },
      { key = 'Space', mods = 'NONE', action = act.CopyMode({ SetSelectionMode =  'Cell'  }) },
      { key = '$', mods = 'NONE', action = act.CopyMode('MoveToEndOfLineContent') },
      { key = '$', mods = 'SHIFT', action = act.CopyMode('MoveToEndOfLineContent') },
      { key = ',', mods = 'NONE', action = act.CopyMode('JumpReverse') },
      { key = '0', mods = 'NONE', action = act.CopyMode('MoveToStartOfLine') },
      { key = ';', mods = 'NONE', action = act.CopyMode('JumpAgain') },
      { key = 'F', mods = 'NONE', action = act.CopyMode({ JumpBackward = { prev_char = false } }) },
      { key = 'F', mods = 'SHIFT', action = act.CopyMode({ JumpBackward = { prev_char = false } }) },
      { key = 'G', mods = 'NONE', action = act.CopyMode('MoveToScrollbackBottom') },
      { key = 'G', mods = 'SHIFT', action = act.CopyMode('MoveToScrollbackBottom') },
      { key = 'H', mods = 'NONE', action = act.CopyMode('MoveToViewportTop') },
      { key = 'H', mods = 'SHIFT', action = act.CopyMode('MoveToViewportTop') },
      { key = 'L', mods = 'NONE', action = act.CopyMode('MoveToViewportBottom') },
      { key = 'L', mods = 'SHIFT', action = act.CopyMode('MoveToViewportBottom') },
      { key = 'M', mods = 'NONE', action = act.CopyMode('MoveToViewportMiddle') },
      { key = 'M', mods = 'SHIFT', action = act.CopyMode('MoveToViewportMiddle') },
      { key = 'O', mods = 'NONE', action = act.CopyMode('MoveToSelectionOtherEndHoriz') },
      { key = 'O', mods = 'SHIFT', action = act.CopyMode('MoveToSelectionOtherEndHoriz') },
      { key = 'T', mods = 'NONE', action = act.CopyMode({ JumpBackward = { prev_char = true } }) },
      { key = 'T', mods = 'SHIFT', action = act.CopyMode({ JumpBackward = { prev_char = true } }) },
      { key = 'V', mods = 'NONE', action = act.CopyMode({ SetSelectionMode =  'Line' }) },
      { key = 'V', mods = 'SHIFT', action = act.CopyMode({ SetSelectionMode =  'Line' }) },
      { key = '^', mods = 'NONE', action = act.CopyMode('MoveToStartOfLineContent') },
      { key = '^', mods = 'SHIFT', action = act.CopyMode('MoveToStartOfLineContent') },
      { key = 'b', mods = 'NONE', action = act.CopyMode('MoveBackwardWord') },
      { key = 'b', mods = 'ALT', action = act.CopyMode('MoveBackwardWord') },
      { key = 'b', mods = 'CTRL', action = act.CopyMode('PageUp') },
      { key = 'c', mods = 'CTRL', action = act.Multiple({ 'ScrollToBottom', { CopyMode =  'Close' } }) },
      { key = 'd', mods = 'CTRL', action = act.CopyMode({ MoveByPage = (0.5) }) },
      { key = 'e', mods = 'NONE', action = act.CopyMode 'MoveForwardWordEnd'  },
      { key = 'f', mods = 'NONE', action = act.CopyMode({ JumpForward = { prev_char = false } }) },
      { key = 'f', mods = 'ALT', action = act.CopyMode('MoveForwardWord') },
      { key = 'f', mods = 'CTRL', action = act.CopyMode('PageDown') },
      { key = 'g', mods = 'NONE', action = act.CopyMode('MoveToScrollbackTop') },
      { key = 'g', mods = 'CTRL', action = act.Multiple({ 'ScrollToBottom', { CopyMode =  'Close' } }) },
      { key = 'h', mods = 'NONE', action = act.CopyMode('MoveLeft') },
      { key = 'j', mods = 'NONE', action = act.CopyMode('MoveDown') },
      { key = 'k', mods = 'NONE', action = act.CopyMode('MoveUp') },
      { key = 'l', mods = 'NONE', action = act.CopyMode('MoveRight') },
      { key = 'm', mods = 'ALT', action = act.CopyMode('MoveToStartOfLineContent') },
      { key = 'o', mods = 'NONE', action = act.CopyMode('MoveToSelectionOtherEnd') },
      { key = 'q', mods = 'NONE', action = act.Multiple({ 'ScrollToBottom', { CopyMode =  'Close' } }) },
      { key = 't', mods = 'NONE', action = act.CopyMode({ JumpForward = { prev_char = true } }) },
      { key = 'u', mods = 'CTRL', action = act.CopyMode({ MoveByPage = (-0.5) }) },
      { key = 'v', mods = 'NONE', action = act.CopyMode({ SetSelectionMode =  'Cell' }) },
      { key = 'v', mods = 'CTRL', action = act.CopyMode({ SetSelectionMode =  'Block' }) },
      { key = 'w', mods = 'NONE', action = act.CopyMode('MoveForwardWord') },
      { key = 'y', mods = 'NONE', action = act.Multiple({ { CopyTo =  'ClipboardAndPrimarySelection' }, { Multiple = { 'ScrollToBottom', { CopyMode =  'Close' } } } }) },
      { key = 'PageUp', mods = 'NONE', action = act.CopyMode('PageUp') },
      { key = 'PageDown', mods = 'NONE', action = act.CopyMode('PageDown') },
      { key = 'End', mods = 'NONE', action = act.CopyMode('MoveToEndOfLineContent') },
      { key = 'Home', mods = 'NONE', action = act.CopyMode('MoveToStartOfLine') },
      { key = 'LeftArrow', mods = 'NONE', action = act.CopyMode('MoveLeft') },
      { key = 'LeftArrow', mods = 'ALT', action = act.CopyMode('MoveBackwardWord') },
      { key = 'RightArrow', mods = 'NONE', action = act.CopyMode('MoveRight') },
      { key = 'RightArrow', mods = 'ALT', action = act.CopyMode('MoveForwardWord') },
      { key = 'UpArrow', mods = 'NONE', action = act.CopyMode('MoveUp') },
      { key = 'DownArrow', mods = 'NONE', action = act.CopyMode('MoveDown') },
    },

    search_mode = {
      { key = 'Enter', mods = 'NONE', action = act.CopyMode('PriorMatch') },
      { key = 'Escape', mods = 'NONE', action = act.CopyMode('Close') },
      { key = 'n', mods = 'CTRL', action = act.CopyMode('NextMatch') },
      { key = 'p', mods = 'CTRL', action = act.CopyMode('PriorMatch') },
      { key = 'r', mods = 'CTRL', action = act.CopyMode('CycleMatchType') },
      { key = 'u', mods = 'CTRL', action = act.CopyMode('ClearPattern') },
      { key = 'PageUp', mods = 'NONE', action = act.CopyMode('PriorMatchPage') },
      { key = 'PageDown', mods = 'NONE', action = act.CopyMode('NextMatchPage') },
      { key = 'UpArrow', mods = 'NONE', action = act.CopyMode('PriorMatch') },
      { key = 'DownArrow', mods = 'NONE', action = act.CopyMode('NextMatch') },
    },
  }
}

for i = 0, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'ALT',
    action = act.ActivateTab(i - 1),
  })
  if i ~= 0 then
    table.insert(config.keys, {
      key = tostring(i),
      mods = 'CTRL|ALT',
      action = act.MoveTab(i - 1),
    })
  end
end

return config
