#!/bin/bash

set -x

git config --global core.sshCommand "ssh -i $SOURCE_SECRET_PATH/ssh-privatekey -o StrictHostKeyChecking=no"

BUILD_DIR=$(mktemp -d)
git clone $SOURCE_REPOSITORY $BUILD_DIR && cd $BUILD_DIR
if [ $? != 0 ]; then
    exit 1
fi

export COMMIT=$(echo $BUILD | jq -r '.spec.revision.git.commit | select (. != null)')
if [ -n "$COMMIT" ]; then
	CHECKOUT=$COMMIT
else
	CHECKOUT=$SOURCE_REF
fi

if [ -n "$CHECKOUT" ]; then
    git checkout $CHECKOUT
fi

cp $PUSH_DOCKERCFG_PATH/.dockercfg $HOME/.dockercfg

bash -c "$BUILD_COMMAND"
