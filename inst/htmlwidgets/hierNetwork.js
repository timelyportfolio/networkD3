HTMLWidgets.widget({

  name: "hierNetwork",
  type: "output",

  initialize: function(el, width, height) {

    var diameter = Math.min(parseInt(width),parseInt(height));
    svg = d3.select(el).append("svg")
      .attr("width", width)
      .attr("height", height)
      .append("g")
      .attr("transform", "translate(" + diameter / 2 + "," + diameter / 2 + ")"
                         + " scale("+diameter/800+","+diameter/800+")");
    return {};

  },

  resize: function(el, width, height, tree) {
    /*
    var diameter = Math.min(parseInt(width),parseInt(height));
    var s = d3.select(el).selectAll("svg");
    s.attr("width", width).attr("height", height);
    tree.size([360, diameter/2 - parseInt(s.attr("margin"))]);
    var svg = d3.select(el).selectAll("svg").select("g");
    svg.attr("transform", "translate(" + diameter / 2 + "," + diameter / 2 + ")"
                         + " scale("+diameter/800+","+diameter/800+")");
   */

  },

  renderValue: function(el, x, tree) {
    // x is a list with two elements, options and root; root must already be a
    // JSON array with the d3Tree root data
    
    // add type of chart without period as class for styling
    d3.select(el).classed(x.options.type.replace(/\./g, ""),true);
    
    var svg = d3.select(el).selectAll("svg");
    tree.chart = svg.chart( x.options.type )
            .value( x.options.value )
            //.margin({ top: 0, right: 180, bottom: 0, left: 40 })
            //.radius(radius)
    if( typeof x.options.zoomable !== "undefined" && x.options.zoomable && tree.chart.zoomable )
        tree.chart.zoomable([0.1, 5]);
        
    if( typeof x.options.collapsible !== "undefined" && x.options.collapsible && tree.chart.collapsible )
        tree.chart.collapsible()
        
            //.duration(200);
    
    tree.chart.draw( JSON.parse( x.root ) );

  },
});
