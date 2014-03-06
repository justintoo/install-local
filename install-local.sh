#!/bin/bash

INSTALL_LOCAL="$(dirname "$0")"

#-------------------------------------------------------------------------------
# Utilities
#-------------------------------------------------------------------------------
info() { printf "[INFO] $*\n" ; return 0 ; }
warn() { printf "[WARN] $*\n" ; return 0 ; }
fail() { printf "\n[FATAL] $*\n" 1>&2 ; exit 1 ; }

function _help()
{
cat <<-EOF
--------------------------------------------------------------------------------
Help Information for install-local
--------------------------------------------------------------------------------

EOF

  reference install-local

cat <<-EOF

--------------------------------------------------------------------------------
EOF
  exit 1
}

#-------------------------------------------------------------------------------
# Infrastructure
#-------------------------------------------------------------------------------
# Support for function (--help) metadata
source "${INSTALL_LOCAL}/lib/composure/composure.sh" 2>/dev/null || fail "Could not source composure.sh"
# Support for colorful output
#source "${INSTALL_LOCAL}/lib/colors.bash" || fail "Could not source colors.bash"

# support 'plumbing' metadata
cite _about _param _example _group _author _version

install-local ()
{
    about 'install-local help and maintenance'
    param '1: verb [one of: help ]'
    example '$ install-local --help'
    example '$ install-local <software>'

    local func="help"
    declare -r verb=${1:-"--help"}
    shift

    case $verb in
        --help)
            func=_help
            ;;
        *)
            warn "Unrecognized command-line option: '${verb}'"
            func=_help
            ;;
    esac

    $func $* || return 1
}

install-local $* || exit 1
