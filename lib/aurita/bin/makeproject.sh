#!/bin/bash

PRJ_NAME=$1

AURITA_PRJ_PATH="/usr/share/svnwc/aurita_projects"
AURITA_PATH="/usr/share/svnwc/aurita/trunk"
PRJ_PATH=$AURITA_PRJ_PATH/$PRJ_NAME

if [ -n "$1" ] 
then
  echo "Creating directory structure ..."
  cp -ax $AURITA_PATH/setup/project_template $PRJ_PATH
  echo "Fixing permissions ..."
  chown -R www-data:www-data $PRJ_PATH/public/assets
  chown -R www-data:www-data $PRJ_PATH/cache
  chmod -R 770 $PRJ_PATH/public/assets
  chmod -R 770 $PRJ_PATH/cache
  echo "Creating symlinks ..."
  ln -s $AURITA_PATH/main/public/shared $PRJ_PATH/public/shared
  echo "Creating database ..."
  createdb $PRJ_NAME --encoding=Unicode
  psql $PRJ_NAME < $AURITA_PATH/setup/aurita_schema.sql
else 
  echo "Please pass project name as argument"
fi

