#!/usr/bin/env bash

. $(dirname $0)/demo.conf

[[ $EUID -ne 0 ]] && exit_on_error "Must run as root"

subscription-manager register \
    --username $USERNAME --password $PASSWORD || exit_on_error "Unable to registrer subscription"
subscription-manager role --set="Red Hat Enterprise Linux Server"
subscription-manager service-level --set="Self-Support"
subscription-manager usage --set="Development/Test"
subscription-manager attach

yum -y update
yum -y clean all

