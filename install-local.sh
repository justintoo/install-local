#!/usr/bin/env bash

: ${INSTALL_LOCAL="${HOME}/.install-local"}

source "${INSTALL_LOCAL}/lib/colors.bash" || exit 1

echo -e "${echo_red}Hello, install-local!${normal}"

