## disable ssh access when users don't have a job
# on all machines except the controller
{% if grains['host'] != pillar['slurm']['controller'] %}
{% if grains['host'] != "bardolph" %}

libpam-slurm:
  pkg.installed 

/etc/pam.d/sshd-special:
  file.managed:
    - source: salt://slurm/files/etc/pam.d/sshd-special

# completely disable SSH
/etc/security/access.conf:
  file.managed:
    - source: salt://slurm/files/etc/security/access.conf

/etc/security/access.conf-special:
  file.managed:
    - source: salt://slurm/files/etc/security/access.conf-special


# FIXME ideally would just insert the line in /etc/pam/sshd 
/etc/pam.d/sshd:
  file.managed:
    - source: salt://slurm/files/etc/pam.d/sshd
{% endif %}
{% endif %}

