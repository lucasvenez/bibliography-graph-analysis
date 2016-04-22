setwd("C:/Users/Lucas Venezian Povoa/Desktop")

require("RNeo4j")
require("ggplot2")

graph <- startGraph("http://localhost:7474/db/data/", 
                    username = "neo4j", password = "password")

top.words.per.period <- data.frame()

for (i in 0:8) {
  
  start <- 1970 + (i * 5)
  
  end   <- start + 4
  
  top.words <- 
    cypher(graph,
      "MATCH (w:Word)--(p:Paper)
       WHERE w.value IN ['networks', 'complex', 'systems', 'model', 'different', 
                         'study', 'analysis', 'structure', 'method', 'cells', 
                         'data', 'control', 'important', 'time', 'nodes'] AND
             p.year >= {start} AND p.year <= {end}
       RETURN w.value, count(p) as degree 
       ORDER BY degree DESC", start = start, end = end)

  top.words$w.value <- factor(top.words$w.value, levels = top.words$w.value)
  
  top.words <- cbind(top.words, data.frame(period = paste(start, end, sep = "-")))
  
  top.words.per.period <- rbind(top.words.per.period, top.words)
}

graph <- 
  ggplot(top.words.per.period, 
         aes(period, degree, colour = w.value, fill = w.value, group = w.value)) + 
    geom_line(size = 1, alpha = .6) + geom_point(size = 2) +
    scale_fill_hue("Palavras") + scale_colour_hue("Palavras") +
    theme(panel.grid.major.x = element_blank()) +
    xlab("Autor") + ylab("Número de publicações")

ggsave("top.words.per;period.pdf", width = 10, height = 5, units = "in")
   