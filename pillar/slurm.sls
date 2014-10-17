
slurm:
  controller: predict5
  nodes:
    gpus:
      bardolph:
        mem: 15973
        cores: 12
        gres:
          gpu: 2

    cpus:
    {% for N in range(1,5) %} 
      predict{{N}}:
        mem: 32177
        cores: 8
    {% endfor %}
    {% for N in range(6,9,2) %} 
      predict{{N}}:
        mem: 32177
        cores: 8
    {% endfor %}

    {% for N in range(1,4,2) %} 
      biomedia0{{N}}:
        mem: 64418
        cores: 24
    {% endfor %}
    {% for N in range(2,6,3) %} 
      biomedia0{{N}}:
        mem: 64417
        cores: 24
    {% endfor %}
    {% for N in range(6,10) %} 
      biomedia0{{N}}:
        mem: 128851
        cores: 64
    {% endfor %}
      biomedia10:
        mem: 128851
        cores: 24
      biomedia11:
        mem: 257920
        cores: 32

  gres:
    - gpu

