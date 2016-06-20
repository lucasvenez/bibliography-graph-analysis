#
# Carregando bibliotecas
#
library(igraph)
library(RNeo4j)
library(visNetwork)
#
# Conectando no banco de dados
#
graph = startGraph("http://localhost:7474/db/data/", username = "neo4j", password = "password")
#
# Definindo consulta limitada a 200 linhas para teste
#
query = "MATCH (w1)-->(w2) RETURN w1.value AS from, w2.value AS to"
#
# Executando a consulta gerando um data.frame com as colunas from e to represetando as arestas
#
edges = cypher(graph, query)
#
# Convertendo os data.frames para um tipo especifico do igraph
#
ig = graph_from_data_frame(edges, directed=F)
#
# Calculando as comunidades
# 
clusters = cluster_fast_greedy(ig)
#
# Definindo as cores dos nós
#
V(ig)$color <- clusters$membership + 40
#
# Calculando o número de comunidades
#
numberOfCommunities <- length(clusters)
#
# Calculando o grau de cada nó
#
query <- "MATCH (w1)--(w2) RETURN w1.value AS node, 
                COUNT(w2) AS degree ORDER BY degree DESC"
nodesDegree <- cypher(graph, query)
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

giantComponentSize <- length(giantComponentNodes)
giantComponentTopTen <- head(subset(nodesDegree, node %in% row.names(as.matrix(giantComponentNodes))), n = 10)
#
# Calculando o nó com maior grau por comunidade
#
buzzwords <- list()

for (i in 1:length(clusters))
  buzzwords[[i]] <- head(subset(nodesDegree, node %in% clusters[[i]]), n = 4)
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