import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Bluetooth
import Quickshell.Hyprland

Rectangle {
    id: root

    required property var barWindow

    property var adapter: Bluetooth.defaultAdapter
    property int connectedCount: adapter ? adapter.devices.values.filter(d => d.connected).length : 0

    width: btLabel.implicitWidth + 12
    height: 22
    radius: 4
    color: popup.visible ? "#45475a" : "#313244"

    Text {
        id: btLabel
        anchors.centerIn: parent
        font.pixelSize: 12
        color: !root.adapter || !root.adapter.enabled
            ? "#6c7086"
            : (root.connectedCount > 0 ? "#89b4fa" : "#cdd6f4")
        text: !root.adapter
            ? "BT --"
            : !root.adapter.enabled
                ? "BT off"
                : (root.connectedCount > 0 ? "BT (" + root.connectedCount + ")" : "BT on")
    }

    MouseArea {
        anchors.fill: parent
        onClicked: popup.visible = !popup.visible
    }

    HyprlandFocusGrab {
        windows: [popup]
        active: popup.visible
        onCleared: popup.visible = false
    }

    PopupWindow {
        id: popup

        property var pairedDevices: root.adapter
            ? root.adapter.devices.values
                .filter(d => d.paired)
                .sort((a, b) => Number(b.connected) - Number(a.connected))
            : []

        visible: false
        anchor.window: root.barWindow
        anchor.rect.x: root.barWindow.width - width - 8
        anchor.rect.y: root.barWindow.height
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
                    text: root.adapter && root.adapter.enabled ? "An" : "Aus"
                    color: root.adapter && root.adapter.enabled ? "#89b4fa" : "#6c7086"
                    font.pixelSize: 12

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (root.adapter)
                                root.adapter.enabled = !root.adapter.enabled
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
                    model: popup.pairedDevices

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
                    visible: popup.pairedDevices.length === 0
                    text: !root.adapter || !root.adapter.enabled
                        ? "Bluetooth ist ausgeschaltet"
                        : "Keine gekoppelten Geräte"
                    color: "#6c7086"
                    font.pixelSize: 12
                }
            }
        }
    }
}
