
{% if grains['host'] == pillar['salt']['master'] %}

salt-master:
  pkg:
    - installed
  service:
    - running
    - watch:
      - pkg: salt-master
      - file: /etc/salt/master

/etc/salt/master:
  file.managed:
    - template: jinja
    - source: salt://salt/etc/salt/master
    - require:
      - pkg: salt-master

{% else %}

salt-minion:
  pkg:
    - installed
  service:
    - running
    - require:
      - file: /etc/salt/minion
    - watch:
      - pkg: salt-minion
      - file: /etc/salt/minion

/etc/salt/minion:
  file.managed:
    - template: jinja
    - source: salt://salt/etc/salt/minion
    - require:
      - pkg: salt-minion

{% endif %}

