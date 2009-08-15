#!/bin/bash
cd /usr/share/svnwc/
for X in `ls aurita_plugins` 
do
  echo "$X"
  cp aurita_plugins/$X/plugin.rb aurita_projects/cfmaier/plugins/$X.rb
done
cd -
