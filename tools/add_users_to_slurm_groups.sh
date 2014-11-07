#!/bin/bash

for i in `grep biomedia /etc/group | cut -d ':' -f 4 | sed -e 's/,/ /g' `; do yes | sacctmgr add user $i DefaultAccount=biomedia; done
