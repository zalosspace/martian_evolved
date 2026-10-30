import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Services.UPower
import QtQuick
import QtQuick.Layouts

ShellRoot {
  Variants {
    model: Quickshell.screens

    PanelWindow{
      required property var modelData
      screen: modelData

      id: bar

      Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
          brightness.updateBrightness()
          cpuUsage.updateCpuUsage()
          cpuTemp.updateCpuTemp()
          memUsage.updateMemUsage()
        }
      }

      anchors {
        top: true
        left: true
        right: true
      }

      margins {
        top: 15
        left: 15
        right: 15
      }

      implicitHeight: 36
      color: "transparent"

      Row {
        anchors.left: parent.left
        spacing: 6
        Workspace{}
        Media{}
      }

      // Clock
      Rectangle {
        id: clock
        color: Qt.rgba(0.05,0.05,0.05,0.9)
        // color: "#040e0d"
        property bool hovered: false

        width: hovered ? row.implicitWidth+15 : row.implicitWidth + 15 
        height: bar.implicitHeight
        radius: height / 2
        anchors.centerIn: parent
        SystemClock {
          id: sysclock
          precision: SystemClock.Minutes
        }

        Behavior on width {
          NumberAnimation {
            duration: 350;
            easing.type: Easing.OutBack
          }
        }

        MouseArea {
          anchors.fill: parent
          hoverEnabled: true
          onContainsMouseChanged: clock.hovered = containsMouse
        }

        property string icon: "schedule"
        property string title: hovered ? 
        Qt.formatDateTime(sysclock.date, "dd MMM hh:mm AP dddd")
        : Qt.formatDateTime(sysclock.date, "hh:mm AP")
        property int iconSize: 24

        Row {
          id: row
          anchors.centerIn: parent
          spacing: 6

          Text {
            text: clock.icon
            font.family: "Material Symbols Rounded"
            font.pixelSize: clock.iconSize
            color: "white"
            font.variableAxes: ({
              // "FILL": 1,
            })

            // horizontalAlignment: Text.AlignHCenter
            anchors.verticalCenter: parent.verticalCenter
            // verticalAlignment: Text.AlignVCenter
          }

          Text {
            id: bat
            text: clock.title
            property int iconSize: 24
            anchors.verticalCenter: parent.verticalCenter
            color: "#f5e2c5"

            Behavior on opacity {
              NumberAnimation {
                duration: 1000;
                easing.type: Easing.OutBack
              }
            }


            font {
              weight: 600
            }
          }
        }
      }
      //----

      Row {
        anchors.right: parent.right
        spacing: 6

        // Media Volume Widget
        Widget{
          id:audioPill

          PwObjectTracker {
            objects: [ Pipewire.defaultAudioSink ]
          }

          readonly property real volume: Pipewire.defaultAudioSink?.audio.volume ?? 0
          readonly property bool muted:  Pipewire.defaultAudioSink?.audio.muted ?? false
          Process {
            id: incVol
            command: ["sh", "-c", "pactl set-sink-volume @DEFAULT_SINK@ +5%"]
          }
          Process {
            id: decVol
            command: ["sh", "-c", "pactl set-sink-volume @DEFAULT_SINK@ -5%"]
          }

          icon: "volume_up"
          title: audioPill.muted ? "Muted" : `${Math.round(audioPill.volume * 100)}%`

          MouseArea {
            anchors.fill: audioPill

            onWheel: (wheel) => {
              // Scrolled Up
              if (wheel.angleDelta.y > 0) {
                incVol.running = true
              }
              else {
                decVol.running = true
              }
            }
          }
        }

        Brightness{
          id: brightness
        }
        Cpu{
          id: cpuUsage
        }
        Mem{
          id: memUsage
        }
        CpuTemp{
          id: cpuTemp
        }

        Widget{
          icon: "battery_android_full"
          title: `${Math.round(UPower.displayDevice.percentage * 100)}%`
        }

      }

    }
  } // Variant
} // ShellRoot
