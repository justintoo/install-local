#!/usr/bin/env bats

load test_helper

#------------------------------------------------------------------------------
@test "without args fails with usage" {
#------------------------------------------------------------------------------
  run install-local install
  assert_failure

  assert_output <<SH
[INFO] tool name was not specified
Usage: install-local install [--usage] TOOL VERSION

Auto-magically installs TOOL and its dependencies.
SH
}

#------------------------------------------------------------------------------
@test "help terminates successfully with usage" {
#------------------------------------------------------------------------------
  run install-local help install
  assert_success

  assert_output <<SH
Usage: install-local install [--usage] TOOL VERSION

Auto-magically installs TOOL and its dependencies.
SH
}

#------------------------------------------------------------------------------
@test "--help fails with usage" {
#------------------------------------------------------------------------------
  run install-local install --help
  assert_failure

  assert_output <<SH
[INFO] --help version was not specified
Usage: install-local install [--usage] TOOL VERSION

Auto-magically installs TOOL and its dependencies.
SH
}

#------------------------------------------------------------------------------
@test "no tool name fails with usage" {
#------------------------------------------------------------------------------
  run install-local install
  assert_failure

  assert_output <<SH
[INFO] tool name was not specified
Usage: install-local install [--usage] TOOL VERSION

Auto-magically installs TOOL and its dependencies.
SH
}

#------------------------------------------------------------------------------
@test "no tool version fails with usage" {
#------------------------------------------------------------------------------
  run install-local install tool
  assert_failure

  assert_output <<SH
[INFO] tool version was not specified
Usage: install-local install [--usage] TOOL VERSION

Auto-magically installs TOOL and its dependencies.
SH
}

#------------------------------------------------------------------------------
@test "tool version not available fails with INFO message" {
#------------------------------------------------------------------------------
  run install-local install tool version
  assert_failure

  assert_output <<SH
[INFO] tool version is not available
SH
}

#------------------------------------------------------------------------------
@test "forgot to specify 'install' command fails with 'no such command'" {
#------------------------------------------------------------------------------
  run install-local tool 1.0
  [ "$status" -eq 1 ]
  [ $(expr "$output" : ".*install-local: no such command") -ne 0 ]
}

#------------------------------------------------------------------------------
@test "missing install_<tool>() fails with 'command not found'" {
#------------------------------------------------------------------------------
  mkdir -p "${INSTALL_LOCAL_TOOLS}/mytool/1.0"
  cd "${INSTALL_LOCAL_TOOLS}/mytool/1.0"
  cat > "install.sh" <<SH
echo "Successfully installed mytool 1.0!"
SH

  run install-local install mytool 1.0
  echo "$output"
  [ "$status" -ne 0 ]
  [ $(expr "$output" : ".*install_mytool: command not found") -ne 0 ]
}

#------------------------------------------------------------------------------
@test "missing setup.sh file fails with '[FATAL] <tool> is not installed'" {
#------------------------------------------------------------------------------
  mkdir -p "${INSTALL_LOCAL_TOOLS}/mytool/1.0"
  cd "${INSTALL_LOCAL_TOOLS}/mytool/1.0"
  cat > "install.sh" <<SH
function install_mytool() {
  echo "Successfully installed mytool 1.0!"
}
SH

  run install-local install mytool 1.0
  assert_failure
  assert_line "Successfully installed mytool 1.0!"
echo "$output"
  [ $(expr "$output" : ".*FATAL.* mytool 1.0 is not installed. Aborting...") -ne 0 ]
}

#------------------------------------------------------------------------------
@test "tool installs successfully" {
#------------------------------------------------------------------------------
  mkdir -p "${INSTALL_LOCAL_TOOLS}/mytool/1.0"
  cd "${INSTALL_LOCAL_TOOLS}/mytool/1.0"

  cat > "install.sh" <<SH
function install_mytool() {
  version="\$1"
  installdir="\$2"
  setup_file="\${installdir}/setup.sh"

  mkdir -p "\${installdir}"

  cat > "\${setup_file}" <<-EOF
echo "Sourced mytool"
EOF

  echo "Successfully installed mytool 1.0!"
}
SH

  run install-local install mytool 1.0
echo $output
  assert_success
  assert_line "Successfully installed mytool 1.0!"
}

