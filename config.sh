#!/bin/bash
containsElement () {
  local e
  for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
    return 1
}
set -e; #if there are problems with the configuration - exit
currentDir=$(pwd);
destinationIsAbsolute=$( cat config.properties | set -e '\_#.*_ d' -e 's/[ ^I]*$//' -e '/^$/ d' | tail -n +1 | head -n 1);
destination=$( cat config.properties | sed -e '\_#.*_ d' -e 's/[ ^I]*$//' -e '/^$/ d' | tail -n +2 | head -n 1);
if [ "$destinationIsAbsolute" != "true" ]
then
  destination="$HOME$destination"
fi
echo bundle directory path: $destination;
workingDirIsAbsolute=$( cat config.properties | sed -e '\_#.*_ d' -e 's/[ ^I]*$//' -e '/^$/ d' | tail -n +3 | head -n 1);
workingDir=$( cat config.properties | sed -e '\_#.*_ d' -e 's/[ ^I]*$//' -e '/^$/ d' | tail -n +4 | head -n 1);
if [ "$workingDirIsAbsolute" != "true" ]; then
  workingDir="$HOME$workingDir";
fi
# get the name of the filetype plugin
ftpluginName=$( cat config.properties | sed -e '\_#.*_ d' -e 's/[ ^I]*$//' -e '/^$/ d' | tail -n +5 | head -n 1);
echo $ftpluginName
echo `[[ $ftpluginName =~ ^ftpluginName ]]`
if [[ $ftpluginName =~ ^ftpluginName ]]; then
  echo there\'s a ftplugin;
  ftpluginName=`echo $ftpluginName| cut -d'=' -f 2`;
  echo $ftpluginName;
  pluginsLineStart=6;
else
  echo no ftplugin;
  pluginsLineStart=5;
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
  if [ -f .vimrc ]; then
    mv .vimrc .vimrc.old; # save the old configuration to .vimrc.old for later use.
  fi
  # create .vimrc symlink.
  ln -s $currentDir/.vimrc;
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
    rm .vimrc
    if [ -f .vimrc.old ]; then
      mv .vimrc.old .vimrc;
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
        cd $plugin;
        git pull;
      fi
      # otherwise leave it be.
    done
  fi
fi
