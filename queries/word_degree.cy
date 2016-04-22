# Grau de cada palavra
MATCH (w:Word)--()
RETURN w.value, count(*) as degree 
ORDER BY degree DESC 
LIMIT 10
