
# Munge provides authentication for SLURM

# munge.key must be the same across all the nodes of the cluster
/etc/munge/munge.key:
  file:
    - managed
    - source: salt://slurm/munge.key
    - mode: 400
    - require:
      - user: munge

munge:
  pkg:
    - installed
  user:
    - present
  service:
    - running
    - require:
      - pkg: munge
      - file: /etc/munge/munge.key

# The SLURM scheduling system

/etc/slurm-llnl/slurm.conf:
  file:
    - managed
    - source: salt://slurm/slurm.conf
    - template: jinja

/etc/slurm-llnl/slurm.cert:
  file:
    - managed
    - source: salt://slurm/slurm.cert
    - mode: 400

/var/spool/slurm-llnl:
  file.directory:
    - group: slurm
    - user: slurm
    - require:
      - group: slurm
      - user: slurm

# specific to SLURM Controller
{% if grains['host'] == pillar['slurm']['controller'] %}
/etc/slurm-llnl/slurm.key:
  file:
    - managed
    - source: salt://slurm/slurm.key
    - mode: 400
      
slurm-sview:
  pkg:
    - installed
    - name: slurm-llnl-sview

/var/log/slurm-llnl/slurmctld.log:
  file:
    - managed
    - group: slurm
    - user: slurm
    - require:
      - group: slurm
      - user: slurm

/var/log/slurm-llnl/sched.log:
  file:
    - managed
    - group: slurm
    - user: slurm
    - require:
      - group: slurm
      - user: slurm
{% endif %}

# TODO handle different names given distro (slurm, slurm-llnl, ...)
slurm:
  group.present:
    - gid: 451
    - system: True
  user.present:
    - fullname: SLURM daemon user account
    - gid: 451
    - uid: 451
    - home: /var/spool/slurm-llnl
    - shell: /bin/true
  pkg:
    - installed
    - name: slurm-llnl 
  service.running:
    - name: slurm-llnl
    - watch:
      - pkg: slurm 
      - pkg: slurm-plugins
      - user: slurm
      - pkg: munge
      - file: /etc/slurm-llnl/slurm.conf
      - file: /var/spool/slurm-llnl
{% if grains['host'] == pillar['slurm']['controller'] %}
      - file: /var/log/slurm-llnl/sched.log
      - file: /var/log/slurm-llnl/slurmctld.log
{% endif %}

slurm-plugins:
  pkg:
    - installed
    - name: slurm-llnl-basic-plugins

# TODO for the moment only bardolph has gres => to generalize!
{% if grains['host'] == "bardolph" %}
/etc/slurm-llnl/gres.conf:
  file:
    - managed
    - source: salt://slurm/bardolph/gres.conf
{% endif %}

