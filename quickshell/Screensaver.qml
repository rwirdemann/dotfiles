import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

Item {
    id: root

    property bool active: false
    property int idleTimeout: 300
    property int suspendTimeout: 480

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
                onPositionChanged: root.active = false
                onClicked: root.active = false
            }

            Item {
                anchors.fill: parent
                focus: root.active

                Keys.onPressed: root.active = false

                Item {
                    id: bouncer
                    width: clock.implicitWidth
                    height: clock.implicitHeight
                    x: parent.width / 2
                    y: parent.height / 2

                    property real dx: 1.6
                    property real dy: 1.1

                    Text {
                        id: clock
                        color: "#89b4fa"
                        font.pixelSize: 64
                        font.bold: true
                        text: Qt.formatDateTime(new Date(), "hh:mm")
                    }

                    Timer {
                        interval: 16
                        running: root.active
                        repeat: true
                        onTriggered: {
                            bouncer.x += bouncer.dx
                            bouncer.y += bouncer.dy

                            if (bouncer.x <= 0 || bouncer.x + bouncer.width >= bouncer.parent.width)
                                bouncer.dx = -bouncer.dx
                            if (bouncer.y <= 0 || bouncer.y + bouncer.height >= bouncer.parent.height)
                                bouncer.dy = -bouncer.dy
                        }
                    }

                    Timer {
                        interval: 1000
                        running: root.active
                        repeat: true
                        onTriggered: clock.text = Qt.formatDateTime(new Date(), "hh:mm")
                    }
                }
            }
        }
    }
}
