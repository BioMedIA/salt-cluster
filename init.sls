# munge.key must be the same across all the nodes of the cluster

munge:
  pkg:
    - installed
  group.present:
    - system: True
    - gid: 98
  user.present:
    - uid: 69
    - gid_from_name: True
    - system: True
    - shell: /bin/true
    - createhome: False
  service.running:
    - name: munge
    - enable: False
    - require:
      - file: /etc/munge/munge.key

#stop munge:
#  cmd.run:
#    - name: systemctl stop munge
/var/log/munge:
  file.directory:
    - group: munge
    - user: munge
    - recurse:
      - user
      - group
    - require:
      - user: munge
/var/run/munge:
  file.directory:
    - group: munge
    - user: munge
    - recurse:
      - user
      - group
    - require:
      - user: munge

/var/lib/munge:
  file.directory:
    - group: munge
    - user: munge
    - recurse:
      - user
      - group
    - require:
      - user: munge

/etc/munge:
  file.directory:
    - group: munge
    - user: munge
    - recurse:
      - user
      - group
    - require:
      - user: munge

/run/munge:
  file.directory:
    - group: munge
    - user: munge
    - recurse:
      - user
      - group
    - require:
      - user: munge
#reload munge:
#  cmd.run:
#    - name: systemctl start munge


#munge:
#  pkg:
#    - installed
#  service.running:
#    - enable: False
#  group.present:
#    - system: True
#    - gid: 98
#  user.present:
#    - uid: 69
#    - gid_from_name: True
#    - system: True
#    - shell: /bin/true
#    - createhome: False
#  service.running:
#    - name: munge
#    - watch: 
#      - user: munge
#      - file: /etc/munge/munge.key
#    - require:
#      - pkg: munge
#      - user: munge
#      - file: /etc/munge/munge.key

#install munge:
#  pkg:
#    - installed
#  service.running:
#    - enable: False

copy munge.key file:
  file.managed:
    - name: /etc/munge/munge.key
    - source: salt://munge.key

#reload munge:
#  service.running:
#    - enable: True
#    - reload: True
#    - watch:
#       - pkg: munge


starting munge:
  cmd.run:
    - name: systemctl start munge


install dependencies for Slurm:
  cmd.run:
    - name: aptitude install -y libipmimonitoring5a

install slurm packages from local repo:
  pkg.installed:
    - sources:
      - libhdf5: salt://slurm_deb/libhdf5-100_1.10.0-patch1+docs-3_amd64.deb
      - libhwloc5: salt://slurm_deb/libhwloc5_1.11.5-1_amd64.deb
      - libpng16: salt://slurm_deb/libpng16-16_1.6.28-1_amd64.deb
      - libreadline7: salt://slurm_deb/libreadline7_7.0-0ubuntu2_amd64.deb
      - librrd8: salt://slurm_deb/librrd8_1.6.0-1_amd64.deb
      - slurm-wlm-basic-plugins: salt://slurm_deb/slurm-wlm-basic-plugins_16.05.9-1ubuntu1_amd64.deb
      - slurmd: salt://slurm_deb/slurmd_16.05.9-1ubuntu1_amd64.deb


# TODO handle different names given distro (slurm, slurm-llnl, ...)
slurm:
  group.present:
    - system: True
    - gid: 97
  user.present:
    - fullname: SLURM daemon user account
    - uid: 14
    - gid_from_name: True
    - system: True
    - home: /var/spool/slurm-llnl
    - shell: /bin/true
#  service.running:
#    - name: slurmd
#    - watch:
#    - require:
#      - pkg: slurmd
#      - user: slurm
#      - file: /etc/slurm-llnl/slurm.conf
#      - file: /var/spool/slurm-llnl


# The SLURM scheduling system

/etc/slurm-llnl/slurm.conf:
  file.managed:
    - name: /etc/slurm-llnl/slurm.conf
    - source: salt://slurm.conf

/etc/slurm-llnl/cgroup.conf:
  file.managed:
    - name: /etc/slurm-llnl/cgroup.conf
    - source: salt://cgroup.conf

/etc/slurm-llnl/gres.conf:
  file.managed:
    - name: /etc/slurm-llnl/gres.conf
    - source: salt://gres.conf

/etc/slurm-llnl/slurm.cert:
  file.managed:
    - name: /etc/slurm-llnl/slurm.cert
    - source: salt://slurm.cert

/etc/slurm-llnl/slurm.key:
  file.managed:
    - name: /etc/slurm-llnl/slurm.key
    - source: salt://slurm.key


/var/spool/slurm-llnl:
  file.directory:
    - group: slurm
    - user: slurm
    - recurse:
      - user
      - group
    - require:
      - user: slurm


/var/run/slurm-llnl:
  file.directory:
    - group: slurm
    - user: slurm
    - recurse:
      - user
      - group
    - require:
      - user: slurm

/var/log/slurm-llnl:
  file.directory:
    - group: slurm
    - user: slurm
    - recurse:
      - user
      - group
    - require:
      - user: slurm
reload slurmd:
  cmd.run:
    - name: systemctl restart slurmd
