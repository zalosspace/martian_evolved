import QtQuick
import Quickshell

Rectangle {
  property string label: ""
  property string icon: "volume_up"

  id: root
  anchors.fill: parent

  // color: "#cc2b2b2b"
  color: Qt.rgba(0.1,0.1,0.1,0.7)
  radius: 20

  Column {
    id: row
    anchors.centerIn: parent
    spacing: 5

    Text {
      text: icon
      font.family: "Material Symbols Rounded"
      font.pixelSize: 100
      color: "white"
      font.variableAxes: ({
        // "FILL": 1,
      })

      anchors.horizontalCenter: parent.horizontalCenter
    }

    Text {
      id: bat
      text: root.label
      font.pixelSize: 20
      anchors.horizontalCenter: parent.horizontalCenter
      color: "#f5e2c5"

      font {
        weight: 600
      }
    }
  }
}
