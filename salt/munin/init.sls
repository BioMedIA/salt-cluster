# Install munin-node on each node of the cluster (controller included)

munin-node:
  pkg:
    - installed

/etc/munin/munin-node.conf:
  file.append:
    - text: [ "cidr_allow 146.169.2.177/24", "host_name {{ grains['host'] }}" ]

