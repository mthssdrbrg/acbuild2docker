#!/usr/bin/env bats

teardown() {
  rm -f Dockerfile
}

@test "no arguments prints usage instructions" {
  run ./acbuild2docker
  [ $status -eq 1 ]
  [ $(expr "$output" : ".*Usage:") -ne 0 ]
}

@test "prints usage when given -h / --help" {
  run ./acbuild2docker -h
  [ $status -eq 0 ]
  [ $(expr "$output" : ".*Usage:") -ne 0 ]
  run ./acbuild2docker --help
  [ $status -eq 0 ]
  [ $(expr "$output" : ".*Usage:") -ne 0 ]
}

@test "prints version when given -v / --version" {
  run ./acbuild2docker -v
  [ $status -eq 0 -a "$output" = "0.1.0" ]
  run ./acbuild2docker --version
  [ $status -eq 0 -a "$output" = "0.1.0" ]
}

@test "exits with status code 1 if given nonexistent file" {
  run ./acbuild2docker nonexistent
  [ $status -eq 1 ]
}

@test "writes an error message if given nonexistent file" {
  run ./acbuild2docker nonexistent
  [ "$output" = "'nonexistent' doesn't exist" ]
}

@test "exits with status code 1 if unable to find FROM instruction" {
  run ./acbuild2docker test/fixtures/no-from.bash
  [ $status -eq 1 ]
}

@test "writes an error message if unable to find FROM instruction" {
  run ./acbuild2docker test/fixtures/no-from.bash
  [ "$output" = "missing FROM" ]
}

@test "exits with status code 0" {
  run ./acbuild2docker test/fixtures/build.bash
  [ $status -eq 0 ]
}

@test "outputs Dockerfile instructions to stdout" {
  run ./acbuild2docker test/fixtures/build.bash
  [ $(expr "$output" : ".*FROM") -ne 0 ]
}

@test "adds LABEL instructions" {
  run ./acbuild2docker test/fixtures/build.bash
  [ $(expr "$output" : ".*LABEL version=latest") -ne 0 ]
}

@test "adds EXPOSE instructions" {
  run ./acbuild2docker test/fixtures/build.bash
  [ $(expr "$output" : ".*EXPOSE 8080") -ne 0 ]
}

@test "adds ENV instructions" {
  run ./acbuild2docker test/fixtures/build.bash
  [ $(expr "$output" : ".*ENV LOGNAME bats-test") -ne 0 ]
  [ $(expr "$output" : ".*ENV HOME /home/bats") -ne 0 ]
  [ $(expr "$output" : ".*ENV USER bats") -ne 0 ]
}

@test "adds USER instruction" {
  run ./acbuild2docker test/fixtures/build.bash
  [ $(expr "$output" : ".*USER bats") -ne 0 ]
}

@test "adds WORKDIR instruction" {
  run ./acbuild2docker test/fixtures/build.bash
  [ $(expr "$output" : ".*WORKDIR /home/bats") -ne 0 ]
}

@test "adds VOLUME instructions" {
  run ./acbuild2docker test/fixtures/build.bash
  [ $(expr "$output" : ".*VOLUME /home/bats/.bashrc") -ne 0 ]
}

@test "adds CMD instruction" {
  run ./acbuild2docker test/fixtures/build.bash
  [ $(expr "$output" : ".*CMD /bin/bash") -ne 0 ]
}

@test "generates valid Dockerfile instructions" {
  run ./acbuild2docker test/fixtures/build.bash
  [ $status -eq 0 ]
  echo "$output" > Dockerfile
  run docker build -t mthssdrbrg/bats-test .
  [ $status -eq 0 ]
  run docker run --rm -it mthssdrbrg/bats-test echo -n "hello world"
  [ "$output" = "hello world" ]
  docker rmi mthssdrbrg/bats-test
}
