import Quickshell
import Quickshell.Io
import QtQuick

Widget {
  function updateCpuTemp() {
    cTempProc.running = true
  }

  property int cpuTemp: 0

  // CPU TEMPS
  Process {
    id: cTempProc
    command: ["sh", "-c", "cat /sys/class/thermal/thermal_zone0/temp"]
    stdout: SplitParser {
      onRead: data => {
        var temp = data.trim().split(/\s+/)
        cpuTemp = Math.round(temp[0]/1000)
      }
    }

    Component.onCompleted: running = true
  }

  icon: "thermometer"
  title: cpuTemp + " °C"
}
