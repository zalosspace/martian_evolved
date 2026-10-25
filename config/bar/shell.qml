import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Services.UPower
import QtQuick
import QtQuick.Layouts

PanelWindow{
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
    anchors.left: parent
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


    Widget{
      id:audioPill
    // Media Volume Widget
    PwObjectTracker {
      objects: [ Pipewire.defaultAudioSink ]
    }

    readonly property real volume: Pipewire.defaultAudioSink?.audio.volume ?? 0
    readonly property bool muted:  Pipewire.defaultAudioSink?.audio.muted ?? false

      icon: "volume_up"
      title: audioPill.muted ? "Muted" : `${Math.round(audioPill.volume * 100)}%`
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
