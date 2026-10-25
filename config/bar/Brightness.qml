import QtQuick
import Quickshell.Io

Widget{

  function updateBrightness() {
    brightnessProc.running = true
  }

  property int currB: 0
  property int maxB: 0
  property int brightness: 0

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

  icon: "light_mode"
  title: brightness + "%"
}
