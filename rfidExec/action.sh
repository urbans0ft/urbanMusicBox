#!/bin/sh

case $1 in

  "0002692969") # Leo Lausemaus
    echo "Playing Leo Lausemaus"
    mpc stop
    mpc clear
    mpc add spotify:album:5N73vwGXol4maS9U6HLp0o
    mpc add spotify:album:1zUT3P9v5P0o4Gd9DOoEMB
    mpc play
    ;;

  "0003155558") # Paw Patrol ab Folge 20
    echo "Playing Paw Patrol"
    mpc stop
    mpc clear
    mpc add spotify:album:5IriWXKSgCBYrUV6mFUQ4J
    mpc add spotify:album:0pSKPNp8tdaMnK9OPJyhYM
    mpc add spotify:album:5eRFTLxfY27mjxcziGB2JB
    mpc add spotify:album:29NgDLwnmYrrv40of94pU7
    mpc add 
    mpc play
    ;;

  "0006589063") # Patrick Star
    echo "Playing Missi Moppel"
    mpc stop
    mpc clear
    mpc add spotify:album:04xiRsBM5EsVBzsJpXMU9x
    mpc play
    ;;

  "0006590985")
    echo "Playing Benjamin Blümchen"
    mpc stop
    mpc clear
    mpc add spotify:playlist:5R50okmj6HSRKZ4SJnhkyI
    mpc play
    ;;

  "0006587026")
    echo "Playing Mila Playlist"
    mpc stop
    mpc clear
    mpc add spotify:playlist:2iYuRQv7qCLDe0gVF413p9
    mpc play
    ;;

  "0006649015")
    echo "Playing Eiskönigin"
    mpc stop
    mpc clear
    mpc add spotify:album:3E20g5xQv0OcWTeRTTb91N
    mpc play
    ;;

  "0006579459")
    echo "Playing Petronella Apfelmus Vol. 6"
    mpc stop
    mpc clear
    mpc add spotify:album:7l35B8kX77pEfP2S2Z1Wgl
    mpc play
    ;;

  "0002781285") # Karte: Pippi Langstrumpf
    echo "Pippi Langstrump (Ungekürtze Lesung) 2007"
    mpc stop
    mpc clear
    mpc add spotify:album:3qucYGlD71Vwx5ZynBPgvj
    mpc play
    ;;

  "0014969366") # Karte: Wickie Vol. 3 2015
    echo "Wickie 01/Wasser auf die Mühlen"
    mpc stop
    mpc clear
    mpc add spotify:album:2tU47IvruPorwTXemNvtPm
    mpc play
    ;;

  "0014970595") # Karte: Feuerwehmann Sam 11-15
    echo "Feuerwehmann Sam Folgen 11-15"
    mpc stop
    mpc clear
    mpc add spotify:album:51pYYWk4Rst8sLqixSaJi6
    mpc play
    ;;

  "0015013925") # Karte: Peppa 002/Kürbis Wettbewerg
    mpc stop
    mpc clear
    mpc add spotify:album:2mxbDEZtXDOSVqWFCIpKSc
    mpc play
    ;;

  "0015014620") # Karte: Yakari Kapitel 3
    mpc stop
    mpc clear
    mpc add spotify:album:3zp8KClWgYenFNdQZiFHtd
    mpc play
    ;;

  "0015013984") # Karte: Der Grüffelo & Das Grüffelokind
    mpc stop
    mpc clear
    mpc add spotify:playlist:47wSlIWvY2Pl96kjd9r79F
    mpc play
    ;;

  "0015014678") # Karte: Petersson und Findus Folge 3
    mpc stop
    mpc clear
    mpc add spotify:album:4L8sq9jBYuW1pVeIUteUk7
    mpc play
    ;;

  "0014970399") # Karte: Biene Maja 03/Maja und der Regenwurm Max
    mpc stop
    mpc clear
    mpc add spotify:album:7IWaaCsBw7d1H7mWiD33IB
    mpc play
    ;;

  "0015013360") # Karte: Unser Sandmännchen 001
    mpc stop
    mpc clear
    mpc add spotify:album:3Yd2IJwywlurTtykho0aPk
    mpc play
    ;;

  "0015012643") # Karte: Snöfrid
    mpc stop
    mpc clear
    mpc add spotify:album:1aPFYDBbqglYnOGtR4fVpV
    mpc play
    ;;
  "0002726173")
    mpc stop
    mpc clear
    mpc add spotify:album:0J9qARgWchtq5D3jgl76tt
    mpc play
    ;;

  "0002701357") # Dr. Brumm Bär
    mpc stop
    mpc clear
    mpc add spotify:album:17LPezj1bvPGE3iUO3aekk
    mpc play
    ;;

  "0002754583") # 
    mpc stop
    mpc clear
    mpc add spotify:album:1RkGZoAIr6jPxFmmQ8uMiX
    mpc play
    ;;

  "0002770944") # Bibi & Tina Folge 3
    mpc stop
    mpc clear
    mpc add spotify:album:3bDEQvhX2MSbBqPkaqru0V
    mpc play
    ;;

  "0002774444") # radio
    mpc stop
    mpc clear
    mpc add "https://wdr-diemaus-live.icecastssl.wdr.de/wdr/diemaus/live/mp3/128/stream.mp3"
    mpc play
    ;;

  "0002662922") # der kleine Prinz
    mpc stop
    mpc clear
    mpc add spotify:album:30xJ0rpsqvI9a5bfhIQe2Z
    mpc play
    ;;

  "0003200166") # Rabe Socke Alles Schule
    echo "Playing Rabe Socke"
    mpc stop
    mpc clear
    mpc add spotify:album:1xIoDQdHmg2IaqenXPIj8t 
    mpc play
    ;;

  *)
    echo "No command found for $1"
    ;;

esac

