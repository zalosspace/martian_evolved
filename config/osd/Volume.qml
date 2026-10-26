import QtQuick
import Quickshell.Services.Pipewire

Rectangle {
  id: audioPill

  signal activity()                 // emitted when volume or mute changes
  property real pillHeight: 40

  color: "#040e0d"
  width: volText.implicitWidth + 26
  height: pillHeight
  radius: height / 2

  PwObjectTracker { objects: [ Pipewire.defaultAudioSink ] }

  readonly property real volume: Pipewire.defaultAudioSink?.audio.volume ?? 0
  readonly property bool muted:  Pipewire.defaultAudioSink?.audio.muted ?? false

  // ignore the spurious change when the sink first binds at startup
  property bool ready: false
  Timer { interval: 1000; running: true; onTriggered: audioPill.ready = true }

  Connections {
    target: Pipewire.defaultAudioSink?.audio ?? null
    function onVolumeChanged() { if (audioPill.ready) audioPill.activity() }
    function onMutedChanged()  { if (audioPill.ready) audioPill.activity() }
  }
}
