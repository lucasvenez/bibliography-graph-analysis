#
# Quais são as palavras com o maior número de aparições em artigos distintos?
#
MATCH (p:Paper)-[:CONTAINS]-(w:Word) 
RETURN w.value, COUNT(p) AS numberOfAppearances
ORDER BY numberOfAppearances DESC LIMIT 10