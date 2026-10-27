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

  Process {
    id: incBri
    command: ["sh", "-c", "brightnessctl -e4 set 5%+"]
  }
  Process {
    id: decBri
    command: ["sh", "-c", "brightnessctl -e4 set 5%-"]
  }

  icon: "light_mode"
  title: brightness + "%"

  MouseArea {
    anchors.fill: parent

    onWheel: (wheel) => {
      if (wheel.angleDelta.y > 0) {
        incBri.running = true
      }
      else {
        decBri.running = true
      }
    }
  }
}
