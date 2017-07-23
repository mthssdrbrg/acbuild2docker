# acbuild2docker

[![Build Status](https://travis-ci.org/mthssdrbrg/acbuild2docker.svg?branch=master)](https://travis-ci.org/mthssdrbrg/acbuild2docker)
[![GitHub Release](https://img.shields.io/github/release/mthssdrbrg/acbuild2docker.svg)]()

Convert a script using `acbuild` to Dockerfile instructions.

## Requirements

* `bash`
* `coreutils`

## Installation

```shell
curl -sLO https://github.com/mthssdrbrg/acbuild2docker/raw/$VERSION/acbuild2docker
```

## Usage

```shell
$ acbuild2docker <SCRIPT_PATH>
```

The above command will run through the script at `<SCRIPT_PATH>` and convert the relevant `acbuild` calls to Dockerfile instructions, with the result being written to standard out.

## Copyright

This is free and unencumbered software released into the public domain.

See `LICENSE` or [unlicense.org](http://unlicense.org) for more information.
