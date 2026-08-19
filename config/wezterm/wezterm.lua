local wezterm = require('wezterm')
local act = wezterm.action

local config = wezterm.config_builder()

wezterm.on('new-pane', function(window, pane)
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
  font_size = 11,
  show_new_tab_button_in_tab_bar = false,
  tab_max_width = 48,
  use_fancy_tab_bar = false,

  keys = {
    { key = '-', mods = 'CTRL', action = act.DecreaseFontSize },
    { key = '=', mods = 'CTRL', action = act.IncreaseFontSize },

    { key = 'C', mods = 'SHIFT|CTRL', action = act.CopyTo 'Clipboard' },
    { key = 'V', mods = 'SHIFT|CTRL', action = act.PasteFrom 'Clipboard' },

    { key = 'Insert', mods = 'CTRL', action = act.CopyTo 'PrimarySelection' },
    { key = 'Insert', mods = 'SHIFT', action = act.PasteFrom 'PrimarySelection' },

    { key = 'Copy', mods = 'NONE', action = act.CopyTo 'Clipboard' },
    { key = 'Paste', mods = 'NONE', action = act.PasteFrom 'Clipboard' },

    { key = 'Space', mods = 'ALT', action = act.QuickSelect },

    { key = 'p', mods = 'ALT', action = act.ActivateCommandPalette },

    { key = 'f', mods = 'ALT', action = act.Search 'CurrentSelectionOrEmptyString' },
    { key = 'x', mods = 'ALT', action = act.ActivateCopyMode },

    { key = 'h', mods = 'ALT', action = act.ActivatePaneDirection 'Left' },
    { key = 'j', mods = 'ALT', action = act.ActivatePaneDirection 'Down' },
    { key = 'k', mods = 'ALT', action = act.ActivatePaneDirection 'Up' },
    { key = 'l', mods = 'ALT', action = act.ActivatePaneDirection 'Right' },

    { key = 'h', mods = 'ALT|CTRL', action = act.SplitPane { direction = 'Left', top_level = true } },
    { key = 'j', mods = 'ALT|CTRL', action = act.SplitVertical },
    { key = 'k', mods = 'ALT|CTRL', action = act.SplitPane { direction = 'Up', top_level = true } },
    { key = 'l', mods = 'ALT|CTRL', action = act.SplitHorizontal },

    { key = 'H', mods = 'ALT|SHIFT', action = act.AdjustPaneSize { 'Left', 3 } },
    { key = 'J', mods = 'ALT|SHIFT', action = act.AdjustPaneSize { 'Down', 3 } },
    { key = 'K', mods = 'ALT|SHIFT', action = act.AdjustPaneSize { 'Up', 3 } },
    { key = 'L', mods = 'ALT|SHIFT', action = act.AdjustPaneSize { 'Right', 3 } },

    { key = 'c', mods = 'ALT', action = act.CloseCurrentPane { confirm = true } },
    { key = 'n', mods = 'ALT', action = act.EmitEvent 'new-pane' },

    { key = 'm', mods = 'ALT', action = act.PaneSelect { mode = 'SwapWithActive' } },

    { key = 'z', mods = 'ALT', action = act.TogglePaneZoomState },

    { key = 'a', mods = 'ALT', action = act.ActivateLastTab },

    { key = 't', mods = 'ALT', action = act.SpawnTab 'CurrentPaneDomain' },

    { key = '[', mods = 'ALT', action = act.ActivateTabRelative(-1) },
    { key = ']', mods = 'ALT', action = act.ActivateTabRelative(1) },

    { key = '[', mods = 'ALT|CTRL', action = act.MoveTabRelative(-1) },
    { key = ']', mods = 'ALT|CTRL', action = act.MoveTabRelative(1) },

    {
      key = 'b',
      mods = 'ALT',
      action = wezterm.action_callback(function(win, pane)
        local tab, window = pane:move_to_new_tab()
      end)
    },

    {
      key = 'l',
      mods = 'ALT',
      action = act.PromptInputLine {
        description = 'Enter label for tab',
        initial_value = 'Label: ',
        action = wezterm.action_callback(function(win, pane, line)
          if line then
            win:active_tab():set_title(line)
          end
        end),
      },
    },
  },

  key_tables = {
    copy_mode = {
      { key = 'Escape', mods = 'NONE', action = act.Multiple { 'ScrollToBottom', { CopyMode =  'Close' } } },
      { key = 'c', mods = 'CTRL', action = act.Multiple { 'ScrollToBottom', { CopyMode =  'Close' } } },

      { key = 'Tab', mods = 'NONE', action = act.CopyMode 'MoveForwardWord' },
      { key = 'Tab', mods = 'SHIFT', action = act.CopyMode 'MoveBackwardWord' },
      { key = 'Enter', mods = 'NONE', action = act.CopyMode 'MoveToStartOfNextLine' },
      { key = 'Space', mods = 'NONE', action = act.CopyMode { SetSelectionMode =  'Cell' } },
      { key = '$', mods = 'SHIFT', action = act.CopyMode 'MoveToEndOfLineContent' },
      { key = ',', mods = 'NONE', action = act.CopyMode 'JumpReverse' },
      { key = '0', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLine' },
      { key = ';', mods = 'NONE', action = act.CopyMode 'JumpAgain' },
      { key = 'F', mods = 'SHIFT', action = act.CopyMode { JumpBackward = { prev_char = false } } },
      { key = 'G', mods = 'SHIFT', action = act.CopyMode 'MoveToScrollbackBottom' },
      { key = 'H', mods = 'SHIFT', action = act.CopyMode 'MoveToViewportTop' },
      { key = 'L', mods = 'SHIFT', action = act.CopyMode 'MoveToViewportBottom' },
      { key = 'M', mods = 'SHIFT', action = act.CopyMode 'MoveToViewportMiddle' },
      { key = 'O', mods = 'SHIFT', action = act.CopyMode 'MoveToSelectionOtherEndHoriz' },
      { key = 'T', mods = 'SHIFT', action = act.CopyMode { JumpBackward = { prev_char = true } } },
      { key = 'V', mods = 'SHIFT', action = act.CopyMode { SetSelectionMode =  'Line' } },
      { key = '^', mods = 'SHIFT', action = act.CopyMode 'MoveToStartOfLineContent' },
      { key = 'b', mods = 'NONE', action = act.CopyMode 'MoveBackwardWord' },
      { key = 'b', mods = 'CTRL', action = act.CopyMode 'PageUp' },
      { key = 'd', mods = 'CTRL', action = act.CopyMode { MoveByPage = (0.5) } },
      { key = 'e', mods = 'NONE', action = act.CopyMode 'MoveForwardWordEnd' },
      { key = 'f', mods = 'NONE', action = act.CopyMode { JumpForward = { prev_char = false } } },
      { key = 'f', mods = 'CTRL', action = act.CopyMode 'PageDown' },
      { key = 'g', mods = 'NONE', action = act.CopyMode 'MoveToScrollbackTop' },
      { key = 'h', mods = 'NONE', action = act.CopyMode 'MoveLeft' },
      { key = 'j', mods = 'NONE', action = act.CopyMode 'MoveDown' },
      { key = 'k', mods = 'NONE', action = act.CopyMode 'MoveUp' },
      { key = 'l', mods = 'NONE', action = act.CopyMode 'MoveRight' },
      { key = 'm', mods = 'ALT', action = act.CopyMode 'MoveToStartOfLineContent' },
      { key = 'o', mods = 'NONE', action = act.CopyMode 'MoveToSelectionOtherEnd' },
      { key = 't', mods = 'NONE', action = act.CopyMode { JumpForward = { prev_char = true } } },
      { key = 'u', mods = 'CTRL', action = act.CopyMode { MoveByPage = (-0.5) } },
      { key = 'v', mods = 'NONE', action = act.CopyMode { SetSelectionMode =  'Cell' } },
      { key = 'v', mods = 'CTRL', action = act.CopyMode { SetSelectionMode =  'Block' } },
      { key = 'w', mods = 'NONE', action = act.CopyMode 'MoveForwardWord' },
      { key = 'y', mods = 'NONE', action = act.Multiple { { CopyTo =  'ClipboardAndPrimarySelection' }, { Multiple = { 'ScrollToBottom', { CopyMode =  'Close' } } } } },
      { key = 'PageUp', mods = 'NONE', action = act.CopyMode 'PageUp' },
      { key = 'PageDown', mods = 'NONE', action = act.CopyMode 'PageDown' },
      { key = 'End', mods = 'NONE', action = act.CopyMode 'MoveToEndOfLineContent' },
      { key = 'Home', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLine' },
    },

    search_mode = {
      { key = 'Escape', mods = 'NONE', action = act.CopyMode 'Close' },

      { key = 'n', mods = 'CTRL', action = act.CopyMode 'NextMatch' },
      { key = 'p', mods = 'CTRL', action = act.CopyMode 'PriorMatch' },

      { key = 'r', mods = 'CTRL', action = act.CopyMode 'CycleMatchType' },
      { key = 'u', mods = 'CTRL', action = act.CopyMode 'ClearPattern' },

      { key = 'PageDown', mods = 'NONE', action = act.CopyMode 'NextMatchPage' },
      { key = 'PageUp', mods = 'NONE', action = act.CopyMode 'PriorMatchPage' },

      { key = 'DownArrow', mods = 'NONE', action = act.CopyMode 'NextMatch' },
      { key = 'UpArrow', mods = 'NONE', action = act.CopyMode 'PriorMatch' },
    },
  }
}

for i = 1, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'ALT',
    action = act.ActivateTab(i - 1),
  })

  table.insert(config.keys, {
    key = tostring(i),
    mods = 'ALT|CTRL',
    action = act.MoveTab(i - 1),
  })
end

return config
