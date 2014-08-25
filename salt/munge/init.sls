# Munge provides authentication for SLURM

# munge.key must be the same across all the nodes of the cluster
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
    - require:
      - pkg: munge
      - user: munge
      - file: /etc/munge/munge.key

/etc/munge/munge.key:
  file.managed:
    - group: munge
    - user: munge
    - source: salt://munge/munge.key
    - mode: 400
    - require:
      - user: munge

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

/etc/munge:
  file.directory:
    - group: munge
    - user: munge
    - recurse:
      - user
      - group
    - require:
      - user: munge

