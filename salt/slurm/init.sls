
# The SLURM scheduling system

/etc/slurm-llnl/slurm.conf:
  file.managed:
    - source: salt://slurm/slurm.conf
    - template: jinja

/etc/slurm-llnl/slurm.cert:
  file.managed:
    - source: salt://slurm/slurm.cert
    - mode: 400

/var/spool/slurm-llnl:
  file.directory:
    - group: slurm
    - user: slurm
    - require:
      - user: slurm

{% if grains['host'] != pillar['slurm']['controller'] %}
/var/log/slurm-llnl/slurm.log:
  file.managed:
    - group: slurm
    - user: slurm
    - require:
      - user: slurm
{% endif %}

# specific to SLURM Controller
{% if grains['host'] == pillar['slurm']['controller'] %}
/etc/slurm-llnl/slurm.key:
  file.managed:
    - source: salt://slurm/slurm.key
    - mode: 400
      
/etc/slurm-llnl/slurmdbd.conf:
  file.managed:
    - source: salt://slurm/slurmdbd.conf
    - template: jinja

/var/log/slurm-llnl/slurmdbd.log:
  file.managed:
    - group: slurm
    - user: slurm
    - require:
      - user: slurm

/var/log/slurm-llnl/slurm_jobacct.log:
  file.managed:
    - group: slurm
    - user: slurm
    - require:
      - user: slurm

/var/log/slurm-llnl/slurmctld.log:
  file.managed:
    - group: slurm
    - user: slurm
    - require:
      - user: slurm

/var/log/slurm-llnl/sched.log:
  file.managed:
    - group: slurm
    - user: slurm
    - require:
      - user: slurm
{% endif %}


# State munge has to be included to allow dependency on munge package
include:
  - munge

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
  pkg.installed:
    - name: slurm-llnl 
  service.running:
    - name: slurm-llnl
    - watch:
      - user: slurm
      - pkg: slurm 
      - pkg: slurm-plugins
      - pkg: munge
      - file: /etc/slurm-llnl/slurm.conf
      - file: /var/spool/slurm-llnl
{% if grains['host'] == pillar['slurm']['controller'] %}
      - file: /var/log/slurm-llnl/sched.log
      - file: /var/log/slurm-llnl/slurmctld.log
#      - pkg: slurm-db
      - file: /etc/slurm-llnl/slurmdbd.conf
{% endif %}

slurm-plugins:
  pkg.installed:
    - name: slurm-llnl-basic-plugins

# TODO for the moment only bardolph has gres => to generalize!
{% if grains['host'] == "bardolph" %}
/etc/slurm-llnl/gres.conf:
  file.managed:
    - source: salt://slurm/bardolph/gres.conf
{% endif %}

