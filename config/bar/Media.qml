import Quickshell
import Quickshell.Io
import QtQuick
import Quickshell.Services.Mpris

Widget {
  icon: "music_note"

  property MprisPlayer activePlayer: Mpris.players.values[0]

  title: activePlayer ? (activePlayer.trackArtist
  + " - " + activePlayer.trackTitle).substr(0,28) : "Stagnant"
}

