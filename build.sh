#!/bin/bash

set -x

git config --global core.sshCommand "ssh -i $SOURCE_SECRET_PATH/ssh-privatekey -o StrictHostKeyChecking=no"

BUILD_DIR=$(mktemp -d)
git clone $SOURCE_REPOSITORY $BUILD_DIR && cd $BUILD_DIR
if [ $? != 0 ]; then
    exit 1
fi

if [ -n "$SOURCE_REF" ]; then
    git checkout $SOURCE_REF
fi

cp $PUSH_DOCKERCFG_PATH/.dockercfg $HOME/.dockercfg

bash -c "$BUILD_COMMAND"
