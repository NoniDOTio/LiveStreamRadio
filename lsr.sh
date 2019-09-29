#!/bin/bash
. ./config.sh

# Constants
PLAYER_SCREEN_NAME="lsr_player"
STREAM_SCREEN_NAME="lsr_stream"
VERSION="1.0.0-alpha"


function main() {
  if [[ $# -eq 0 ]]; then
    echo "Please supply at least one argument. Type --help for help"
    exit 1
  elif [[ $# -gt 2 ]]; then
    echo "Too many arguments. Type --help for help"
    exit 1
  else
    case "$1" in
      "-h"|"--help"     )
        help
        ;;
      "-v"|"--version"  )
        echo "${VERSION}"
        ;;
      "-s"|"--start"    )
        if [ -z ${2+x} ]; then start "all"; else start "${2}"; fi
        ;;
      "-r"|"--restart"  )
        if [ -z ${2+x} ]; then restart "all"; else restart "${2}"; fi
        ;;
      "-q"|"--quit"     )
        if [ -z ${2+x} ]; then quit "all"; else quit "${2}"; fi
        ;;
      *                 )
        echo "Invalid argument(s). Type --help for help"
        exit 1
        ;;
    esac
  fi
}

#
# Displays help menu
#
function help() {
  echo "LiveStreamRadio ${VERSION}"
  echo ""
  echo "Print help / information:"
  echo "-h                Show help"
  echo "-v                Show version info"
  echo ""
  echo "General:"
  echo "-s <arg>          Start <player/stream/all> (Default: all)"
  echo "--start <arg>     \""
  echo "-q <arg>          Stop <player/stream/all> (Default: all)"
  echo "--quit <arg>      \""
  echo "-r <arg>          Restart <player/stream/all> (Default: all)"
  echo "--restart <arg>   \""
  echo ""
  echo "Visit https://github.com/NoniDOTio/LiveStreamRadio if you need more help"
}

#
# Start stream and player
#
function start() {
  if [ -z ${1+x} ]; then
    start_player
    start_stream
  else
    if [ ${1} = "all" ]; then
      start_player
      start_stream
    elif [ ${1} = "player" ]; then
      start_player
    elif [ ${1} = "stream" ]; then
      start_stream
    else
      echo "Unable to start requested ressource"
    fi
  fi
}

#
# Start stream and player
#
function restart() {
  if [ -z ${1+x} ]; then
    stop_stream
    stop_player
    sleep 1
    start_player
    start_stream
  else
    if [ ${1} = "all" ]; then
      stop_stream
      stop_player
      sleep 1
      start_player
      start_stream
    elif [ ${1} = "player" ]; then
      stop_player
      sleep 1
      start_player
    elif [ ${1} = "stream" ]; then
      stop_stream
      sleep 1
      start_stream
    else
      echo "Unable to restart requested ressource"
    fi
  fi
}

#
# Stop stream and player
#
function quit() {
  if [ -z ${1+x} ]; then
    stop_player
    stop_stream
  else
    if [ ${1} = "all" ]; then
      stop_stream
      stop_player
    elif [ ${1} = "player" ]; then
      stop_player
    elif [ ${1} = "stream" ]; then
      stop_stream
    else
      echo "Unable to stop requested ressource"
    fi
  fi
}

#
# Start player
#
function start_player() {
  screen_exists "${PLAYER_SCREEN_NAME}"
  player_running=$?
  if [ $player_running -eq 0 ]; then
    echo "${PLAYER_SCREEN_NAME} is already running"
  else
    find $MUSIC_FOLDER -name "*.mp3" > ${SCRIPT_DIR}/playlist.txt
    screen_create "$PLAYER_SCREEN_NAME" "$SCRIPT_DIR/player.sh"
  fi
}

#
# Start stream
#
function start_stream() {
  screen_exists "${STREAM_SCREEN_NAME}"
  stream_running=$?
  if [ $stream_running -eq 0 ]; then
    echo "${STREAM_SCREEN_NAME} is already running"
  else
    screen_create "$STREAM_SCREEN_NAME" "$SCRIPT_DIR/stream.sh"
  fi
}

#
# Start player
#
function stop_player() {
  screen_send "$PLAYER_SCREEN_NAME" "q^M"
  sleep 1
  screen_quit "$PLAYER_SCREEN_NAME"
}

#
# Start stream
#
function stop_stream() {
  screen_send "$STREAM_SCREEN_NAME" "q^M"
  sleep 7
  screen_quit "$STREAM_SCREEN_NAME"
}

#
# Run bash file in screen
#
function screen_create() {
  echo "Starting ${1}..."
  screen -dmS $1 bash -c "$2"
}

#
# Checks whether a screen exists
#
function screen_exists() {
    screen -list | grep -q "$1"
    return $?
}

#
# Sends keys to a screen
#
function screen_send() {
  screen -S "$1" -X stuff "$2"
}

#
# Attempts to quit a screen
#
function screen_quit() {
  echo "Quitting ${1}..."
  screen -S "$1" -X quit
}

main $@