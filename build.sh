#!/bin/bash

set -x

configure_git_privkey() {
    privatekey=$1

    git config --global core.sshCommand \
        "ssh -i $privatekey -o StrictHostKeyChecking=no"
}

configure_docker_credentials() {
    cp "$PUSH_DOCKERCFG_PATH"/.dockercfg "$HOME"/.dockercfg
}

fast_checkout() {
    repository=$1
    ref=$2

    git init
    git remote add origin "$repository"

    [ -n "$ref" ] && fetch=$ref || fetch=HEAD
    git fetch --depth 1 origin $fetch
    git checkout FETCH_HEAD
}

get_git_ref() {
    commit=$(echo "$BUILD" | jq -r '.spec.revision.git.commit |
                                    select (. != null)')

    if [ -n "$commit" ]; then
        echo "$commit"
    else
        echo "$SOURCE_REF"
    fi
}

cd "$(mktemp -d)" || exit 1

git_ref=$(get_git_ref)
configure_git_privkey "$SOURCE_SECRET_PATH"/ssh-privatekey
fast_checkout "$SOURCE_REPOSITORY" "$git_ref"
configure_docker_credentials

COMMIT=$(git rev-parse HEAD)
OUTPUT_REPOSITORY=$(echo "$OUTPUT_IMAGE" | cut -d: -f1)

export COMMIT
export OUTPUT_REPOSITORY
bash -c "$BUILD_COMMAND"
