#!/bin/bash
set -ex

git clone -b gh-pages https://github.com/mozilla-parsys/planet.mozillareps.org.git
pushd planet.mozillareps.org
git config user.email "planetupdate@mozillareps.org"
git config user.name "planet-update-bot"
git remote add origin-rw https://${GITHUB_AUTH_TOKEN}@github.com/mozilla-parsys/planet.mozillareps.org.git

docker run \
       -v `pwd`:/data/output \
       -v ~/cache:/data/cache \
       giorgos/planet-mozillareps-org-builder
git add -f --all .
set +e  # Don't fail the script if commit fails due to no changes.
git commit -m "Site update"

# Push only if there are commit changes.
if [[ $? == 0 ]];
then
    git push origin-rw gh-pages 2> /dev/null
fi
