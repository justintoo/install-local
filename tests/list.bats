#!/usr/bin/env bats

load test_helper

@test "without args lists available tools" {

  run install-local list
  assert_success

  for fake_tool in $(find "${INSTALL_LOCAL_TOOLS}" -maxdepth 2 -type d ! -path "${INSTALL_LOCAL_TOOLS}"); do
    assert_line "${fake_tool}"
  done
}

