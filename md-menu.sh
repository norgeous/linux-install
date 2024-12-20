#!/bin/bash

function title {
  P='\033[1;35m' # purple
  C='\033[1;36m' # cyan
  N='\033[0m' # color off
  length=${#1}
  width=$((length + 4))
  echo -en "${C}"
  printf %${width}s | tr " " "#"
  echo
  echo -e "# ${P}$1${C} #"
  printf %${width}s | tr " " "#"
  echo -e "${N}\n"
}

function log {
  C='\033[1;36m' # cyan
  N='\033[0m' # color off
  echo -e "🧌  ${C}$1${N}\n"
}

function commentOut {
  sed -i "/$1/s/^/#/" "$2"
}

function uncomment {
  sed -i "/$1/s/^#//" "$2"
}

function whipit {
  TITLE="$1"
  OPTIONS=$2
  CHOICES=$(\
    whiptail --title $TITLE --checklist \
    "Use Up / Down and Space to select.\nEnter to start.\nEsc to cancel." 21 77 12 \
    $OPTIONS \
  3>&1 1>&2 2>&3)

  echo $CHOICES
}

function runChoices {
  for i in $1; do
    log "Working on $i..."



    echo

    sleep 1
  done
}

md=$(cat $1)


# mapfile < <(echo -n "$md") -td \# -c 1 -C myPubliMail


log "Done."
echo "Press any key to exit..."
echo
read -rsn1 -p ""
