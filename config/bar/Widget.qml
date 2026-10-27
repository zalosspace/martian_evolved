import QtQuick
import Quickshell.Services.UPower

Rectangle {
  id: root
  color: Qt.rgba(0.05,0.05,0.05,0.85)
  // color: "#040e0d"
  
  width: row.implicitWidth + 26
  height: bar.implicitHeight
  radius: height / 2

  property string icon: "home"
  property string title: "null"
  property int iconSize: 24

  Row {
    id: row
    anchors.centerIn: parent
    spacing: 6

    Text {
      text: icon
      font.family: "Material Symbols Rounded"
      font.pixelSize: iconSize
      color: "white"
      font.variableAxes: ({
        // "FILL": 1,
      })

      // horizontalAlignment: Text.AlignHCenter
      anchors.verticalCenter: parent.verticalCenter
      // verticalAlignment: Text.AlignVCenter
    }

    Text {
      id: bat
      text: title
      anchors.verticalCenter: parent.verticalCenter
      color: "#f5e2c5"

      font {
        weight: 600
      }
    }
  }
}
