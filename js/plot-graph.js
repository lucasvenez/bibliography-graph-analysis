/**
 * http://usejsdoc.org/
 */
console.log("Start rendering");

var v = require("./1996");

var createGraph = require('ngraph.graph');

var graph = createGraph();

for (var i = 0; i < v.length; i++)
	graph.addLink(v[i].src, v[i].dst);

var createLayout = require('ngraph.offline.layout');

var layout = createLayout(graph, {
	outDir : './images'
});

layout.run();

var save = require('ngraph.tobinary');

save(graph, {
	outDir: './images'
})

console.log("Rendering finished");