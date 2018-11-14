# for reconfiguring CPU nodes only
# check munge.key
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
