-- Pull in the wezterm API
local wezterm = require("wezterm")

local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
-- local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")
local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
local config = wezterm.config_builder()

-- config.color_scheme = "Black Metal (Bathory) (base16)"
config.color_scheme = "Black Metal (Bathory) (base16)"

config.font_size = 13.0
config.window_padding = {
	left = 2,
	right = 2,
	top = 3,
	bottom = 0,
}
config.window_background_opacity = 0.90
config.line_height = 1.1
-- config.dpi = 109
config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 1500 }

local act = wezterm.action
config.keys = {
  -- clear:
  {
    key = "l",
    mods = "LEADER|CTRL",
    action = act.SendKey { key = 'L', mods = 'CTRL' },
    -- action = act.SendString 'clear',
  },
  -- tmux emulation:
	{ key = "[", mods = "LEADER", action = act.ActivateCopyMode },
	{
		key = '"',
		mods = "LEADER|SHIFT",
		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "%",
		mods = "LEADER|SHIFT",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "x",
		mods = "LEADER",
		action = act.CloseCurrentPane({ confirm = true }),
	},
	{
		key = "c",
		mods = "LEADER",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	{ key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
	{ key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
	{
		mods = "LEADER",
		key = "q",
		action = wezterm.action.RotatePanes("Clockwise"),
	},
	{
		key = "z",
		mods = "LEADER",
		action = wezterm.action.TogglePaneZoomState,
	},

  -- session stuff:
	{
		key = "s",
		mods = "LEADER",
		action = act.ShowLauncherArgs({
			flags = "FUZZY|WORKSPACES",
      title = "WORKSPACES",
		}),
	},
	{
		key = "w",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { AnsiColor = "Fuchsia" } },
				{ Text = "Enter name for new workspace" },
			}),
			action = wezterm.action_callback(function(window, pane, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					window:perform_action(
						act.SwitchToWorkspace({
							name = line,
						}),
						pane
					)
				end
			end),
		}),
	},

  -- resurrect:
  -- {
  --   key = "w",
  --   mods = "ALT",
  --   action = wezterm.action_callback(function(win, pane)
  --       resurrect.state_manager.save_state(resurrect.workspace_state.get_workspace_state())
  --     end),
  -- },
  -- {
  --   key = "W",
  --   mods = "ALT",
  --   action = resurrect.window_state.save_window_action(),
  -- },
  -- {
  --   key = "T",
  --   mods = "ALT",
  --   action = resurrect.tab_state.save_tab_action(),
  -- },
  -- {
  --   key = "s",
  --   mods = "ALT",
  --   action = wezterm.action_callback(function(win, pane)
  --       resurrect.state_manager.save_state(resurrect.workspace_state.get_workspace_state())
  --       resurrect.window_state.save_window_action()
  --     end),
  -- },
}

smart_splits.apply_to_config(config, {
	-- order: left, down, up, right
	direction_keys = { "h", "j", "k", "l" },

	-- modifier keys to combine with direction_keys
	modifiers = {
    move = "CTRL", -- modifier to use for pane movement, e.g. CTRL+h to move left
		resize = "META", -- modifier to use for pane resize, e.g. META+h to resize to the left
	},
	-- log level to use: info, warn, error
	log_level = "error",
})

-- BAR:
config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
config.tab_max_width = 32
-- config.window_decorations = 'RESIZE'
config.tab_bar_at_bottom = true
config.status_update_interval = 500

tabline.setup({
  options = {
    icons_enabled = true,
    theme = config.color_scheme,
    tabs_enabled = true,
    theme_overrides = {},
    section_separators = {
      -- left = wezterm.nerdfonts.pl_left_hard_divider,
      -- right = wezterm.nerdfonts.pl_right_hard_divider,
      left = "",
      right = "",
    },
    component_separators = {
      left = "",
      right = "",
      -- left = wezterm.nerdfonts.pl_left_soft_divider,
      -- right = wezterm.nerdfonts.pl_right_soft_divider,
    },
    tab_separators = {
      left = wezterm.nerdfonts.pl_left_hard_divider,
      right = wezterm.nerdfonts.pl_right_hard_divider,
    },
  },
  sections = {
    tabline_a = { 'mode' },
    tabline_b = {},
    tabline_c = { '' },
    tab_active = {'index', {'process', padding = {left = 0, right = 1}}},
    --  {
    --   'index',
    --   { 'parent', padding = 0 },
    --   '/',
    --   { 'cwd', padding = { left = 0, right = 1 } },
    --   { 'zoomed', padding = 0 },
    -- },
    tab_inactive = { 'index', { 'process', padding = { left = 0, right = 1 } } },
    tabline_x = {},
    tabline_y = {'workspace'},
    tabline_z = { 'domain' },
  },
  extensions = {},
})

-- and finally, return the configuration to wezter
return config
