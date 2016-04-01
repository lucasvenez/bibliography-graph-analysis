from py2neo import authenticate, Graph

class GraphDatabase:

   def __init__(self, host = "localhost", port = 7474, user = "neo4j", 
                 password = "neo4j", database = "data"):
        
      authenticate(host + ":" + `port`, user, password)
      
      self.__graph = Graph()
   
   def query(self, cypher):
      
      try:
         print cypher
         self.__tx = self.__graph.cypher.begin()
         self.__tx.append(cypher)
         self.__tx.commit()
      except Exception, exp: 
         print str(exp)