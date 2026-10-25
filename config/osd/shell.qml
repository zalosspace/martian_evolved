import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire

PanelWindow {
    id: osd

    implicitWidth: 180
    implicitHeight: 180

    color: "transparent"
    visible: false

    property int currB: 0
    property int maxB: 1
    property real brightness: 0

    function showBrightness() {
        if (!brightnessProc.running)
            brightnessProc.running = true

        visible = true
        hideTimer.restart()
    }

    function showVolume() {
        visible = true
        hideTimer.restart()
    }

    Timer {
        id: hideTimer
        interval: 1500

        onTriggered: osd.visible = false
    }

    IpcHandler {
        target: "osd"

        function showBrightness(): void {
            osd.showBrightness()
        }

        function showVolume(): void {
            osd.showVolume()
        }
    }

    Process {
        id: brightnessProc

        command: ["sh", "-c", "brightnessctl g; brightnessctl m"]

        stdout: StdioCollector {
            onStreamFinished: {
                const values = text.trim().split(/\s+/)

                if (values.length >= 2) {
                    osd.currB = parseInt(values[0])
                    osd.maxB = parseInt(values[1])
                    osd.brightness = osd.maxB > 0
                        ? Math.round(osd.currB / osd.maxB * 100)
                        : 0
                }
            }
        }

        onRunningChanged: {
            if (!running)
                return
        }
    }

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    readonly property real volume:
        Pipewire.defaultAudioSink?.audio.volume ?? 0

    readonly property bool muted:
        Pipewire.defaultAudioSink?.audio.muted ?? false

    Rectangle {
        anchors.fill: parent
        color: "#040e0d"
        radius: 24
        border.width: 1
        border.color: "#3dd1b0"

        Column {
            anchors.centerIn: parent
            spacing: 14

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "󰃠"
                color: "#f5e2c5"
                font.pixelSize: 30
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: osd.brightness + "%"
                color: "#f5e2c5"
                font.pixelSize: 22
                font.weight: 600
            }

            Rectangle {
                width: 120
                height: 5
                radius: 3
                color: "#243b37"

                Rectangle {
                    width: parent.width * osd.brightness / 100
                    height: parent.height
                    radius: parent.radius
                    color: "#3dd1b0"
                }
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: osd.muted
                    ? "Muted"
                    : "Volume: " + Math.round(osd.volume * 100) + "%"
                color: "#f5e2c5"
                font.pixelSize: 13
            }
        }
    }
}
