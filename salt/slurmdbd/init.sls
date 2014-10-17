
# The SLURM scheduling system accounting database plugin

# specific to SLURM Controller
{% if grains['host'] == pillar['slurm']['controller'] %}
/etc/slurm-llnl/slurmdbd.conf:
  file.managed:
    - source: salt://slurmdbd/slurmdbd.conf
    - template: jinja

/var/log/slurm-llnl/slurmdbd.log:
  file.managed:
    - group: slurm
    - user: slurm
    - require:
      - user: slurm

# TODO handle different names given distro (slurm, slurm-llnl, ...)
slurmdbd:
  pkg.installed:
    - pkgs:
      - slurm-llnl-slurmdbd
      - mysql-server
  service.running:
    - name: slurm-llnl-slurmdbd
    - watch:
      - file: /etc/slurm-llnl/slurmdbd.conf
{% endif %}

