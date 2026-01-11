#!/usr/bin/env bash
set -euo pipefail

FOLDER="${1}"
MIRROR_REPO="${2}"
MIRROR_BRANCH="${3}"
RELEASE_TAG="${4}"

mkdir -p ~/.ssh
echo "${CI_MIRROR_SSH_KEY}" > ~/.ssh/ci_signing_key
chmod 600 ~/.ssh/ci_signing_key

ssh-keyscan github.com >> ~/.ssh/known_hosts

eval "$(ssh-agent -s)"

cat > ~/.ssh/askpass.sh <<'EOF'
#!/bin/sh
echo "${SSH_PASSPHRASE}"
EOF
chmod 700 ~/.ssh/askpass.sh

export SSH_ASKPASS_REQUIRE=force
export SSH_ASKPASS="${HOME}/.ssh/askpass.sh"

# Required due to ludicrous OpenSSH security checks
export DISPLAY=dummy
export SSH_PASSPHRASE="${CI_MIRROR_SSH_KEY_PASSPHRASE}"

setsid ssh-add ~/.ssh/ci_signing_key

git config --global gpg.format ssh
git config --global user.signingkey ~/.ssh/ci_signing_key
git config --global tag.gpgsign true
git config --global user.email "ci@shattered-dawn.com"
git config --global user.name "Shattered Dawn CI/CD"

git subtree split --prefix="${FOLDER}" -b temp-mirror
git switch temp-mirror
git commit --amend -S --no-edit

git tag -f -s -a "${RELEASE_TAG}" -m "Release ${RELEASE_TAG} (mirror)"

git push "git@github.com:${MIRROR_REPO}.git" temp-mirror:"${MIRROR_BRANCH}" --force
git push "git@github.com:${MIRROR_REPO}.git" --tags --force
