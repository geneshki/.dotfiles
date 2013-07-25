#!/bin/bash
set -e; #if there are problems with the configuration - exit
currentDir=$(pwd);
destinationIsAbsolute=$( cat config.properties | set -e '\_#.*_ d' -e 's/[ ^I]*$//' -e '/^$/ d' | tail -n +1 | head -n 1);
destination=$( cat config.properties | sed -e '\_#.*_ d' -e 's/[ ^I]*$//' -e '/^$/ d' | tail -n +2 |head -n 1);
if [ "$destinationIsAbsolute" != "true" ]
then
 destination="$HOME$destination"
fi
echo bundle directory path: $destination;
cd $destination;
set +e; # don't exit on error. This way even if plugins are downloaded or there's another error,
        # the rest of the plugins would be cloned.
cat $currentDir/config.properties | sed -e '\_#.*_ d' -e 's/[ ^I]*$//' -e '/^$/ d' | tail -n +3 | while read line; do 
  echo cloning from $line;
  git clone $line;
done

cd ../
ln -s $currentDir/.vimrc
#echo Config SUCCESSFUL!
