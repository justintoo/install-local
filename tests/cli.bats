#!/usr/bin/env bats

load test_helper

@test "without args shows --help summary of common commands" {
  run install-local
  assert_success
  assert_line "Usage: install-local <command> [<args>]"
  assert_line "Some useful install-local commands are:"
}

@test "invalid command" {
  run install-local-help hello
  assert_failure "install-local: no such command \`hello'"
}

@test "shows help for a specific command" {
  mkdir -p "${INSTALL_LOCAL_TEST_DIR}/bin"
  cat > "${INSTALL_LOCAL_TEST_DIR}/bin/install-local-hello" <<SH
#!shebang
# Usage: install-local hello <world>
# Summary: Says "hello" to you, from install-local
# This command is useful for saying hello.
echo hello
SH

  run install-local-help hello
  assert_success
  assert_output <<SH
Usage: install-local hello <world>

This command is useful for saying hello.
SH
}

@test "replaces missing extended help with summary text" {
  mkdir -p "${INSTALL_LOCAL_TEST_DIR}/bin"
  cat > "${INSTALL_LOCAL_TEST_DIR}/bin/install-local-hello" <<SH
#!shebang
# Usage: install-local hello <world>
# Summary: Says "hello" to you, from install-local
echo hello
SH

  run install-local-help hello
  assert_success
  assert_output <<SH
Usage: install-local hello <world>

Says "hello" to you, from install-local
SH
}

@test "extracts only usage" {
  mkdir -p "${INSTALL_LOCAL_TEST_DIR}/bin"
  cat > "${INSTALL_LOCAL_TEST_DIR}/bin/install-local-hello" <<SH
#!shebang
# Usage: install-local hello <world>
# Summary: Says "hello" to you, from install-local
# This extended help won't be shown.
echo hello
SH

  run install-local-help --usage hello
  assert_success "Usage: install-local hello <world>"
}

@test "multiline usage section" {
  mkdir -p "${INSTALL_LOCAL_TEST_DIR}/bin"
  cat > "${INSTALL_LOCAL_TEST_DIR}/bin/install-local-hello" <<SH
#!shebang
# Usage: install-local hello <world>
#        install-local hi [everybody]
#        install-local hola --translate
# Summary: Says "hello" to you, from install-local
# Help text.
echo hello
SH

  run install-local-help hello
  assert_success
  assert_output <<SH
Usage: install-local hello <world>
       install-local hi [everybody]
       install-local hola --translate

Help text.
SH
}

@test "multiline extended help section" {
  mkdir -p "${INSTALL_LOCAL_TEST_DIR}/bin"
  cat > "${INSTALL_LOCAL_TEST_DIR}/bin/install-local-hello" <<SH
#!shebang
# Usage: install-local hello <world>
# Summary: Says "hello" to you, from install-local
# This is extended help text.
# It can contain multiple lines.
#
# And paragraphs.

echo hello
SH

  run install-local-help hello
  assert_success
  assert_output <<SH
Usage: install-local hello <world>

This is extended help text.
It can contain multiple lines.

And paragraphs.
SH
}
