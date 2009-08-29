#!/bin/bash

for x in `ls /usr/share/svnwc/aurita_projects`; do 
  echo $x
  sudo cp -ax aurita_projects/${x}/public/assets ~/asset_backup/${x}; 
done
echo "Creating archive ..."
tar -cfu assets_backup.tar ~/assets_backup
echo "done."

