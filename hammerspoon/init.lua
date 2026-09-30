-- Hammerspoon Konfiguration

-- Alt+Shift+B: Safari öffnen bzw. nach vorne holen
hs.hotkey.bind({ "alt", "shift" }, "b", function()
  hs.application.launchOrFocus("Safari")
end)

-- Alt+Shift+N: neues Safari-Fenster (startet Safari, falls es noch nicht läuft)
hs.hotkey.bind({ "alt", "shift" }, "n", function()
  local safari = hs.application.get("Safari")
  if not safari then
    hs.application.launchOrFocus("Safari")
    return
  end

  -- "make new document" statt Menü-Eintrag, damit es unabhängig von der
  -- Sprache der Safari-Oberfläche funktioniert.
  local ok = hs.osascript.applescript('tell application "Safari" to make new document')
  if ok then
    safari:activate()
  else
    hs.alert.show("Neues Safari-Fenster fehlgeschlagen")
  end
end)

-- Alt+Shift+R: Konfiguration neu laden
hs.hotkey.bind({ "alt", "shift" }, "r", function()
  hs.reload()
end)

hs.alert.show("Hammerspoon config geladen")
