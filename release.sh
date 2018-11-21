#!/usr/bin/env bash

if ! [ -x "$(command -v dialog)" ]; then
  echo 'Error: You must install "dialog" to use this script' >&2
  exit 1
fi

echo "" > .release-message
dialog --clear \
  --backtitle "Press <TAB> to go to OK or Cancel" \
  --title "Describe the changes in this release" \
  --editbox .release-message 16 80 2> .release-message

if [ $? -eq 1 ]; then
  clear
  echo 'User cancelled. Aborting.' >&2
  rm .release-message
  exit 1
fi

clear

git checkout master
git fetch --tags
currentTag=`git describe --tags --abbrev=0` 

if [ -z "${currentTag// }" ]; then
  echo "Initial version, defaulting to 0.1.0"
  tagName="v0.1.0"
else
  currentVersion=$(echo ${currentTag:1} | tr "." " ")
  versionBits=($currentVersion) # turn into array
  majorV=${versionBits[0]}
  minorV=${versionBits[1]}
  patchV=${versionBits[2]}
  updateType=$(dialog \
    --output-fd 1 --clear --title "Select Version" \
    --menu "How does the new version differ from the previous one?" 10 64 4 \
        patch "It fixes a bug and remains backwards-compatible" \
        minor "It adds features but is backwards-compatible" \
        major "It contains API incompatible changes")
  clear

  if [ "$updateType" = "major" ]; then
    majorV=$((majorV+1))
    minorV=0
    patchV=0
  elif [ "$updateType" = "minor" ]; then
    minorV=$((minorV+1))
    patchV=0
  elif [ "$updateType" = "patch" ]; then
    patchV=$((patchV+1))
  else
    echo 'User cancelled. Aborting.' >&2
    rm .release-message
    exit 1
  fi

  tagName="v${majorV}.${minorV}.${patchV}"
fi

# Weird echoing otherwise git does not 
# like spaces in the tag message
echo "Tagging"
git tag -a $tagName --file=.release-message

echo "Pushing tag"
git push origin $tagName
