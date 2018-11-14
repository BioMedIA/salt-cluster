# for reconfiguring GPU nodes only to update the slurm.conf

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

pre copy the slurm.conf:
  file.managed:
    - name: /tmp/slurm.conf
    - source: salt://slurm_conf_files/slurm.conf

{% if salt['cmd.run'](' diff /tmp/slurm.conf /etc/slurm-llnl/slurm.conf ') %}

/etc/slurm-llnl/slurm.conf:
  file.managed:
    - name: /etc/slurm-llnl/slurm.conf
    - source: salt://slurm_conf_files/slurm.conf

slurmd re-start:
  cmd.run:
    - name: systemctl restart slurmd

{% endif %}
