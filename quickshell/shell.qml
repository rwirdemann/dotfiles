import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

ShellRoot {
    Screensaver {}

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bar
            required property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }
            implicitHeight: 30
            color: "#1e1e2e"

            RowLayout {
                anchors.left: parent.left
                anchors.leftMargin: 8
                anchors.verticalCenter: parent.verticalCenter
                spacing: 6

                Repeater {
                    model: 5

                    delegate: Rectangle {
                        property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
                        property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)

                        width: 28
                        height: 22
                        radius: 4
                        color: isActive ? "#89b4fa" : (ws ? "#313244" : "#444b6a")

                        Text {
                            anchors.centerIn: parent
                            text: index+1
                            color: isActive ? "#1e1e2e" : "#cdd6f4"
                            font.bold: isActive
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: Hyprland.dispatch("hl.dsp.focus({ workspace = " + wsId + " })")
                        }
                    }
                }
            }

            Text {
                anchors.centerIn: parent
                color: "#cdd6f4"
                font.pixelSize: 13
                text: Qt.formatDateTime(new Date(), "dd.MM.yyyy hh:mm")

                Timer {
                    interval: 60000
                    running: true
                    repeat: true
                    onTriggered: parent.text = Qt.formatDateTime(new Date(), "dd.MM.yyyy hh:mm")
                }
            }

            RowLayout {
                anchors.right: parent.right
                anchors.rightMargin: 8
                anchors.verticalCenter: parent.verticalCenter
                spacing: 6

                BluetoothWidget {
                    barWindow: bar
                }
            }
        }
    }
}
