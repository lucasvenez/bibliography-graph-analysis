/**
 * http://usejsdoc.org/
 */
console.log("Start rendering");
var fs = require('fs');
var v = JSON.parse(fs.readFileSync('./1996.js', 'utf8'));

var createGraph = require('ngraph.graph');

var graph = createGraph({uniqueLinkIds: false});

var lastNode = "";

for (var i = 0; i < v.length; i++) {

	if (v[i].src != lastNode) {
		graph.addNode(v[i].src);
		lastNode = v[i].src;
	}
	
	if (!graph.hasLink(v[i].src, v[i].dst))
        graph.addLink(v[i].src, v[i].dst);
}

var createLayout = require('ngraph.offline.layout');

var layout = createLayout(graph, {
	outDir : './images',
	layout: 'ngraph.forcelayout'
});
try {
layout.run();
} catch(e) {
	console.log(e);
}

var save = require('ngraph.tobinary');

save(graph, {
	outDir: './images'
})

console.log("Rendering finished");