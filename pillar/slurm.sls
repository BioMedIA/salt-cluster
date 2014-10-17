
slurm:
  controller: predict5
  nodes:
    gpus:
      bardolph:
        mem: 15972
        cores: 12
        gres:
          gpu: 2

    cpus:
    {% for N in range(1,5) %} 
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
      biomedia11:
        mem: 257919
        cores: 32
    {% for N in range(1,12) %}
      roc{{ "%02d" % N }}:
        mem: 257906
        cores: 32
    {% endfor %}

  gres:
    - gpu

