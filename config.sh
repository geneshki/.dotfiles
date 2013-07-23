#!/bin/bash
set -e;
currentDir=$(pwd);
destination=$( cat config.properties | sed -e '\_#.*_ d' -e 's/[ ^I]*$//' -e '/^$/ d' | tail -n +1 |head -n 1);
cd $destination;
cat $currentDir/config.properties | sed -e '\_#.*_ d' -e 's/[ ^I]*$//' -e '/^$/ d' | tail -n +2 | while read line; do 
  echo cloning from $line;
  git clone $line;
done
echo Config SUCCESSFUL!
