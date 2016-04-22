# Nesse exemplo a palavra excluída é a "other"
MATCH (w:Word)
WHERE w.value = "other"
DETACH DELETE w