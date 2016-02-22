#!/bin/bash
#
# Exports:
#
#    $INSTALL_LOCAL_OS_DISTRO
#    $INSTALL_LOCAL_OS_ARCHITECTURE
#    $INSTALL_LOCAL_OS_VERSION

#------------------------------------------------------------------------------
# Determine OS Distribution
#------------------------------------------------------------------------------
UNAME=$(uname | tr "[:upper:]" "[:lower:]")

# If Linux, try to determine specific distribution
if [ "$UNAME" == "linux" ]; then
    # If available, use LSB to identify distribution
    if [ -f /etc/lsb-release -o -d /etc/lsb-release.d ]; then
        INSTALL_LOCAL_OS_DISTRO=$(lsb_release -i | cut -d: -f2 | sed s/'^\t'//)
    # Otherwise, use release info file
    elif [ -f /etc/redhat-release ]; then
        INSTALL_LOCAL_OS_DISTRO="redhat"
    fi
fi

# For everything else (or if above failed), terminate
if [ "$INSTALL_LOCAL_OS_DISTRO" == "" ]; then
  echo "[FATAL] Unrecognized operating system"
  exit 1
fi
unset UNAME

#------------------------------------------------------------------------------
# Determine OS Distribution Version
#------------------------------------------------------------------------------
if test "x${INSTALL_LOCAL_OS_DISTRO}" = "xredhat"; then
  INSTALL_LOCAL_OS_VERSION="$(cat /etc/redhat-release | sed 's/^Red Hat.*release \(.*\..*\) .*/\1/')"
fi

if test -z "$INSTALL_LOCAL_OS_VERSION"; then
  echo "[FATAL] Failed to compute your operating system's version"
  exit 1
fi

#------------------------------------------------------------------------------
# Export Variables
#------------------------------------------------------------------------------
export INSTALL_LOCAL_OS_DISTRO
export INSTALL_LOCAL_OS_ARCHITECTURE="$(uname -m)"
export INSTALL_LOCAL_OS_VERSION

