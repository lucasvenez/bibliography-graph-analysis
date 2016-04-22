library(igraph)
library(visNetwork)
library(RNeo4j)

neo4j <- startGraph("http://localhost:7474/db/data/", 
                    username = "neo4j", password = "password")

nodes_query = "
MATCH (a:Author)-[:WRITE]->(p:Paper) 
WHERE a.name IN ['jinde cao', 'haizhong an', 'guanrong chen'] AND 
p.year <= 2005
RETURN DISTINCT ID(a) AS id, a.name AS name, LABELS(a) AS type
"

nodes <- cypher(neo4j, nodes_query)

nodes_query = "
MATCH (a:Author)-[:WRITE]->(p:Paper) 
WHERE a.name IN ['jinde cao', 'haizhong an', 'guanrong chen'] AND 
p.year <= 2005 
RETURN DISTINCT ID(p) AS id, p.title AS name, LABELS(p) AS type
"

nodes <- rbind(nodes, cypher(neo4j, nodes_query))

nodes_query = "
MATCH (w:Word)<-[:CONTAINS]-(p:Paper)<-[:WRITE]-(a:Author)
WHERE a.name IN ['jinde cao', 'haizhong an', 'guanrong chen'] AND 
p.year <= 2005
RETURN DISTINCT ID(w) AS id, w.value AS name, LABELS(w) AS type
"

nodes <- rbind(nodes, cypher(neo4j, nodes_query))

edges_query = "
MATCH (a:Author)-[:WRITE]->(p:Paper)
WHERE a.name IN ['jinde cao', 'haizhong an', 'guanrong chen'] AND 
p.year <= 2005
RETURN ID(a) AS source, ID(p) AS target
"

edges = cypher(neo4j, edges_query)

edges_query = "
MATCH (a:Author)-[:WRITE]->(p:Paper)-[:CONTAINS]->(w:Word)
WHERE a.name IN ['jinde cao', 'haizhong an', 'guanrong chen'] AND 
p.year <= 2005
RETURN ID(p) AS source, ID(w) AS target
"

edges <- rbind(edges, cypher(neo4j, edges_query))

nodes$type <- as.factor(nodes$type)

# Create igraph graph object.
ig = graph.data.frame(edges, directed = FALSE, nodes)

ig$layout=layout.fruchterman.reingold(ig,weights=E(ig)$weight)

# Run Girvan-Newman clustering algorithm.
# communities = edge.betweenness.community(ig)

# Extract cluster assignments and merge with nodes data.frame.
# memb = data.frame(name = communities$names, cluster = communities$membership)
# nodes = merge(nodes, memb)

# Reorder columns.
# nodes = nodes[c("id", "name", "cluster")]

# edge.weights <- function(community, network, weight.within = 100, weight.between = 1) {
#   bridges <- crossing(communities = community, graph = network)
#   weights <- ifelse(test = bridges, yes = weight.between, no = weight.within)
#   return(weights) 
# }

#E(ig)$weight <- edge.weights(communities, ig)

ig$layout=layout.fruchterman.reingold(ig,weights=E(ig)$weight)

par(mar=c(0,0,0,0))
plot.igraph(ig, layout = ig$layout, vertex.size = 3, vertex.label = NA, 
            vertex.color = nodes$type, edge.arrow.size = 0, asp = 0, edge.color = "gainsboro")