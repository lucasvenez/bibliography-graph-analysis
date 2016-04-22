MATCH
  (a:Word {value: "network" })<-[r:CONTAINS]-(o:Paper),
  (d:Word {value: "networks" })
CREATE (d)-[:CONTAINS]-(o)
DELETE r, a