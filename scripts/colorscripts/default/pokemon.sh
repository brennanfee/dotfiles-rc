#!/bin/sh
# shellcheck disable=SC2034

initializeANSI() {
  esc=""

  Bf="${esc}[30m"
  rf="${esc}[31m"
  gf="${esc}[32m"
  yf="${esc}[33m" bf="${esc}[34m"
  pf="${esc}[35m"
  cf="${esc}[36m"
  wf="${esc}[37m"

  Bb="${esc}[40m"
  rb="${esc}[41m"
  gb="${esc}[42m"
  yb="${esc}[43m" bb="${esc}[44m"
  pb="${esc}[45m"
  cb="${esc}[46m"
  wb="${esc}[47m"

  ON="${esc}[1m"
  OFF="${esc}[22m"
  italicson="${esc}[3m"
  italicsoff="${esc}[23m"
  ulon="${esc}[4m"
  uloff="${esc}[24m"
  invon="${esc}[7m"
  invoff="${esc}[27m"

  reset="${esc}[0m"
}

initializeANSI

cat << EOF
                        ${Bf}██████                    ${Bf}████████                  ██              ${Bf}████████                  ████████
                      ${Bf}██${gf}${ON}██████${OFF}${Bf}██                ${Bf}██${rf}${ON}██████${OFF}██${Bf}██              ██${rf}██${Bf}██          ${Bf}██${bf}${ON}██████${OFF}██${Bf}████            ██${bf}${ON}████████${OFF}${Bf}██
                  ${Bf}██████${gf}${ON}██████${OFF}${Bf}██              ${Bf}██${rf}${ON}██████████${OFF}██${Bf}██            ██${rf}████${Bf}██      ${Bf}██${bf}${ON}████████████${OFF}██${Bf}████      ████${bf}${ON}██████${OFF}████${Bf}██
              ${Bf}████${gf}${ON}████${OFF}██${ON}████${OFF}██${ON}██${OFF}${Bf}████          ${Bf}██${rf}${ON}████████████${OFF}${Bf}██            ██${rf}████${Bf}██      ${Bf}██${bf}${ON}██████████████${OFF}${Bf}██${pf}██${Bf}████  ██${bf}${ON}████${OFF}██${Bf}██${bf}████${Bf}██
      ${Bf}██    ██${gf}${ON}██████${OFF}████${ON}████${OFF}██${ON}██████${OFF}${Bf}██      ${Bf}██${rf}${ON}██████████████${OFF}██${Bf}██        ██${rf}████${yf}██${rf}██${Bf}██  ${Bf}██${bf}${ON}████████████████${OFF}██${pf}██${ON}██${OFF}██${Bf}██${bf}██${ON}██${OFF}██${Bf}██${bf}██████${Bf}██
    ${Bf}██${cf}${ON}██${OFF}${Bf}██████${gf}${ON}████${OFF}██${ON}██${OFF}██${ON}██████${OFF}██${ON}██████${OFF}${Bf}██  ${Bf}██${rf}${ON}████████${wf}██${OFF}${Bf}██${rf}${ON}████${OFF}██${Bf}██        ██${rf}██${yf}██${ON}██${OFF}${rf}██${Bf}██  ${Bf}██${bf}${ON}████████${wf}${ON}██${OFF}${Bf}██${bf}${ON}████${OFF}██${wf}${ON}██${OFF}${pf}${ON}████${OFF}██${Bf}██${bf}████${Bf}██${bf}████${Bf}██
    ${Bf}██${cf}${ON}██████${OFF}${Bf}████${gf}██${ON}██${OFF}██${ON}██████████${OFF}██${ON}████${OFF}${Bf}██  ${Bf}██${rf}${ON}████████${OFF}${Bf}████${rf}${ON}██${OFF}██████${Bf}██      ██${rf}██${yf}${ON}████${OFF}${rf}██${Bf}██  ${Bf}██${bf}██${ON}██████${OFF}${Bf}████${bf}${ON}██${OFF}████${wf}${ON}██${pf}██████${OFF}${Bf}██${bf}██${Bf}████████
    ${Bf}██${cf}${ON}████████${OFF}██${Bf}██${gf}${ON}██${OFF}██${ON}██████████${OFF}██${ON}████${OFF}${Bf}██  ${Bf}██${rf}${ON}████████${OFF}${Bf}████${rf}${ON}██${OFF}██████${Bf}██        ██${yf}${ON}██${OFF}${Bf}████      ${Bf}██${bf}████${ON}██${OFF}${Bf}████${bf}██████${Bf}██${wf}${ON}████${pf}██${OFF}██${Bf}████
  ${Bf}██${cf}${ON}████${OFF}██${ON}██${OFF}████${ON}██${OFF}${Bf}██████${gf}${ON}████████${OFF}██${ON}██${OFF}${Bf}██      ${Bf}██${rf}██${ON}████████${OFF}██████████${Bf}██      ██${rf}${ON}██${OFF}${Bf}██          ${Bf}████${bf}████████${Bf}████${bf}${ON}████${wf}██${OFF}${pf}████${Bf}██
