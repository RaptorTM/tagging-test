##!/bin/bash
#FILE='docs/md/RELEASENOTES.md'
FILE='RELEASENOTES.md'
GIT_LOG_FORMAT="--pretty=%B"
TAG_LATEST=$(git tag -l --sort=-v:refname | head -n 1)
TAG_PREV=$(git tag -l --sort=-v:refname | head -n 2 | tail -n 1)

#TAG_LATEST="HEAD"
#TAG_PREV=$(git tag -l --sort=-v:refname | head -n 2 | tail -n 1)

TITLE=$(git log $GIT_LOG_FORMAT $TAG_LATEST...$TAG_PREV | sed 's/^.*(heleprs): //' | sed 's/ +semver.*$//' | head -n 1)
DATE=$(date +%d-%m-%Y)
CHANGELOG=$(git log $GIT_LOG_FORMAT $TAG_LATEST...$TAG_PREV | sed 's/^.*(heleprs): //' | sed 's/ +semver.*$//' | tail -n +3)

RELEASE_NOTE="
## $TITLE
### Date: $DATE
### $CHANGELOG
***"
 
echo "$RELEASE_NOTE" | cat - $FILE > temp && mv temp $FILE

git tag -d $TAG_LATEST

git add $FILE

git commit -m "Added release notes for v$TAG_LATEST" && git tag $TAG_LATEST

git push origin wsl_test_sh --tags