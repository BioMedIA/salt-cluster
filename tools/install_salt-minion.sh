#!/bin/bash

####
#
# Initial installation of salt minion packages and configuration files
# from the salt master.
#
####

ssh -oStrictHostKeyChecking=no $1 aptitude -y install salt-minion
scp -oStrictHostKeyChecking=no /etc/salt/minion $1:/etc/salt/
ssh -oStrictHostKeyChecking=no $1 /etc/init.d/salt-minion restart

