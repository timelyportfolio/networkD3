/*
  d3.phylonator.js by Tim Thimmaiah (https://github.com/tim-thimmaiah)
  
  Modified from d3.phylogram.js by Ken-Ichi (https://github.com/kueda)
  
  Copyright (c) Tim Thimmaiah 2013.
  
  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:
   
  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.
  	
*/

if (!d3) { throw "d3 wasn't included!"};
(function() {
  d3.phylonator = {}
  d3.phylonator.rightAngleDiagonal = function() {
    var projection = function(d) { return [d.y, d.x]; }
    
    var path = function(pathData) {
      return "M" + pathData[0] + ' ' + pathData[1] + " " + pathData[2];
    }
    
    function diagonal(diagonalPath, i) {
      var source = diagonalPath.source,
          target = diagonalPath.target,
          midpointX = (source.x + target.x) / 2,
          midpointY = (source.y + target.y) / 2,
          pathData = [source, {x: target.x, y: source.y}, target];
      pathData = pathData.map(projection);
      return path(pathData)
    }
    
    diagonal.projection = function(x) {
      if (!arguments.length) return projection;
      projection = x;
      return diagonal;
    };
    
    diagonal.path = function(x) {
      if (!arguments.length) return path;
      path = x;
      return diagonal;
    };
    
    return diagonal;
  }
  
  d3.phylonator.radialRightAngleDiagonal = function() {
    return d3.phylonator.rightAngleDiagonal()
      .path(function(pathData) {
        var src = pathData[0],
            mid = pathData[1],
            dst = pathData[2],
            radius = Math.sqrt(src[0]*src[0] + src[1]*src[1]),
            srcAngle = d3.phylonator.coordinateToAngle(src, radius),
            midAngle = d3.phylonator.coordinateToAngle(mid, radius),
            clockwise = Math.abs(midAngle - srcAngle) > Math.PI ? midAngle <= srcAngle : midAngle > srcAngle,
            rotation = 0,
            largeArc = 0,
            sweep = clockwise ? 0 : 1;
        return 'M' + src + ' ' +
          "A" + [radius,radius] + ' ' + rotation + ' ' + largeArc+','+sweep + ' ' + mid +
          'L' + dst;
      })
      .projection(function(d) {
        var r = d.y, a = (d.x - 90) / 180 * Math.PI;
        return [r * Math.cos(a), r * Math.sin(a)];
      })
  }
  
  // Convert XY and radius to angle of a circle centered at 0,0
  d3.phylonator.coordinateToAngle = function(coord, radius) {
    var wholeAngle = 2 * Math.PI,
        quarterAngle = wholeAngle / 4
    
    var coordQuad = coord[0] >= 0 ? (coord[1] >= 0 ? 1 : 2) : (coord[1] >= 0 ? 4 : 3),
        coordBaseAngle = Math.abs(Math.asin(coord[1] / radius))
    
    // Since this is just based on the angle of the right triangle formed
    // by the coordinate and the origin, each quad will have different 
    // offsets
    switch (coordQuad) {
      case 1:
        coordAngle = quarterAngle - coordBaseAngle
        break
      case 2:
        coordAngle = quarterAngle + coordBaseAngle
        break
      case 3:
        coordAngle = 2*quarterAngle + quarterAngle - coordBaseAngle
        break
      case 4:
        coordAngle = 3*quarterAngle + coordBaseAngle
    }
    return coordAngle
  }
  
  d3.phylonator.styleTreeNodes = function(vis, nodes) {
      
   var nodeMouseOver = function() {
	   var circle = d3.select(this);
	   circle.attr("fill", "steelblue");
	   circle.attr("r", 3.5);
   }
   
   var nodeMouseOut = function() {
	   var circle = d3.select(this);
	   circle.attr("fill", "white");
	   circle.attr("r", 2.5);
   }
   
   function highlight(x, y, a) {
	   var pointy = y;
	   var pointx = x;
   		vis.selectAll("path.link")
			.attr("y2", function(d) {
				if(d.target.y == pointy && d.target.x == pointx) {
					var path = d3.select(this);
					path.attr("stroke", "rgba(255,0,0,"+a+")");
					pointy = d.source.y;
					pointx = d.source.x;
					a = a-0.1;
					if (pointy!=0) {
    					highlight(pointx, pointy,a);
					}
				}
			});
	}
	   
      
    vis.selectAll('g.leaf.node')
      .append("svg:circle")
        .attr("r", 2.5)
        .attr("class", function(d) {return d.type})
        .attr('stroke',  'steelBlue')
        .attr('fill', 'white')
        .attr('stroke-width', '1.5px')
        .on("mouseout", function(d) {
	        var circle = d3.select(this);
		   circle.attr("fill", "white");
		   circle.attr("r", 2.5);
        })
        .on("mouseover", function(d) {
	        var circle = d3.select(this);
	        circle.attr("fill", "steelblue");
	        circle.attr("r", 3.5);
	       var pointy = d.y;
		   var pointx = d.x;
		   var a = 1;
		   highlight(pointx, pointy, a);
        })
        .on("click", function(d) {
        	var circle = d3.select(this);
	        circle.attr("fill", "steelblue");
	        circle.attr("r", 3.5);
	       var pointy = d.y;
		   var pointx = d.x;
		   var a = 1;
		   highlight(pointx, pointy, a);
        });
        	    
    vis.selectAll('g.root.node')
      .append('svg:circle')
        .attr("r", 4.5)
        .attr('fill', 'steelblue')
        .attr('stroke', '#369')
        .attr('stroke-width', '1.5px');
  }
  
  function scaleBranchLengths(nodes, w) {
    // Visit all nodes and adjust y pos width distance metric
    var visitPreOrder = function(root, callback) {
      callback(root)
      if (root.children) {
        for (var i = root.children.length - 1; i >= 0; i--){
          visitPreOrder(root.children[i], callback)
        };
      }
    }
    visitPreOrder(nodes[0], function(node) {
      node.rootDist = (node.parent ? node.parent.rootDist : 0) + (node.data.length || 0)
    })
    var rootDists = nodes.map(function(n) { return n.rootDist; });
    var yscale = d3.scale.linear()
      .domain([0, d3.max(rootDists)])
      .range([0, w]);
    visitPreOrder(nodes[0], function(node) {
      node.y = yscale(node.rootDist)
    })
    return yscale
  }
  
  
  d3.phylonator.build = function(selector, nodes, options) {
    options = options || {}
    var w = options.width || d3.select(selector).style('width') || d3.select(selector).attr('width'),
        h = options.height || d3.select(selector).style('height') || d3.select(selector).attr('height'),
        w = parseInt(w),
        h = parseInt(h),
        x = d3.scale.linear().domain([0, w]).range([0, w]),
        y = d3.scale.linear().domain([0, h]).range([0, h]);
        
    var tree = options.tree || d3.layout.cluster()
      .size([h, w])
      /* .sort(function(node) { return node.children ? node.children.length : -1; }) */ //Sorting Nodes (Optional)
      .children(options.children || function(node) {
        return node.branchset
      });
    var diagonal = options.diagonal || d3.phylonator.rightAngleDiagonal();
    var vis = options.vis || d3.select(selector).append("svg:svg")
        .attr("width", w + 300)
        .attr("height", h + 30)
        .attr('pointer-events', 'all')
        .append('svg:g')
        .call(d3.behavior.zoom().scaleExtent([1,5]).on("zoom", redraw)) //Zooming
        .append("svg:g")
        .attr("transform", "translate(0, 0)")
        .attr("id", "phylonator_svg") //Reference
    var nodes = tree(nodes);
	
	
	vis.append('svg:rect') //For Panning
		    .attr('width', w)
		    .attr('height', h)
		    .attr('fill', 'white');
	    
    function redraw() {
	  vis.attr("transform",
	      "translate(" + (d3.event.translate) + ")"
	      + " scale(" + d3.event.scale + ")");
      }

    
    if (options.skipBranchLengthScaling) {
      var yscale = d3.scale.linear()
        .domain([0, w])
        .range([0, w]);
    } else {
      var yscale = scaleBranchLengths(nodes, w)
    }
    
    
if (!options.skipTicks) {
      vis.selectAll('line')
          .data(yscale.ticks(10))
        .enter().append('svg:line')
          .attr('y1', 0)
          .attr('y2', h)
          .attr('x1', yscale)
          .attr('x2', yscale)
          .attr("stroke", "#ddd");

      vis.selectAll("text.rule")
          .data(yscale.ticks(10))
        .enter().append("svg:text")
          .attr("class", "rule")
          .attr("x", yscale)
          .attr("y", 0)
          .attr("dy", -3)
          .attr("text-anchor", "middle")
          .attr('font-size', '8px')
          .attr('fill', '#ccc')
          .text(function(d) { return Math.round(d*100) / 100; });
    }

        
    var link = vis.selectAll("path.link")
        .data(tree.links(nodes))
      .enter().append("svg:path")
        .attr("class", "link")
        .attr("d", diagonal)
        .attr("fill", "none")
        .attr("stroke", "#aaa")
        .attr("stroke-width", "1.5px")
        .attr("x1", function(d) { return d.source.x; })
      .attr("y1", function(d) { return d.source.y; })
      .attr("x2", function(d) { return d.target.x; })
      .attr("y2", function(d) { return d.target.y; });
        
    var node = vis.selectAll("g.node")
        .data(nodes)
      .enter().append("svg:g")
        .attr("class", function(n) {
          if (n.children) {
            if (n.depth == 0) {
              return "root node"
            } else {
              return "inner node"
            }
          } else {
            return "leaf node"
          }
        })
        .attr("transform", function(d) { return "translate(" + d.y + "," + d.x + ")"; });
        
    
    var baseNode = vis.selectAll("g.leaf.node")
    	.on("click", function(d) {
    		d3.selectAll("."+d.type).style("fill", "red");
    	});  
        
    var linkedByIndex = {};
    
    tree.links(nodes).forEach(function(d) {
        linkedByIndex[d.source.index + "," + d.target.index] = 1;
    });

    function isConnected(a, b) {
        return linkedByIndex[a.index + "," + b.index] || linkedByIndex[b.index + "," + a.index] || a.index == b.index;
    }
    
    function fade(opacity) {
        return function(d) {
            node.style("stroke-opacity", function(o) {
                thisOpacity = isConnected(d, o) ? 1 : opacity;
                this.setAttribute('fill-opacity', thisOpacity);
                return thisOpacity;
            });

            link.style("stroke-opacity", function(o) {
                return o.source === d || o.target === d ? 1 : opacity;
            });
        };
    }
  //Tooltips by Tipsy

  $('g.node').tipsy({ 
        gravity: 'w', 
        html: true, 
        title: function() {
          var d = this.__data__;
          return d.data.name; 
        }
      });
  
    d3.phylonator.styleTreeNodes(vis, nodes)

    if (!options.skipLabels) {
    
      vis.selectAll('g.leaf.node').append("svg:text")
        .attr("dx", 8)
        .attr("dy", 3)
        .attr("text-anchor", "start")
        .attr('font-family', 'Helvetica Neue, Helvetica, sans-serif')
        .attr('font-size', '10px')
        .attr('fill', 'black')
        .attr("pointer-events", "all")
        .text(function(d) { return d.data.name + ' ('+d.data.length+')'; });
        
    }
    
    return {tree: tree, vis: vis}
  }

}());
