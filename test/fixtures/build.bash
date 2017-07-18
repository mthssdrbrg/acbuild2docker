#!/usr/bin/env bash

declare -r name="bats-test"
declare -r version="latest"
declare -r user="bats"
declare -r group="bats"
declare -r home="/home/$user"

acbuild --debug begin "docker://alpine:3.6"
acbuild --debug set-name "mthssdrbrg/$name"
acbuild --debug label add version "latest"

acbuild --debug run -- apk --no-cache add bash
acbuild --debug run -- adduser -S -D -g "$user" "$user"

acbuild --debug set-user "$user"
acbuild --debug set-group "$group"
acbuild --debug set-working-directory "$home"
acbuild --debug set-exec -- /bin/bash

acbuild --debug environment add LOGNAME "$name"
acbuild --debug environment add HOME "$home"
acbuild --debug environment add USER "$user"

acbuild --debug port add tcp 8080

acbuild --debug mount add config "$home/.bashrc"
acbuild --debug write --overwrite "$version.aci"
acbuild --debug end
