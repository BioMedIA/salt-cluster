
# Munge provides authentication for SLURM

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

/var/spool/slurm:
  file.directory:
    - user: slurm
    - require:
      - user: slurm

slurm:
  name: slurm-llnl
  user:
    - present
  pkg:
    - installed
  service.running:
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
  name: slurm-llnl-basic-plugins
  pkg:
    - installed

# specific to SLURM Controller
{% if grains['host'] == pillar['slurm']['controller'] %}
/etc/slurm-llnl/slurmdbd.conf:
  file:
    - managed
    - source: salt://slurm/slurmdbd.conf
    - template: jinja

slurm-db:
  name: slurm-llnl-slurmdbd
  pkg:
    - installed

slurm-sview:
  name: slurm-llnl-sview
  pkg:
    - installed
{% endif %}
