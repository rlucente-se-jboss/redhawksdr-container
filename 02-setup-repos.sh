#!/usr/bin/env bash

. $(dirname $0)/demo.conf

[[ $EUID -ne 0 ]] && exit_on_error "Must run as root"

subscription-manager repos \
    --enable rhel-server-rhscl-7-rpms \
    --enable rhel-7-server-optional-rpms \
    --enable rhel-7-server-extras-rpms \
    --enable rhel-ha-for-rhel-7-server-rpms

yum install -y git patch podman skopeo

