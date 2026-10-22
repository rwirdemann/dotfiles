-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

local omarchy_gdk_scale = 2
local omarchy_monitor_scale = 1.6

hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = omarchy_monitor_scale })

-- Configure a specific monitor.
-- hl.monitor({ output = "DP-1", mode = "preferred", position = "auto", scale = 1.5 })

-- Portrait/rotated secondary monitor (transform: 1 = 90°, 3 = 270°).
-- hl.monitor({ output = "DP-2", mode = "preferred", position = "auto", scale = 1, transform = 1 })
--
hl.monitor({
  output   = "desc:LG Electronics LG ULTRAFINE 405NTGYCG231",
  mode     = "3840x2160@60",
  position = "0x0",
  scale    = 1.6,
})

hl.monitor({
  output   = "desc:Dell Inc. DELL U3225QE CCN8MF4",
  mode     = "3840x2160@60",
  position = "0x0",
  scale    = 1.5,
})
