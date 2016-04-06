#Palavras contidas nos artigos entre 2000 e 2001
MATCH (p:Paper)-[:CONTAINS]-(w:Word)
WHERE p.year >= 2000 AND p.year <= 2001
RETURN p
