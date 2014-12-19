#!/usr/bin/env bats

load test_helper

@test "without args terminates successfully" {
  run install-local install
  assert_success
}

