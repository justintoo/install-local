The test suite for `install-local` currently utilizes the [Bash Automated Testing System (sstephenson/bats)](https://github.com/sstephenson/bats).

### Usage Example

```bash
$ ./test.sh 
[INFO] running test cli.bats\[\]
 ✓ without args shows --help summary of common commands
 ✓ invalid command
 ✓ shows help for a specific command
 ✓ replaces missing extended help with summary text
 ✓ extracts only usage
 ✓ multiline usage section
 ✓ multiline extended help section

7 tests, 0 failures
```

