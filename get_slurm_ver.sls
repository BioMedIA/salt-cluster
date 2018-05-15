get slurmd ver:
  cmd.run:
    - name: dpkg -s slurmd |grep "^Version:" > /tmp/local_slurm_ver.txt
