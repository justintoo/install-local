#!/usr/bin/env bash -e

#------------------------------------------------------------------------------
#
#------------------------------------------------------------------------------
: ${INSTALL_LOCAL:="$(dirname "$0")/.."}
: ${INSTALL_LOCAL_TESTS:="$(dirname "$0")"}
: ${INSTALL_LOCAL_BATS:="${INSTALL_LOCAL_TESTS}/bats"}
: ${INSTALL_LOCAL_DEBUG:="false"}

#------------------------------------------------------------------------------
#
#------------------------------------------------------------------------------
source "${INSTALL_LOCAL}/lib/colors.bash" || exit 1

export PATH="${INSTALL_LOCAL_BATS}/bin:${PATH}"

#------------------------------------------------------------------------------
# TODO source from global utils
#------------------------------------------------------------------------------
function info__() {
  echo -e "${echo_green}[INFO] $@${normal}"
}

function debug__() {
  if test "x${INSTALL_LOCAL_DEBUG}" = "xtrue" || \
     test "x${INSTALL_LOCAL_DEBUG}" = "xyes";
  then
      echo -e "[DEBUG] $@"
  fi
}

#------------------------------------------------------------------------------
# Test API
#------------------------------------------------------------------------------
function list_tests__() {
  for test_path in $(find "${INSTALL_LOCAL_TESTS}" -maxdepth 2 -iname "*\.bats" -type f ! -path "${INSTALL_LOCAL_TESTS}"); do
    test_name="$(basename "${test_path}")"
    debug__ "test_path=\"${test_path}\""
    debug__ "tool_name=\"${test_name}\""
    echo "${test_name}"
  done
}

#------------------------------------------------------------------------------
# Main
#------------------------------------------------------------------------------
function start_main__() {
  for test_name in $(list_tests__); do
    info__ "running test ${test_name}"
    bats "${test_name}"
  done
}

start_main__

