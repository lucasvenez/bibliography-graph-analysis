#Grau de cada palavra
MATCH (w:Word)--()
RETURN w, count(*) as degree 
ORDER BY degree DESC 
LIMIT 100
