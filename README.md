install-local
=============

Super-duper easy user local installations of Linux tools

```bash
$ source setup.sh
```

## Running tests

Our unit tests rely on sstephenson/bats:

```bash
$ cd install-local/
$ git submodule update --init

$ cd tests/
$ ./test.sh
```

