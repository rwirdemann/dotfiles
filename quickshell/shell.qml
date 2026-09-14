import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Bluetooth

ShellRoot {
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

                Rectangle {
                    id: bluetoothWidget

                    property var adapter: Bluetooth.defaultAdapter
                    property int connectedCount: adapter ? adapter.devices.values.filter(d => d.connected).length : 0

                    width: btLabel.implicitWidth + 12
                    height: 22
                    radius: 4
                    color: bluetoothPopup.visible ? "#45475a" : "#313244"

                    Text {
                        id: btLabel
                        anchors.centerIn: parent
                        font.pixelSize: 12
                        color: !bluetoothWidget.adapter || !bluetoothWidget.adapter.enabled
                            ? "#6c7086"
                            : (bluetoothWidget.connectedCount > 0 ? "#89b4fa" : "#cdd6f4")
                        text: !bluetoothWidget.adapter
                            ? "BT --"
                            : !bluetoothWidget.adapter.enabled
                                ? "BT off"
                                : (bluetoothWidget.connectedCount > 0 ? "BT (" + bluetoothWidget.connectedCount + ")" : "BT on")
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: bluetoothPopup.visible = !bluetoothPopup.visible
                    }
                }
            }

            HyprlandFocusGrab {
                windows: [bluetoothPopup]
                active: bluetoothPopup.visible
                onCleared: bluetoothPopup.visible = false
            }

            PopupWindow {
                id: bluetoothPopup

                property var pairedDevices: bluetoothWidget.adapter
                    ? bluetoothWidget.adapter.devices.values
                        .filter(d => d.paired)
                        .sort((a, b) => Number(b.connected) - Number(a.connected))
                    : []

                visible: false
                anchor.window: bar
                anchor.rect.x: bar.width - width - 8
                anchor.rect.y: bar.height
                implicitWidth: 220
                implicitHeight: header.height + separator.height + body.implicitHeight + 24
                color: "#1e1e2e"

                Column {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 6

                    RowLayout {
                        id: header
                        width: parent.width

                        Text {
                            Layout.fillWidth: true
                            text: "Bluetooth"
                            color: "#cdd6f4"
                            font.bold: true
                            font.pixelSize: 13
                        }

                        Text {
                            text: bluetoothWidget.adapter && bluetoothWidget.adapter.enabled ? "An" : "Aus"
                            color: bluetoothWidget.adapter && bluetoothWidget.adapter.enabled ? "#89b4fa" : "#6c7086"
                            font.pixelSize: 12

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    if (bluetoothWidget.adapter)
                                        bluetoothWidget.adapter.enabled = !bluetoothWidget.adapter.enabled
                                }
                            }
                        }
                    }

                    Rectangle {
                        id: separator
                        width: parent.width
                        height: 1
                        color: "#313244"
                    }

                    Column {
                        id: body
                        width: parent.width
                        spacing: 2

                        Repeater {
                            model: bluetoothPopup.pairedDevices

                            delegate: Rectangle {
                                width: body.width
                                height: 26
                                radius: 4
                                color: deviceMouse.containsMouse ? "#313244" : "transparent"

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.leftMargin: 6
                                    anchors.rightMargin: 6

                                    Text {
                                        Layout.fillWidth: true
                                        text: modelData.name
                                        color: "#cdd6f4"
                                        font.pixelSize: 12
                                        elide: Text.ElideRight
                                    }

                                    Text {
                                        text: modelData.connected ? "Verbunden" : "Getrennt"
                                        color: modelData.connected ? "#a6e3a1" : "#6c7086"
                                        font.pixelSize: 11
                                    }
                                }

                                MouseArea {
                                    id: deviceMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: modelData.connected = !modelData.connected
                                }
                            }
                        }

                        Text {
                            visible: bluetoothPopup.pairedDevices.length === 0
                            text: !bluetoothWidget.adapter || !bluetoothWidget.adapter.enabled
                                ? "Bluetooth ist ausgeschaltet"
                                : "Keine gekoppelten Geräte"
                            color: "#6c7086"
                            font.pixelSize: 12
                        }
                    }
                }
            }
        }
    }
}
