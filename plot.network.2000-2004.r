setwd("C:/Users/Lucas Venezian Povoa/Desktop")

library(igraph)
library(visNetwork)
library(RNeo4j)

graph = startGraph("http://localhost:7474/db/data/", username = "neo4j", password = "password")

edges <- 
  cypher(graph,
         "MATCH (a:Author)-[r1:WRITE]->(p:Paper)
          WHERE a.name IN ['jinde cao', 'haizhong an', 'guanrong chen'] AND 
          p.year >= 2000 AND p.year <= 2020 
          RETURN a.name AS from, p.title AS to")


edges <- rbind(edges,
  cypher(graph,
         "MATCH (a:Author)-[:WRITE]->(p:Paper)-[r2:CONTAINS]->(w:Word)
          WHERE a.name IN ['jinde cao', 'haizhong an', 'guanrong chen'] AND 
          p.year >= 2000 AND p.year <= 2020 
          RETURN p.title AS from, w.value AS to"))

nodes <- data.frame(id=unique(c(edges$from, edges$to)))
nodes$label <- nodes$id

visNetwork(nodes, edges) %>% visExport(type = "png", name = "export-network")