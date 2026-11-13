-- ╭─────────────────────────────────────────────────────────────────────────╮
-- │  Omadux look'n'feel — DUX Shell styling reference for Omarchy           │
-- │  Optional reference specification for Neovim / Hyprland borders & blur │
-- ╰─────────────────────────────────────────────────────────────────────────╯

local vars = {
  -- Blur
  blurEnabled = true,
  blurSpecialWs = false,
  blurPopups = true,
  blurInputMethods = true,
  blurSize = 8,
  blurPasses = 2,
  blurXray = false,

  -- Shadow
  shadowEnabled = true,
  shadowRange = 15,
  shadowRenderPower = 4,

  -- Gaps
  workspaceGaps = 20,
  windowGapsIn = 5,
  windowGapsOut = 10,
  singleWindowGapsOut = 20,

  -- Window styling
  windowOpacity = 0.95,
  windowRounding = 12,
  windowBorderSize = 2,
}

return vars
