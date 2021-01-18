#! /bin/bash

PKG_LIST=("samtools" "conda" "minimap2" "f5c")

for package in "${PKG_LIST[@]}"
do 
   $package --version >/dev/null
   if [ $? -eq 0 ]; then
       echo $package loaded
   else
       echo $package not loaded, installed, or on PATH!
   fi
done

