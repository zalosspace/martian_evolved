import Quickshell
import Quickshell.Io
import QtQuick
import Quickshell.Services.Mpris

Widget {
  icon: "music_note"

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

  title: activePlayer ? (activePlayer.trackArtist
  + " - " + activePlayer.trackTitle).substr(0,28) : "Stagnant"
}

