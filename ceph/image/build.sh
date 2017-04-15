#!/bin/bash

set -ex

# create the image
SRC="/tmp/ceph-daemon"
mkdir $SRC || true
cd $SRC

# pull base image from ceph (we will layer on top of this)
wget https://raw.githubusercontent.com/systemslab/docker-cephdev/master/aliases.sh
. aliases.sh
rm aliases.sh
docker pull ceph/daemon:tag-build-master-jewel-ubuntu-14.04
docker tag ceph/daemon:tag-build-master-jewel-ubuntu-14.04 ceph/daemon:jewel
docker pull cephbuilder/ceph:latest

#-e SHA1_OR_REF="ec12610bb1358fb2eab74cb7b0483c2613bae38f" \
#-e SHA1_OR_REF="1fdfa94459026b70e8925c0a530005456c526260" \
#-e SHA1_OR_REF="f4d39ca86e29555a45a4cff3f03862081bcc1f84" \
#-e SHA1_OR_REF="11d3bc22ceb151c23c54edaadab2d9d0ec9659fe" \
dmake \
  -e SHA1_OR_REF="remotes/origin/wip_dmclock_clients" \
  -e GIT_URL="https://github.com/leosinclairJr/ceph.git" \
  -e BUILD_THREADS=`grep processor /proc/cpuinfo | wc -l` \
  -e CONFIGURE_FLAGS="-DWITH_TESTS=OFF" \
  -e RECONFIGURE="true" \
  cephbuilder/ceph:latest build-cmake
cd -

#docker tag ec12610bb1358fb2eab74cb7b0483c2613bae38f-base ceph/daemon:ec12610
#docker tag ceph-1fdfa94459026b70e8925c0a530005456c526260 ceph/daemon:1fdfa94
#docker tag ceph-f4d39ca86e29555a45a4cff3f03862081bcc1f84 ceph/daemon:f4d39ca
#docker tag ceph-11d3bc22ceb151c23c54edaadab2d9d0ec9659fe ceph/daemon:11d3bc2
docker tag ceph-remotes/origin/wip_dmclock_clients ceph/daemon:c8198b3
docker build -t tmp .
docker tag tmp piha.soe.ucsc.edu:5000/ceph/daemon:c8198b3
