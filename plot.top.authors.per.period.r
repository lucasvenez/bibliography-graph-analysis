setwd("C:/Users/Lucas Venezian Povoa/Desktop")

require("RNeo4j")
require("ggplot2")

graph = startGraph("http://localhost:7474/db/data/", username = "neo4j", password = "password")

top.authors.per.period <- data.frame()

for (i in 0:4) {

  start <- 2000 + (i * 5)
  end   <- start + 4
  
  top.authors <- 
    cypher(graph,
           "MATCH (a:Author)--(p:Paper)
           WHERE a.name IN ['jinde cao', 'haizhong an', 'guanrong chen', 'xiangyun gao', 'yong deng',
                            'xingyuan wang', 'wuneng zhou', 'huaguang zhang', 'jürgen kurths',
                            'ying fan', 'daijun wei', 'ernesto estrada', 'fang liu', 'hongtao lu',
                            'huajiao li'] AND
           p.year >= {start} AND p.year <= {end}
           RETURN a.name, count(p) as numberOfPapers 
           ORDER BY numberOfPapers DESC", start = start, end = end)
  
  if (!is.null(top.authors)) {
  
    top.authors$a.name <- factor(top.authors$a.name, levels = top.authors$a.name)
  
    top.authors.per.period <- rbind(top.authors.per.period, cbind(top.authors, data.frame(period = paste(start, end, sep = "-"))))
  }
}

top.authors.per.period

graph <- 
  ggplot(top.authors.per.period, 
         aes(a.name, numberOfPapers, colour = period, fill = period, group = period)) + 
  geom_bar(stat = "identity") +
  scale_fill_hue("Período") + scale_colour_hue("Período") +
  theme(axis.text.x = element_text(angle = -45, hjust = 0)) +
  xlab("Autor") + ylab("Número de publicações")

ggsave("top.authors.per.periodo.pdf", graph, width = 6, height = 4, units = "in")