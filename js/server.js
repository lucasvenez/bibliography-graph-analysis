const http = require('http');
var neo4j = require("neo4j")

const hostname = '127.0.0.1';
const port = 3000;

const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'json/plain');
  res.setHeader('Content-Disposition', 'inline; filename="myfile.json"')
  
  var db = new neo4j.GraphDatabase('http://neo4j:password@localhost:7474');
  var r;
  
  db.cypher('MATCH (src:Word)-->(dst:Word) WHERE src <> dst RETURN src.value AS src, dst.value AS dst', 
		  function(err, result) {res.end(r = JSON.stringify(result, null, 3));});
  
  console.log(r);
});

server.listen(port, hostname, () => {
  console.log(`Server running at http:// ${hostname}:${port}/`);
});