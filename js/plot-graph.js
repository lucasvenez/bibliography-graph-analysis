/**
 * http://usejsdoc.org/
 */
console.log("Start rendering");
var fs = require('fs');
var v = JSON.parse(fs.readFileSync('./js/1996.js', 'utf8'));

var createGraph = require('ngraph.graph');

var graph = createGraph({
	uniqueLinkIds : false
});

var lastNode = "";

for (var i = 0; i < v.length; i++) {

	if (v[i].src != lastNode) {
		graph.addNode(v[i].src);
		lastNode = v[i].src;
	}

	if (!graph.hasLink(v[i].src, v[i].dst))
		graph.addLink(v[i].src, v[i].dst, "followedby");
}

var createLayout = require('ngraph.offline.layout');

var layout = createLayout(graph, {
	outDir : './output'
});
try {
	layout.run();
} catch (e) {
	console.log(e);
}

var save = require('ngraph.tobinary');

save(graph, {
	outDir : './output'
})

console.log("Rendering finished");