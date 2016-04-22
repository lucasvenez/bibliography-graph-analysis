setwd("C:/Users/Lucas Venezian Povoa/Desktop")

require("RNeo4j")
require("ggplot2")

graph <- startGraph("http://localhost:7474/db/data/", username = "neo4j", password = "password")

top.words <- 
  cypher(graph,
         "MATCH (w:Word)--(p:Paper)
          RETURN w.value, count(p) as degree 
          ORDER BY degree DESC 
          LIMIT 20")

top.words$w.value <- factor(top.words$w.value, levels = top.words$w.value)

graph <- 
  ggplot(top.words) + 
  geom_bar(aes(w.value, degree), stat = "identity") +
  theme(axis.text.x = element_text(angle = -45, hjust = 0), legend.position = "none") +
  xlab("Palavra") + ylab("Número de publicações citando a palavra")

ggsave("top.words.all.years.pdf", width = 6, height = 4, units = "in")



