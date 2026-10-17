#!/bin/sh

# Author: ishaanbhimwal@gmail.com
# ANSI Color -- use these variables to easily have different color
#    and format output. Make sure to output the reset sequence after
#    colors (f = foreground, b = background), and use the 'off'
#    feature for anything you turn on.

initializeANSI() {
  esc=""

  redf="${esc}[31m"
  greenf="${esc}[32m"
  yellowf="${esc}[33m" bluef="${esc}[34m"
  cyanf="${esc}[36m"
  purplef="${esc}[35m"

  redfbright="${esc}[91m"
  greenfbright="${esc}[92m"
  yellowfbright="${esc}[93m" bluefbright="${esc}[94m"
  cyanfbright="${esc}[96m"
  purplefbright="${esc}[95m"

  boldon="${esc}[1m"
  reset="${esc}[0m"
}

# note in this first use that switching colors doesn't require a reset
# first - the new color overrides the old one.

initializeANSI

cat << EOF

${reset}${redf} ███████ ███   ${greenf}  ███████ ███   ${yellowf}  ███████ ███   ${bluef}  ███████ ███   ${purplef}  ███████ ███   ${cyanf}  ███████ ███
${reset}${redf} ███ ${boldon}${redfbright}▄▄▄${reset}${redf} ███   ${greenf}  ███ ${boldon}${greenfbright}▄▄▄${reset}${greenf} ███   ${yellowf}  ███ ${boldon}${yellowfbright}▄▄▄${reset}${yellowf} ███   ${bluef}  ███ ${boldon}${bluefbright}▄▄▄${reset}${bluef} ███   ${purplef}  ███ ${boldon}${purplefbright}▄▄▄${reset}${purplef} ███   ${cyanf}  ███ ${boldon}${cyanfbright}▄▄▄${reset}${cyanf} ███
${reset}${redf} ███ ${boldon}${redfbright}███${reset}${redf} ███   ${greenf}  ███ ${boldon}${greenfbright}███${reset}${greenf} ███   ${yellowf}  ███ ${boldon}${yellowfbright}███${reset}${yellowf} ███   ${bluef}  ███ ${boldon}${bluefbright}███${reset}${bluef} ███   ${purplef}  ███ ${boldon}${purplefbright}███${reset}${purplef} ███   ${cyanf}  ███ ${boldon}${cyanfbright}███${reset}${cyanf} ███
${reset}${redf} ███ ${boldon}${redfbright}███${reset}${redf} ███   ${greenf}  ███ ${boldon}${greenfbright}███${reset}${greenf} ███   ${yellowf}  ███ ${boldon}${yellowfbright}███${reset}${yellowf} ███   ${bluef}  ███ ${boldon}${bluefbright}███${reset}${bluef} ███   ${purplef}  ███ ${boldon}${purplefbright}███${reset}${purplef} ███   ${cyanf}  ███ ${boldon}${cyanfbright}███${reset}${cyanf} ███
${reset}${redf} ▀▀▀ ${boldon}${redfbright}▀▀▀${reset}${redf} ▀▀▀   ${greenf}  ▀▀▀ ${boldon}${greenfbright}▀▀▀${reset}${greenf} ▀▀▀   ${yellowf}  ▀▀▀ ${boldon}${yellowfbright}▀▀▀${reset}${yellowf} ▀▀▀   ${bluef}  ▀▀▀ ${boldon}${bluefbright}▀▀▀${reset}${bluef} ▀▀▀   ${purplef}  ▀▀▀ ${boldon}${purplefbright}▀▀▀${reset}${purplef} ▀▀▀   ${cyanf}  ▀▀▀ ${boldon}${cyanfbright}▀▀▀${reset}${cyanf} ▀▀▀
${reset}
EOF
