
slurm:
  controller: predict5
  nodes:
    batch:
      gpus:
        bardolph:
          mem: 15972
          cores: 12
          gres:
            gpu: 2

      cpus:
        predict1:
          mem: 30160
          cores: 8
      {% for N in range(2,4) %}
        predict{{N}}:
          mem: 32176
          cores: 8
      {% endfor %}
      {% for N in range(6,9,2) %}
        predict{{N}}:
          mem: 32176
          cores: 8
      {% endfor %}

      {% for N in range(1,4,2) %}
        biomedia0{{N}}:
          mem: 64417
          cores: 24
      {% endfor %}
      {% for N in range(2,6,3) %}
        biomedia0{{N}}:
          mem: 64417
          cores: 24
      {% endfor %}
      {% for N in range(6,10) %}
        biomedia0{{N}}:
          mem: 128850
          cores: 64
      {% endfor %}
        biomedia10:
          mem: 128851
          cores: 24
      {% for N in range(4,13) %}
        roc{{ "%02d" % N }}:
          mem: 257906
          cores: 32
      {% endfor %}

    interactive:
      cpus:
        biomedia11:
          mem: 257919
          cores: 32
        {% for N in range(1,4) %}
        roc{{ "%02d" % N }}:
          mem: 257906
          cores: 32
        {% endfor %}


  gres:
    - gpu

  db:
    name: slurmdb
    user: slurm
    password: 1BUy4eVv7X

