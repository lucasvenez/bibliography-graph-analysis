#
# Carregando bibliotecas
#
library(igraph)
#
# Loading data
#
load("graph.1996.rda")
load("graph.2000.rda")
load("graph.2005.rda")
load("graph.2010.rda")
#
# Calculando as comunidades
# 
clusters.1996 = cluster_fast_greedy(graph.1996)
clusters.2000 = cluster_fast_greedy(graph.2000)
clusters.2005 = cluster_fast_greedy(graph.2005)
clusters.2010 = cluster_fast_greedy(graph.2010)
#
# Calculando o número de comunidades
#
clusters.1996.size <- length(clusters.1996)
clusters.2000.size <- length(clusters.2000)
clusters.2005.size <- length(clusters.2005)
clusters.2010.size <- length(clusters.2010)
#
# Degree
#
nodesDegree <- data.frame(nodes = names(degree(ig)), degree = as.numeric(degree(ig)))
#
# Calculando o numero de nós por comunidade
#
nodesPerCommunity <- c()

for(i in 1:length(clusters))
  nodesPerCommunity <- c(nodesPerCommunity, length(clusters[[i]]))
#
# Calculando o tamanho da componente gigante
#
cl <- clusters(ig)
giantComponentNodes <- V(induced.subgraph(ig, which(cl$membership == which.max(cl$csize))))

giantComponentSize   <- length(giantComponentNodes)
giantComponentTopTen <- head(subset(nodesDegree, node %in% row.names(as.matrix(giantComponentNodes))), n = 10)
#
# Calculando o nó com maior grau por comunidade
#
buzzwords <- list()

for (i in 1:length(clusters))
  buzzwords[[i]] <- head(subset(nodesDegree, node %in% clusters[[i]]), n = 4)

#####################################################################################################################
# Centrality Metrics
#
# Degree
#
dg.mean <- mean(nodesDegree$degree)
dg.sd   <- sd(nodesDegree$degree)
#
# Assortatividade
#
assortativity <- assortativity_degree(ig, directed = F)
#
# Shortest path 
#
sp <- shortest.paths(ig)
sp.mean <- mean(sp)
sp.sd   <- sd(sp)
sp.max  <- max(sp) # radius
sp.min  <- min(sp) # diameter
#
# Betweenness centrality
#
bt <- betweenness(ig)
bt.mean <- mean(bt)
bt.sd   <- sd(bt)
#
# Cluster coefficient
#
cluster.coefficient <- transitivity(ig)
#
# Saving data
#
l <- list(giantComponentSize   = giantComponentSize, 
          giantComponentTopTen = giantComponentTopTen,
          numberOfCommunities  = numberOfCommunities, 
          nodesPerCommunity    = nodesPerCommunity, 
          buzzwords            = buzzwords,
          nodesDegree          = nodesDegree)

save(l, file = "community.rda")