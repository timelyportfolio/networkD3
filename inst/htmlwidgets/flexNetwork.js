HTMLWidgets.widget({

  name: "flexNetwork",
  type: "output",

  initialize: function(el, width, height) {
    el.style.overflow = "scroll";
    
    d3.select(el).append("svg")
      //.style("width", "100%")
      //.style("height", "100%")
      .append("g")
      .attr("transform", "translate(40,0)");
    return d3.layout.flextree()
             .setNodeSizes(true);

  },

  resize: function(el, width, height, tree) {
   
  },

  renderValue: function(el, x, tree) {
    // x is a list with two elements, options and root; root must already be a
    // JSON array with the d3Tree root data

    var s = d3.select(el).selectAll("svg");
    
    // margin handling
    //   set our default margin to be 20
    //   will override with x.options.margin if provided
    var margin = {top: 20, right: 20, bottom: 20, left: 20};
    //   go through each key of x.options.margin
    //   use this value if provided from the R side
    Object.keys(x.options.margin).map(function(ky){
      if(x.options.margin[ky] !== null) {
        margin[ky] = x.options.margin[ky];
      }
      // set the margin on the svg with css style
      // commenting this out since not correct
      // s.style(["margin",ky].join("-"), margin[ky]);
    });
      
    
    width = s.node().getBoundingClientRect().width - margin.right - margin.left;
    height = s.node().getBoundingClientRect().height - margin.top - margin.bottom;
    
    //tree.size([height, width])
    if(x.options.spacing){
      tree.spacing(x.options.spacing);
    }
    
    if(x.options.separation){
      tree.separation(x.options.separation);
    }
      
    tree.nodeSize(function(d){
      return [d.x_size,d.y_size];
    });

    // select the svg group element and remove existing children
    s.attr("pointer-events", "all").selectAll("*").remove();
    s.append("g")
      //.attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    var svg = d3.select(el).select("g");
    

    var root = x.root;    
    
    // draw nodes
    var last_id = 0;

    var nodes = d3.layout.hierarchy()(root);
    var node = svg.selectAll(".node")
        .data(nodes, function(d) { 
          return d.id || (d.id = ++last_id); 
        })
      .enter().append("g")
        .attr("class", "node")
    ;
    
    var nodes = tree.nodes(root),
      links = tree.links(nodes);
      
    // Get the extents, average node area, etc.
    function node_extents(n) {
      return [n.x - n.x_size/2, n.y,
              n.x + n.x_size/2, n.y + n.y_size];
    }
    var root_extents = node_extents(nodes[0]);
    var xmin = root_extents[0],
        ymin = root_extents[1],
        xmax = root_extents[2],
        ymax = root_extents[3],
        area_sum = (xmax - xmin) * (ymax - ymin),
        x_size_min = nodes[0].x_size,
        y_size_min = nodes[0].y_size;

    nodes.slice(1).forEach(function(n) {
      var ne = node_extents(n);
      xmin = Math.min(xmin, ne[0]);
      ymin = Math.min(ymin, ne[1]);
      xmax = Math.max(xmax, ne[2]);
      ymax = Math.max(ymax, ne[3]);
      area_sum += (ne[2] - ne[0]) * (ne[3] - ne[1]);
      x_size_min = Math.min(x_size_min, n.x_size);
      y_size_min = Math.min(y_size_min, n.y_size);
    });
    var area_ave = area_sum / nodes.length;
    // scale such that the average node size is 400 px^2
    console.log("area_ave = " + area_ave);
    var scale = 80 / Math.sqrt(area_ave);
    console.log("extents = %o", {
      xmin: xmin, ymin: ymin, xmax: xmax, ymax: ymax,
    });
    console.log("scale = " + scale);

    // Functions to get the derived svg coordinates given the tree node
    // coordinates.
    // Note that the x-y orientations between the svg and the tree drawing 
    // are reversed.

    function svg_x(node_y) { return (node_y - ymin) * scale; }
    function svg_y(node_x) { return (node_x - xmin) * scale; }


    // FIXME: need to implement these -- the max value should not
    // be scaled.

    // The node box is drawn smaller than the actual node width, to
    // allow room for the diagonal. Note that these are in units of
    // svg drawing coordinates (not tree node coordinates)
    var nodebox_right_margin = Math.min(x_size_min * scale, 10);
    // And smaller than the actual node height, for spacing
    var nodebox_vertical_margin = Math.min(y_size_min * scale, 3);


    // This controls the lines between the nodes; see
    // https://github.com/mbostock/d3/wiki/SVG-Shapes#diagonal_projection
    var diagonal = d3.svg.diagonal()
      .source(function(d, i) {
        var s = d.source;
        return {
          x: s.x, 
          y: s.y + s.y_size - nodebox_right_margin/scale,
        };
      })
      .projection(function(d) { 
        return [svg_x(d.y), svg_y(d.x)]; 
      })
    ;

    // draw links
    var link = svg.selectAll(".link")
      .data(links)
      .enter().append("path")
      .style("fill", "none")
      .style("stroke", "#ccc")
      .style("opacity", "0.55")
      .style("stroke-width", "1.5px")
      .attr("d", diagonal);


      function rand() {
        return 80 + Math.floor(Math.random() * 100);
      }
      var filler = function() {
              return "fill: rgb(" + rand() + "," + rand() + "," + rand() + ")";
            };
  
      // Reposition everything according to the layout
      node.attr("transform", function(d) { 
          return "translate(" + svg_x(d.y) + "," + svg_y(d.x) + ")"; 
        })
        .append("rect")
          .attr("data-id", function(d) {
            return d.id;
          })
          .attr({
            x: 0,
            y: function(d) { 
              return -(d.x_size * scale - nodebox_vertical_margin) / 2; 
            },
            rx: 6,
            ry: 6,
            width: function(d) { 
              return d.y_size * scale - nodebox_right_margin;
            },
            height: function(d) { 
              return d.x_size * scale - nodebox_vertical_margin; 
            },
            style: filler,
          })
      ;
    // node text
    node.append("text")
        .attr("dx", function(d) { return d.children ? -8 : 8; })
        .attr("dy", ".31em")
        .attr("text-anchor", function(d) { 
          return d.children || d._children ? "end" : "start";
        })
        .style("font", x.options.fontSize + "px " + x.options.fontFamily)
        .style("opacity", x.options.opacity)
        .style("fill", x.options.textColour)
        .text(function(d) { return d.name; });
        
    // adjust viewBox to fit the bounds of our tree
    s.attr(
        "viewBox",
        [
          d3.min(
            s.selectAll('.node text')[0].map(function(d){
              return d.getBoundingClientRect().left
            })
          ) - s.node().getBoundingClientRect().left - margin.right,
          d3.min(
            s.selectAll('.node text')[0].map(function(d){
              return d.getBoundingClientRect().top
            })
          ) - s.node().getBoundingClientRect().top - margin.top,
          d3.max(
            s.selectAll('.node text')[0].map(function(d){
              return d.getBoundingClientRect().right
            })
          ) -
          d3.min(
            s.selectAll('.node text')[0].map(function(d){
              return d.getBoundingClientRect().left
            })
          ) + margin.left + margin.right,
          d3.max(
            s.selectAll('.node text')[0].map(function(d){
              return d.getBoundingClientRect().bottom
            })
          ) -
          d3.min(
            s.selectAll('.node text')[0].map(function(d){
              return d.getBoundingClientRect().top
            })
          ) + margin.top + margin.bottom
        ].join(",")
      );
      
     s.attr({
        width: (ymax - ymin) * scale,
        height: (xmax - xmin) * scale,
      });

    // mouseover event handler
    function mouseover() {
      d3.select(this).select("circle").transition()
        .duration(750)
        .attr("r", 9);
        
      d3.select(this).select("text").transition()
        .duration(750)
        .style("stroke-width", ".5px")
        .style("font", "25px " + x.options.fontFamily)
        .style("opacity", 1);
    }

    // mouseout event handler
    function mouseout() {
      d3.select(this).select("circle").transition()
        .duration(750)
        .attr("r", 4.5);
        
      d3.select(this).select("text").transition()
        .duration(750)
        .style("font", x.options.fontSize + "px " + x.options.fontFamily)
        .style("opacity", x.options.opacity);
    }

  },
});
