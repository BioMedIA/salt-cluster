
# Munge provides authentication for SLURM

# munge.key must be the same across all the nodes of the cluster
/etc/munge/munge.key:
  file:
    - managed
    - source: salt://slurm/munge.key
    - mode: 400
    - user: munge
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
    - user: slurm
    - require:
      - user: slurm

/var/spool/slurm:
  file.directory:
    - user: slurm
    - require:
      - user: slurm

slurm:
  user.present:
    - fullname: SLURM daemon user account
    - uid: 451
    - gid: 451
    - home: /var/spool/slurm
    - shell: /bin/true
  pkg:
    - installed
    - name: slurm-llnl 
  service.running:
    - name: slurm-llnl
    - watch:
      - pkg: slurm 
      - pkg: slurm-plugins
# specific to SLURM Controller
{% if grains['host'] == pillar['slurm']['controller'] %}
      - pkg: slurm-db
      - pkg: slurm-sview
      - file: /etc/slurm-llnl/slurmdbd.conf
{% endif %}
      - user: slurm
      - pkg: munge
      - file: /etc/slurm-llnl/slurm.conf
      - file: /var/spool/slurm

slurm-plugins:
  pkg:
    - installed
    - name: slurm-llnl-basic-plugins

# specific to SLURM Controller
{% if grains['host'] == pillar['slurm']['controller'] %}
/etc/slurm-llnl/slurmdbd.conf:
  file:
    - managed
    - source: salt://slurm/slurmdbd.conf
    - template: jinja

/etc/slurm-llnl/slurm.key:
  file:
    - managed
    - source: salt://slurm/slurm.key
    - mode: 400
    - user: slurm
    - require:
      - user: slurm
      
slurm-db:
  name: slurm-llnl-slurmdbd
  pkg:
    - installed

slurm-sview:
  name: slurm-llnl-sview
  pkg:
    - installed
{% endif %}

# TODO for the moment only bardolph has gres => to generalize!
{% if grains['host'] == "bardolph" %}
/etc/slurm-llnl/gres.conf:
  file:
    - managed
    - source: salt://slurm/bardolph/gres.conf
{% endif %}

