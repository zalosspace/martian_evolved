import Quickshell
import Quickshell.Io
import QtQuick
import Quickshell.Services.Mpris

Rectangle {
  id: root
  color: Qt.rgba(0.05,0.05,0.05,0.9)
  // color: "#040e0d"

  width: row.implicitWidth + 26
  height: bar.implicitHeight
  radius: height / 2

  property string icon: "music_note"
  // property string title: ""
  property int iconSize: 24
  property MprisPlayer activePlayer: Mpris.players.values[0]

  Process {
    id: playPause
    command: ["sh", "-c", "playerctl -a play-pause"]
  }
  Process {
    id: mediaPrev
    command: ["sh", "-c", "playerctl -a previous"]
  }
  Process {
    id: mediaNext
    command: ["sh", "-c", "playerctl -a next"]
  }

  MouseArea {
    anchors.fill: parent
    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

    onClicked: (e) => {
      if(e.button === Qt.LeftButton) {
        playPause.running = true
      }
      else if(e.button === Qt.MiddleButton) {
        mediaPrev.running = true
      }
      else if(e.button === Qt.RightButton) {
        mediaNext.running = true
      }
    }
  }

  property real progress: 0

  Timer {
    interval: 1000
    running: true
    repeat: true

    onTriggered: {
      if (root.activePlayer && root.activePlayer.length > 0) {
        if(activePlayer.position != activePlayer.length)
        root.progress = root.activePlayer.position / root.activePlayer.length
      }
    }
  }

  property string title: activePlayer ? (activePlayer.trackArtist + " - " + activePlayer.trackTitle).substr(0,28) : "Stagnant"

  Rectangle {
    anchors {
      left: parent.left
      top: parent.top
      bottom: parent.bottom
    }
    color: "#FF004D"
    opacity: 0.8
    width: parent.progress*parent.width
    radius: parent.radius
  }

  Row {
    id: row
    anchors.centerIn: parent
    spacing: 6

    Text {
      text: icon
      font.family: "Material Symbols Rounded"
      font.pixelSize: iconSize
      color: "white"
      anchors.verticalCenter: parent.verticalCenter
    }

    Text {
      id: med
      text: root.title
      anchors.verticalCenter: parent.verticalCenter
      color: "#f5e2c5"

      font {
        weight: 600
      }
    }
  }

}
