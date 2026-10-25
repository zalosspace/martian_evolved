import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire

PanelWindow {
  id: osd
  implicitHeight: 180
  implicitWidth: 180
  color: "transparent"

  function showBrightness(){
    brightnessProc.running = true
    hideTimer.restart()
  }

  Process {
    id:brightnessProc
    command: ["sh", "-c", "brightnessctl g; brightnessctl m"]
    stdout: StdioCollector {
      onStreamFinished: {
        var d = text.trim().split("\n")

        currB = parseInt(d[0])
        maxB = parseInt(d[1])
        brightness = (currB / maxB) * 100
      }
    }

    Component.onCompleted: running = true
  }

  Rectangle {
    id: audioPill
    anchors.fill: parent
    color: "grey"
    radius: 20

    // Bind the sink so volume/mute properties are valid
    PwObjectTracker {
      objects: [ Pipewire.defaultAudioSink ]
    }

    readonly property real volume: Pipewire.defaultAudioSink?.audio.volume ?? 0
    readonly property bool muted:  Pipewire.defaultAudioSink?.audio.muted ?? false

    Text {
      id: volText
      anchors.centerIn: parent
      color: "#f5e2c5"
      font.weight: 600
      text: audioPill.muted ? "Muted" : `Volume: ${Math.round(audioPill.volume * 100)}%`
    }
  }


}
