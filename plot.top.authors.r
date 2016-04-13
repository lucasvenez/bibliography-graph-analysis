setwd("C:/Users/Lucas Venezian Povoa/Desktop")

require("RNeo4j")
require("ggplot2")

graph = startGraph("http://localhost:7474/db/data/", username = "neo4j", password = "password")

top.authors <- 
  cypher(graph,
        "MATCH (a:Author)-[:WRITE]-(p:Paper) 
         RETURN a.name, COUNT(p) AS numberOfPapers 
         ORDER BY numberOfPapers DESC, a.name LIMIT 10")

top.authors$a.name <- factor(top.authors$a.name, levels = top.authors$a.name)

graph <- 
  ggplot(top.authors) + 
  geom_bar(aes(a.name, numberOfPapers), stat = "identity") +
  theme(axis.text.x = element_text(angle = -45, hjust = 0), legend.position = "none") +
  xlab("Autor") + ylab("Número de publicações")

ggsave("top.authors.all.years.pdf", width = 10, height = 5, units = "in")