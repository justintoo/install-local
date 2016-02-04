install-local
=============

Super-duper easy user local installations of Linux tools

```bash
$ source setup.sh
```

## Installing tools

```bash
$ install-local install autoconf 2.69
```

## Using tools

```bash
$ install-local use autoconf 2.69
```

## Running tests

Our unit tests rely on sstephenson/bats:

```bash
$ cd install-local/
$ git submodule update --init

$ cd tests/
$ ./test.sh
```

