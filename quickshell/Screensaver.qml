import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

Item {
    id: root

    property bool active: false
    property int idleTimeout: 180
    property int suspendTimeout: 480

    // Showing the overlay delivers a synthetic pointer-enter event with the
    // current cursor position, which would otherwise immediately dismiss it.
    property bool dismissArmed: false

    onActiveChanged: {
        dismissArmed = false
        if (active) dismissArmTimer.restart()
    }

    Timer {
        id: dismissArmTimer
        interval: 400
        onTriggered: root.dismissArmed = true
    }

    IdleMonitor {
        timeout: root.idleTimeout
        onIsIdleChanged: root.active = isIdle
    }

    IdleMonitor {
        timeout: root.suspendTimeout
        onIsIdleChanged: if (isIdle) Quickshell.execDetached(["systemctl", "suspend"])
    }

    IpcHandler {
        target: "screensaver"

        function show(): void { root.active = true }
        function hide(): void { root.active = false }
        function toggle(): void { root.active = !root.active }
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData

            visible: root.active
            color: "#000000"

            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: root.active ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
            exclusionMode: ExclusionMode.Ignore

            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }

            MouseArea {
                id: cursorArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.BlankCursor
                onPositionChanged: if (root.dismissArmed) root.active = false
                onClicked: if (root.dismissArmed) root.active = false
            }

            Item {
                anchors.fill: parent
                focus: root.active

                Keys.onPressed: if (root.dismissArmed) root.active = false

                Canvas {
                    id: matrixRain
                    anchors.fill: parent

                    readonly property string chars: "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                    readonly property int fontSize: 18
                    property var drops: []

                    function reset() {
                        var columns = Math.max(1, Math.floor(width / fontSize))
                        var newDrops = []
                        for (var i = 0; i < columns; i++)
                            newDrops.push(Math.floor(Math.random() * height / fontSize))
                        drops = newDrops
                    }

                    onWidthChanged: reset()
                    onHeightChanged: reset()

                    onPaint: {
                        var ctx = getContext("2d")

                        ctx.fillStyle = "rgba(0, 0, 0, 0.08)"
                        ctx.fillRect(0, 0, width, height)

                        ctx.fillStyle = "#00ff41"
                        ctx.font = fontSize + "px monospace"

                        for (var i = 0; i < drops.length; i++) {
                            var char = chars.charAt(Math.floor(Math.random() * chars.length))
                            ctx.fillText(char, i * fontSize, drops[i] * fontSize)

                            if (drops[i] * fontSize > height && Math.random() > 0.975)
                                drops[i] = 0

                            drops[i]++
                        }
                    }

                    Timer {
                        interval: 50
                        running: root.active
                        repeat: true
                        onTriggered: matrixRain.requestPaint()
                    }
                }
            }
        }
    }
}
