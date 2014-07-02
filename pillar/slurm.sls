
slurm:
  controller: biomedia04.doc.ic.ac.uk
  nodes:
    bardolph.doc.ic.ac.uk:
      mem: 
      cores:
      features:
        - k40
        - gtx780
      gres:
        k40:1
        gtx780:1
      
  gres:
    - k40
    - gtx780

