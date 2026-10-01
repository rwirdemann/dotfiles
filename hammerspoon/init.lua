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

-- Alt+Shift+M: Mail öffnen bzw. nach vorne holen
hs.hotkey.bind({ "alt", "shift" }, "m", function()
  hs.application.launchOrFocus("Mail")
end)

-- Alt+Shift+S: Slack öffnen bzw. nach vorne holen
hs.hotkey.bind({ "alt", "shift" }, "s", function()
  hs.application.launchOrFocus("Slack")
end)

-- Cmd+Enter: Ghostty starten bzw. nach vorne holen
hs.hotkey.bind({ "cmd" }, "return", function()
  hs.application.launchOrFocus("Ghostty")
end)

-- Nächstes Nachbarfenster in einer Richtung. frontmost=true bevorzugt
-- unverdeckte Fenster, strict=true ignoriert Fenster, die eher diagonal als
-- seitlich liegen. Die Liste ist nach Abstand sortiert, [1] ist die Nachbarin.
local function neighbour(win, direction)
  local candidates
  if direction == "west" then
    candidates = win:windowsToWest(nil, true, true)
  else
    candidates = win:windowsToEast(nil, true, true)
  end
  return candidates and candidates[1]
end

-- Gemeinsames Gerüst für Fokus und Tausch: Fenster suchen, sonst Alert.
local function withNeighbour(direction, action)
  local win = hs.window.focusedWindow()
  if not win then
    hs.alert.show("Kein fokussiertes Fenster")
    return
  end

  local other = neighbour(win, direction)
  if not other then
    hs.alert.show("Kein Fenster " .. (direction == "west" and "links" or "rechts"))
    return
  end

  action(win, other)
end

-- Alt+Links / Alt+Rechts: Fokus auf das Nachbarfenster
local function focusNeighbour(direction)
  withNeighbour(direction, function(_, other)
    other:focus()
  end)
end

-- Alt+Shift+Links / Alt+Shift+Rechts: fokussiertes Fenster mit dem Nachbarn in
-- Pfeilrichtung tauschen. Dauer 0, weil zwei gleichzeitig animierte
-- setFrame-Aufrufe unzuverlässig sind.
local function swapWithNeighbour(direction)
  withNeighbour(direction, function(win, other)
    local mine, theirs = win:frame(), other:frame()
    win:setFrame(theirs, 0)
    other:setFrame(mine, 0)
  end)
end

hs.hotkey.bind({ "alt" }, "left", function()
  focusNeighbour("west")
end)

hs.hotkey.bind({ "alt" }, "right", function()
  focusNeighbour("east")
end)

hs.hotkey.bind({ "alt", "shift" }, "left", function()
  swapWithNeighbour("west")
end)

hs.hotkey.bind({ "alt", "shift" }, "right", function()
  swapWithNeighbour("east")
end)

-- Alt+Shift+R: Konfiguration neu laden
hs.hotkey.bind({ "alt", "shift" }, "r", function()
  hs.reload()
end)

hs.alert.show("Hammerspoon config geladen")
