
# Slurm Salt formula

Salt formula provisioning a Slurm cluster

To install Slurm nodes, you need to copy (on Slurm mater node)

- munge.key from /etc/munge/munge.key to /srv/salt/munge.key
- slurm.cert from /etc/slurm-llnl/slurm.cert to /srv/salt/slurm.cert
- slurm.conf from files/etc/slurm-llnl/slurm.conf to /srv/salt/slurm.conf
- create empty cgroup.conf and gres.conf in /srv/salt/
