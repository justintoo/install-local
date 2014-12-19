#!/usr/bin/env bash

: ${INSTALL_LOCAL="${HOME}/.install-local"}

source "${INSTALL_LOCAL}/lib/colors.bash" || exit 1

source "${INSTALL_LOCAL}/lib/preexec.bash" || exit 1
function preexec (){
  printf "${echo_green}[install-local]${normal} "
}
preexec_interactive_mode=yes
preexec_install || exit 1


