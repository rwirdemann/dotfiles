-- Hammerspoon Konfiguration

-- Alt+Shift+B: Safari öffnen bzw. nach vorne holen
hs.hotkey.bind({ "alt", "shift" }, "b", function()
  hs.application.launchOrFocus("Safari")
end)

-- Alt+Shift+R: Konfiguration neu laden
hs.hotkey.bind({ "alt", "shift" }, "r", function()
  hs.reload()
end)

hs.alert.show("Hammerspoon config geladen")
