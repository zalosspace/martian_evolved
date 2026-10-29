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

      Widget{
        anchors.centerIn: parent
        SystemClock {
          id: sysclock
          precision: SystemClock.Minutes
        }

        icon: "schedule"
        title: Qt.formatDateTime(sysclock.date, "hh:mm AP")
      }

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
