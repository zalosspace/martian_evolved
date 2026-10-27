import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Pipewire

PanelWindow {
  id: osd
  visible: false
  // visible: true
  implicitHeight: 180

  implicitWidth: 180
  color: "transparent"
  BackgroundEffect.blurRegion: Region {
    item: osd.contentItem 
    radius: 20
  }

  anchors.bottom: true
  margins.bottom: 60

  exclusionMode: ExclusionMode.Ignore
  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

  property string mode: "brightness"
  property int brightness: 0

  readonly property real volume: Pipewire.defaultAudioSink?.audio.volume ?? 0
  readonly property bool muted: Pipewire.defaultAudioSink?.audio.muted ?? false

  PwObjectTracker { objects: [ Pipewire.defaultAudioSink ] }

  function show() {
    visible = true
    hideTimer.restart()
  }

  function showBrightness() {
    mode = "brightness"
    brightnessProc.running = true   // show() is called when the value arrives
  }

  function showVolume() {
    mode = "volume"
    show()
  }

  Timer {
    id: hideTimer
    interval: 1000
    onTriggered: osd.visible = false
  }

  IpcHandler {
    target: "osd"
    function showBrightness(): void { osd.showBrightness() }
    function showVolume(): void { osd.showVolume() }
  }

  Process {
    id: brightnessProc
    command: ["sh", "-c", "brightnessctl g; brightnessctl m"]
    stdout: StdioCollector {
      onStreamFinished: {
        const d = text.trim().split("\n")
        const max = parseInt(d[1])
        if (max > 0) osd.brightness = Math.round(parseInt(d[0]) / max * 100)
        osd.show()
      }
    }
  }

  Volume {
    onActivity: osd.showVolume()
  }

  Osd {
    icon: osd.mode === "volume" ? "volume_up" : "light_mode"
    label: osd.mode === "volume"
           ? (osd.muted ? "Muted" : Math.round(osd.volume * 100) + "%")
           : osd.brightness + "%"
  }

}
