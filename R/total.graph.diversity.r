#' Calculates the total graph diversity metric of a graph
#' @author Lucas Venezian Povoa lucasvenez@@gmail.com
#' @references Justin P. Rohrer, Abdul Jabbar, James P.G. Sterbenz.	
#' Path diversification for future internet end-to-end resilience and survivability. 
#' Telecommun Syst (2014) 56:49?67. DOI 10.1007/s11235-013-9818-7
total.graph.diversity <- function(ig) {
	sp <- shortest.paths(ig)
	
	nodes <- V(ig)
	
	p <- apply(combn(names(nodes), 2), 2, 
		function(l, c) {
			names(shortest_paths(ig, l[1], l[2])$vpath[[1]])
		}
	)
	
	p
	
	# mapply(
	# 	function(i, all.paths) {
	# 		mapply(FUN = 
	# 			function(path, all.paths){
	# 				p
	# 			}, p[[i]], MoreArgs = list(all.paths = setdiff(p, p[[i]]))
	# 		)
	# 	}, as.list(1:length(nodes))
	# )
}