${Bf}████${cf}██${ON}████████████████${OFF}${Bf}██${gf}██████${Bf}████████        ${Bf}████${rf}██████████████████${Bf}██  ██${rf}${ON}████${OFF}${Bf}██          ${Bf}██${bf}${ON}██${OFF}${Bf}████████${bf}${ON}██████${OFF}██${wf}${ON}██${OFF}${pf}████${Bf}██
${Bf}██${cf}████${ON}██████${OFF}██${ON}██████${OFF}${Bf}██${cf}██${Bf}██████${cf}██████${Bf}██            ${Bf}██████${rf}████${Bf}██${rf}██████${Bf}████${rf}██${ON}██${OFF}${Bf}██              ${Bf}████${yf}${ON}████${OFF}${Bf}██${bf}${ON}████${OFF}██${Bf}██${wf}${ON}██${OFF}${pf}████${Bf}██
${Bf}██${cf}${ON}████████${OFF}██${ON}██${OFF}${Bf}████${cf}${ON}██${OFF}██████████${Bf}██${cf}██${wf}${ON}██${OFF}${Bf}██              ${Bf}██${yf}${ON}████${OFF}${Bf}██${rf}${ON}████${OFF}${rf}██████${Bf}██${rf}██${ON}██${OFF}${Bf}██                  ${Bf}██${yf}████${Bf}████████${wf}${ON}██${OFF}${pf}████${Bf}██
${Bf}██${cf}██${ON}████████${OFF}${Bf}██${rf}${ON}██${wf}████${OFF}${cf}████${Bf}██${cf}████${Bf}██████                ${Bf}██${yf}${ON}██████${OFF}${Bf}████${rf}██████${Bf}██${rf}██${Bf}██                  ${Bf}██${bf}██${Bf}██${pf}██${yf}██████${pf}██${Bf}██${wf}${ON}██${OFF}${Bf}██
  ${Bf}██${cf}██${ON}██████${OFF}${Bf}██${rf}${ON}██${wf}██${cf}██${OFF}██${Bf}██${cf}████${Bf}██                    ${Bf}██${wf}${ON}██${OFF}${Bf}██${yf}${ON}██████${OFF}${rf}████████${Bf}████                      ${Bf}████████${pf}████${bf}██${Bf}██${wf}${ON}██${OFF}${Bf}██
    ${Bf}████${cf}████████████${Bf}██${cf}██████${Bf}██                      ${Bf}██████${yf}████${rf}██████${Bf}████                              ${Bf}██████${bf}██${Bf}████
        ${Bf}██████████████${wf}${ON}██${OFF}${cf}██${wf}${ON}██${OFF}${Bf}██                            ${Bf}██████${rf}██${Bf}████                                  ${Bf}██${bf}██████${Bf}██
                      ${Bf}██████                                ${Bf}██${wf}${ON}██${OFF}${rf}██${wf}${ON}██${OFF}${Bf}██                                    ${Bf}██████
                                                              ${Bf}██████
${reset}

EOF
