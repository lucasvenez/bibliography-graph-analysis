setwd("C:/Users/Lucas Venezian Povoa/Desktop")

require("RNeo4j")
require("ggplot2")

graph = startGraph("http://localhost:7474/db/data/", username = "neo4j", password = "password")

top.authors.per.period <- data.frame()

for (i in 0:2) {

  start <- 2000 + (i * 5)
  end   <- start + 4
  
  top.authors <- 
    cypher(graph,
           "MATCH (a:Author)-[:WRITE]-(p:Paper) 
            WHERE p.year >= {start} AND p.year <= {end}
            RETURN a.name, COUNT(p) AS numberOfPapers 
            ORDER BY numberOfPapers DESC, a.name LIMIT 10", start = start, end = end)
  
  top.authors$a.name <- factor(top.authors$a.name, levels = top.authors$a.name)
  
  top.authors.per.period <- rbind(top.authors.per.period, cbind(top.authors, data.frame(period = paste(start, end, sep = "-"))))
}

top.authors.per.period

graph <- 
  ggplot(top.authors.per.period) + 
  geom_bar(aes(a.name, numberOfPapers), stat = "identity") +
  theme(axis.text.x = element_text(angle = -45, hjust = 0), legend.position = "none") +
  scale_fill_hue("Autor") + scale_colour_hue("Autor") +
  xlab("Autor") + ylab("Número de publicações") +
  facet_grid(. ~ period, scale = "free")

ggsave("top.authors.per.periodo.pdf", graph, width = 6, height = 4, units = "in")