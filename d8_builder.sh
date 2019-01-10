#!/bin/bash

# path for install
folder="./"
# Parh for get last realese version.
d4d_last_version(){
 curl https://github.com/wodby/docker4drupal/releases/latest | grep -Eo "[0-9]+\.[0-9]+\.[0-9]+"
}

# If not empty path param
if [[ ! -z "$1" ]]
then
  folder=$1
fi

# Clear directory
rm -rf *
rm -rf .*

# Download d4d and unpacking
wget -N -P $folder https://github.com/wodby/docker4drupal/releases/download/$(d4d_last_version)/docker4drupal.tar.gz

cd $folder
tar -xvf docker4drupal.tar.gz 
rm -rf docker-compose.override.yml docker4drupal.tar.gz

# Download Drupal project
rm -rf .git/
git clone https://github.com/drupal-composer/drupal-project.git
mv ./drupal-project/* ./
mv ./drupal-project/.* ./
rm -rf ./drupal-project
rm -rf .git/

echo 'Docker4Drupal version: '$(d4d_last_version)
echo 'Installed in: '$folder
