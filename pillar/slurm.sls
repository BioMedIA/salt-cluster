
slurm:
  controller: biomedia04
  accounting: 
  nodes:
    bardolph:
      mem: 15973
      cores: 12
      gres:
        gpu: 2
      
  gres:
    - gpu

