# Should not have screen installed on the nodes

screen:
  pkg:
    - removed

/etc/apt/preferences.d/screen-policy:
  file.managed:
    - source: salt://screen/etc/apt/preferences.d/screen-policy
    - mode: 644

