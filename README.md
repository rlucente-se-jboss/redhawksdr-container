# Build RedHawkSDR container on RHEL 7
This repository is a thin wrapper to the [REDHAWK Software Defined Radio](https://redhawksdr.org/)
(SDR) project to build an OCI container image of REDHAWK on Red Hat
Enterprise Linux (RHEL) 7.

## Modify the configuration
Review the contents of the `demo.conf` file. At a minimum, you'll
need to update the [Red Hat Customer Portal](https://access.redhat.com)
credentials to match your account so you can pull the subscription
content. You can sign up for a free Red Hat Enterprise Linux account
for development purposes at the [Red Hat Developer](https://developers.redhat.com)
site.

You can also modify other parameters including the REDHAWK version,
distribution, and architecture as well as the RHEL base container
image repository and tag, but be aware that this may impact the
Dockerfile patch script `redhawkBuild.Dockerfile.patch` and require
additional work for the scripts to execute.

## Build the container image
This will produce a very large container image (~4 GB) and take
around an hour to complete.

To build the container image, first install a minimal RHEL 7 system.
After rebooting the newly installed system, copy the contents of
this repository to the system. Use the `01-setup-rhel.sh` script
to register the subscription and update the base packages:

    cd /path/to/redhawksdr-container
    sudo ./01-setup-rhel.sh

where `/path/to/redhawksdr-container` matches where you placed the
contents of this repository on the RHEL 7 system. Reboot the system
since the kernel packages may have been updated.

    sudo reboot

After logging on again, run the remaining scripts to build the
REDHAWK SDR base OCI container image.

    cd /path/to/redhawksdr-container
    sudo ./02-setup-repos.sh
    ./03-build-redhawk-container.sh

The last script should not be run as `sudo` although it will prompt
for a `sudo` password before running the `podman build` command.
The container image build can take over an hour depending on your
hardware. The resulting image will be exported as a compressed OCI
image archive in the same folder as the scripts.

