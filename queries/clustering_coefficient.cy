#
# Qual o valor de n para calcular o Coeficiente de Agrupamento (Cluster Coefficient)?
# C_i = n!/(2!(n-2)!)
# Cluster Coefficient = \frac{1}{n} \sum_{i=1}^n C_i
# Warning: essa operação é muito lenta.
#
MATCH (w:Word)--(m)
WITH w, COUNT(DISTINCT m) AS n
MATCH (w)--()-[r]-()--(w)
RETURN n, COUNT(DISTINCT r) AS r