#Algumas consultas para quantificar a rede.

#Numero de artigos analisados (Total)
MATCH (p:Paper) 
RETURN count(p) as numberOfPapers

#Numero de artigos per periodo de tempo
MATCH (p:Paper)
WHERE p.year > 1986 AND p.year <= 1995
RETURN count(p) as numberOfPapers

#Quantas palavras por artigo
MATCH (p:Paper)-[:CONTAINS]-(w:Word)
WHERE p.year = 2016 
RETURN p.title, count(w) as numberOfWordsPerPaper


