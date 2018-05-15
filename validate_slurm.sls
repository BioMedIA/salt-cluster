# check munge.key
munge:
  pkg:
    - installed
  group.present:
    - system: True
    - gid: 98
  user.present:
    - uid: 98
    - gid_from_name: True
    - system: True
    - shell: /bin/true
    - createhome: False
  service.running:
    - name: munge
    - require:
      - pkg: munge
      - user: munge
      - file: /etc/munge/munge.key

/var/log/munge:
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

/var/lib/munge:
  file.directory:
    - group: munge
    - user: munge
    - recurse:
      - user
      - group
    - require:
      - user: munge
precopy munge.key file:
  file.managed:
    - name: /tmp/master_munge.key
    - source: salt://slurm_conf_files/munge.key

#check if munge.key are different:
{% if salt['cmd.run'](" diff /tmp/master_munge.key /etc/munge/munge.key" ) %}

munge key diff output:
  cmd.run:
    - name: echo "munge keys are different. New key is to be copied from Salt master"

munge key diff output:
  cmd.run:
    - name: echo "diff"
copy munge.key file:
  file.managed:
    - name: /etc/munge/munge.key
    - source: salt://slurm_conf_files/munge.key
munge re-start:
  cmd.run:
    - name: systemctl restart munge

{% else %}
munge key no diff output:
  cmd.run:
    - name: echo "munge key is identical with Salt master, no further action needed."
{% endif %}

# === check slurm ===
copy slurm controller ver:
  file.managed:
    - name: /tmp/slurm_master_ver.txt
    - source: salt://slurm_conf_files/slurm_ver.txt

get slurmd ver:
  cmd.run:
    - name: dpkg -s slurmd |grep "^Version:" > /tmp/local_slurm_ver.txt

#check versions:
{% if salt['cmd.run'](" diff /tmp/slurm_master_ver.txt /tmp/local_slurm_ver.txt >/dev/null ")!=0 %}
check ver output:
  cmd.run:
    - name: echo "slurm versions are different, old ones are to be removed, new ones are installing"

copy sh to remove old slurm:
  file.managed:
    - name: /tmp/remove_old_slurm.sh
    - source: salt://remove_old_slurm.sh
    - mode: 777

remove old slurm:
  cmd.run:
    - name: /tmp/remove_old_slurm.sh

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

{% else %}
ver no diff output:
  cmd.run:
    - name: echo "Slurm version is same as Slurm master, no need to install Slurm"
{% endif %}

# TODO handle different names given distro (slurm, slurm-llnl, ...)
slurm:
  group.present:
    - system: True
    - gid: 97
  user.present:
    - fullname: SLURM daemon user account
    - uid: 97
    - gid_from_name: True
    - system: True
    - home: /var/spool/slurm-llnl
    - shell: /bin/true
  service.running:
    - name: slurmd
    - require:
      - file: /etc/slurm-llnl/slurm.conf

# The SLURM scheduling system

/etc/slurm-llnl/slurm.conf:
  file.managed:
    - name: /etc/slurm-llnl/slurm.conf
    - source: salt://slurm_conf_files/slurm.conf

/etc/slurm-llnl/cgroup.conf:
  file.managed:
    - name: /etc/slurm-llnl/cgroup.conf
    - source: salt://slurm_conf_files/cgroup.conf

/etc/slurm-llnl/gres.conf:
  file.managed:
    - name: /etc/slurm-llnl/gres.conf

/etc/slurm-llnl/slurm.cert:
  file.managed:
    - name: /etc/slurm-llnl/slurm.cert
    - source: salt://slurm_conf_files/slurm.cert

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

slurmd re-start:
  cmd.run:
    - name: systemctl restart slurmd
