#
# Quais são os dez autores com o maior número de publicações?
#
MATCH (a:Author)-[:WRITE]-(p:Paper) 
RETURN a.name, COUNT(p) AS numberOfPapers 
ORDER BY numberOfPapers, a.name DESC LIMIT 10