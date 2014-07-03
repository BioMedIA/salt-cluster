
slurm:
  controller: biomedia04.doc.ic.ac.uk
  nodes:
    bardolph.doc.ic.ac.uk:
      mem: 15973
      cores: 12
      gres:
        k40: 1
        gtx780: 1
      
  gres:
    - k40
    - gtx780

