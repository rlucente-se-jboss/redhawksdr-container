#!/usr/bin/env bash

. $(dirname $0)/demo.conf

WORKDIR=$(pushd $(dirname $0) &> /dev/null && pwd && popd &> /dev/null)

rm -fr $WORKDIR/tmp
mkdir -p $WORKDIR/tmp
cd $WORKDIR/tmp

git clone https://github.com/RedhawkSDR/core-framework.git \
    || exit_on_error "Unable to clone redhawksdr repo"

cd $WORKDIR/tmp/core-framework
git checkout $REDHAWK_VERS \
    || exit_on_error "Unable to checkout redhawksdr $REDHAWK_VERS"

patch -p0 < $WORKDIR/redhawkBuild.Dockerfile.patch \
    || exit_on_error "Unable to patch dockerfile"

cd $WORKDIR/tmp
BASEURL=https://github.com/RedHawkSDR/redhawk/releases/download/$REDHAWK_VERS
curl -LO $BASEURL/redhawk-yum-$REDHAWK_VERS-$REDHAWK_DIST-$REDHAWK_ARCH.tar.gz \
    || exit_on_error "Unable to download redhawk yum repo"

cd $WORKDIR
echo "Provide sudo password if prompted..."
sudo podman build \
    --build-arg docker_repo="registry.access.redhat.com/$RHEL_REPO:$RHEL_TAG" \
    --tag $REDHAWK_NAME:$REDHAWK_VERS \
    -f $WORKDIR/tmp/core-framework/container/components/Dockerfiles/redhawkBuild.Dockerfile \
    . || exit_on_error "Unable to build the REDHAWK OCI container image"

echo "Exporting OCI image archive ..."
echo "Provide sudo password if prompted..."
sudo skopeo copy \
    containers-storage:localhost/$REDHAWK_NAME:$REDHAWK_VERS \
    docker-archive:$REDHAWK_NAME-$REDHAWK_VERS.tar \
    || exit_on_error "Unable to export the REDHAWK OCI container image"

echo "Compressing OCI image archive ..."
gzip $REDHAWK_NAME-$REDHAWK_VERS.tar

