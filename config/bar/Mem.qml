import Quickshell
import Quickshell.Io
import QtQuick

Widget {
  function updateMemUsage() {
    memProc.running = true
  }
  property int memUsage: 0

  Process {
    id: memProc
    command: ["sh", "-c", "free | grep Mem"]
    stdout: SplitParser {
      onRead: data => {
        var p = data.trim().split(/\s+/)
        var total = parseInt(p[1]) || 1
        var used = parseInt(p[2]) || 0
        memUsage = Math.round(100 * used / total)
      }
    }

    Component.onCompleted: running = true
  }

  icon: "memory_alt"
  title: memUsage + "%"
}
