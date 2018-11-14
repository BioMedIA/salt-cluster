#!/bin/bash
installed_pkgs=$(dpkg -l|grep slurm |awk '{print $2}') 
while [ "$installed_pkgs" ]; do
  for pkgs in $installed_pkgs; do
    echo $pkgs
    { #try
       apt-get remove --purge $pkgs
     } || { #catch
       dpkg -r $pkgs
       dpkg -P $pkgs
     }
  done
  installed_pkgs=$(dpkg -l|grep slurm |awk '{print $2}')
done
