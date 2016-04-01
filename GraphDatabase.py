from py2neo import authenticate, Graph

class GraphDatabase:

   def __init__(self, host = "localhost", port = 7474, user = "neo4j", 
                 password = "neo4j", database = "data"):
        
      authenticate(host + ":" + `port`, user, password)
      
      self.__graph = Graph()
   
   def startTransaction(self):
      self.__tx = self.__graph.cypher.begin()
   
   def query(self, cypher):
      self.__tx.append(cypher)
      
   def commit(self):
      self.__tx.commit()
      
   def rollback(self):
      self.__tx.roolback()
      