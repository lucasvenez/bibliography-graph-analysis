# Nesse exemplo a palavra exclu�da � a "other"
MATCH (w:Word)
WHERE w.value = "other"
DETACH DELETE w