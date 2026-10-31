import QtQuick
import Quickshell

Rectangle {
  property string label: ""
  property string icon: "volume_up"
  property real percent: 0

  id: root
  anchors.fill: parent

  // color: "#cc2b2b2b"
  color: Qt.rgba(0.1,0.1,0.1,0.7)
  radius: 20

  Text {
    text: icon
    anchors.centerIn: parent
    anchors.verticalCenterOffset: -15;
    anchors.horizontalCenter: parent.horizontalCenter
    font.family: "Material Symbols Rounded"
    font.pixelSize: 95
    color: "white"
    font.variableAxes: ({
      // "FILL": 1,
    })

  }

  Column {
    id: content

    anchors {
      left: parent.left
      right: parent.right
      bottom: parent.bottom
      leftMargin: 20
      rightMargin: 20
      bottomMargin: 22
    }

    spacing: 8

    Text {
      id: labelText

      anchors.horizontalCenter: parent.horizontalCenter

      text: root.label
      font.pixelSize: 20
      font.weight: 600
      color: "#f5e2c5"
    }

    Rectangle {
      id: progressBar

      width: parent.width
      height: 6
      radius: height / 2
      color: "grey"

      Rectangle {
        width: progressBar.width * Math.min(1, root.percent)
        height: parent.height
        radius: height / 2
        color: "white"
      }
    }
  }

}
