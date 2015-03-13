# Ubuntu Utopic required for Slurm 2.6.7

/etc/apt/preferences.d/disable-utopic-policy:
  file.managed:
    - source: salt://ubuntu-utopic/etc/apt/preferences.d/disable-utopic-policy
    - mode: 644

/etc/apt/preferences.d/slurm-utopic-policy:
  file.managed:
    - source: salt://ubuntu-utopic/etc/apt/preferences.d/slurm-utopic-policy
    - mode: 644

/etc/apt/sources.list.d/utopic.list:
  file.managed:
    - source: salt://ubuntu-utopic/etc/apt/sources.list.d/utopic.list
    - mode: 644

