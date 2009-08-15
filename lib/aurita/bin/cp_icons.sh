#!/bin/bash

cd /usr/share/svnwc/
# for icon in `find aurita_projects/default/public/assets/ -name 'asset_*.jpg' | grep -v 'asset_1' | sed s/aurita_projects\\\/default\\\/public\\\/assets\\\///g`; do
for icon in `find aurita/setup/project_template/public/assets/ -name 'asset_*.jpg' | grep -v 'asset_1' | sed s/aurita\\\/setup\\\/project_template\\\/public\\\/assets\\\///g`; do
  echo "cp aurita/setup/project_template/public/assets/${icon} aurita_projects/cfmaier/public/assets/${icon}"
  cp aurita/setup/project_template/public/assets/${icon} aurita_projects/cfmaier/public/assets/${icon}
done
cd -
