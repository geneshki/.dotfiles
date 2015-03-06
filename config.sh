#!/bin/bash
set -e; #if there are problems with the configuration - exit
currentDir=$(pwd);
destination=$( cat config.properties | sed -e '\_#.*_ d' -e 's/[ ^I]*$//' -e '/^$/ d' | tail -n +1 | head -n 1);
if [[ ! $destination == $HOME* ]]
then
  destination="$HOME$destination"
fi
echo bundle directory path: $destination;
workingDir=$( cat config.properties | sed -e '\_#.*_ d' -e 's/[ ^I]*$//' -e '/^$/ d' | tail -n +2 | head -n 1);
if [[ ! $workingDir == $HOME* ]]; then
  workingDir="$HOME$workingDir";
fi
#get the type of os - it's important, especially if the os is Windows
osType=$( cat config.properties | sed -e '\_#.*_ d' -e 's/[ ^I]*$//' -e '/^$/ d' | tail -n +3 | head -n 1);
# get the name of the filetype plugin
ftpluginName=$( cat config.properties | sed -e '\_#.*_ d' -e 's/[ ^I]*$//' -e '/^$/ d' | tail -n +4 | head -n 1);
echo $ftpluginName
echo `[[ $ftpluginName =~ ^ftpluginName ]]`
if [[ $ftpluginName =~ ^ftpluginName ]]; then
  echo there\'s a ftplugin;
  ftpluginName=`echo $ftpluginName| cut -d'=' -f 2`;
  echo $ftpluginName;
  pluginsLineStart=5;
else
  echo no ftplugin;
  pluginsLineStart=4;
fi
vimrcFilename=.vimrc;
if [[ ! -z "$osType" && $osType =~ *Windows ]]; then
  vimrcFilename=_vimrc;
fi
cd $destination;
# take action according to the command line parameters.
echo $#;
if [ $# -eq 0 ]; then # save initial state of the config and perform configuration;
  # write the names of the present plugins to a file.
  dirnamearr=( */ )
  cd -;
  if [ ! -e localPlugins.properties ]; then
    for user in "${dirnamearr[@]%*/}"; do
      echo $user >> localPlugins.properties;
    done
  fi
  cd -;

  set +e; # don't exit on error. This way even if plugins are downloaded or there's another error,
  # the rest of the plugins would be cloned.
  cat $currentDir/config.properties | sed -e '\_#.*_ d' -e 's/[ ^I]*$//' -e '/^$/ d' | tail -n +$pluginsLineStart | while read line; do
  echo cloning from $line;
  git clone $line;
done
# create symlink to the filetype configuration
ln -s $currentDir/$ftpluginName;

echo working directory path: $workingDir;
cd $workingDir;
# check if another .vimrc is already present.
if [ -f $vimrcFilename ]; then
  mv $vimrcFilename $vimrcFilename.old; # save the old configuration to .vimrc.old for later use.
fi
# create .vimrc symlink.
if [[ ! -z "$osType" && $osType =~ *Windows ]]; then
  mklink $currentDir/$vimrcFilename;
else
  ln -s $currentDir/$vimrcFilename;
fi
#echo Config SUCCESSFUL!
exit
elif [ $# -eq 1 ]; then
  if [ "$1" == "-d" ]; then
    echo one arg, deleting plugins;
    if [ -f $ftpluginName ]; then
      rm $ftpluginName;
    fi
    # get names of old plugins.
    IFS=$'\r\n';
    oldPlugins=( $(cat $currentDir/localPlugins.properties) );
    unset IFS;
    # delete additional plugins.
    for plugin in $( find . -maxdepth 1 -mindepth 1 -type d | cat); do
      # check if plugin does not exist in oldPlugins
      isNewPlugin="true";
      for e in "${oldPlugins[@]}"; do 
        if [ "./$e" == "$plugin" ]; then
          isNewPlugin="false";
        fi
      done
      if [ "$isNewPlugin" == "true" ]; then
        rm -r $plugin; # if it doesn't - delete it.

      fi
      # otherwise leave it be.
    done
    rm $ftpluginName;
    # replace .vimrc with old version if exists. Otherwise just delete it.
    cd $workingDir;
    rm $vimrcFilename;
    if [ -f $vimrcFilename.old ]; then
      mv $vimrcFilename.old $vimrcFilename;
    fi
  elif [ "$1" == "-u" ]; then
    echo one arg, updating plugins;
    # get names of old plugins.
    IFS=$'\r\n';
    oldPlugins=( $(cat $currentDir/localPlugins.properties) );
    unset IFS;
    # update additional plugins.
    for plugin in $( find . -maxdepth 1 -mindepth 1 -type d | cat); do
      # check if plugin does not exist in oldPlugins
      isNewPlugin="true";
      for e in "${oldPlugins[@]}"; do 
        if [ "./$e" == "$plugin" ]; then
          isNewPlugin="false";
        fi
      done
      if [ "$isNewPlugin" == "true" ]; then
        # if it doesn't - update it.
        echo pulling in directory: $plugin;
        cd $plugin
        git pull;
        cd -
      fi
      # otherwise leave it be.
    done
  fi
fi
