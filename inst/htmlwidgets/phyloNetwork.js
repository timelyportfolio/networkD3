HTMLWidgets.widget({

  name: "phyloNetwork",
  type: "output",

  initialize: function(el, width, height) {

    return { phylo:null } ;

  },

  resize: function(el, width, height, phylo) {

  },

  renderValue: function(el, x, phylo) {
    // x is a list with two elements, options and newick
    
    // prepare newick with newick.js
    var newick = Newick.parse( x.newick )
    var newickNodes = []
        function buildNewickNodes(node, callback) {
            newickNodes.push(node)
            if (node.branchset) {
                for (var i = 0; i < node.branchset.length; i++) {
                    buildNewickNodes(node.branchset[i])
                }
            }
        }
    buildNewickNodes(newick)

    // build the phylogram
    d3.phylonator.build('#' + el.id, newick, {
        width: 800,
        height: 600,
        skipTicks: true
    });

  },
});
