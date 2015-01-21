library(networkD3)

phyloNetwork("((A7RLM8:0.6571,(B3SBJ1:0.60468,B3SB47:1.39873):0.32942):0.0564,(C3YZV6:0.63868,(B7PB18:1.48452,((Q9I9H8:0.00775,A5WVJ8:0.00101):0.44669,(Q6GNU6:0.41674,((E1BR73:0.00015,E1BS49:0.00017):0.26544,((D2HE46:0.04922,(O14727:0.00017,A7E2A2:0.00089):0.05297):0.02176,((O88879:0.0026,(A2RRK8:0.00015,Q5DU30:0.00088):0.00017):0.02035,(Q8VI66:0.00344,(D3ZA56:0.09057,Q9EPV5:0.00017):0.00098):0.02368):0.0708):0.15795):0.09069):0.11555):0.43916):0.18436):0.11567):0")


library(htmltools)
html_print(tagList(
  tags$h1("phylogram")
  ,phyloNetwork("((A7RLM8:0.6571,(B3SBJ1:0.60468,B3SB47:1.39873):0.32942):0.0564,(C3YZV6:0.63868,(B7PB18:1.48452,((Q9I9H8:0.00775,A5WVJ8:0.00101):0.44669,(Q6GNU6:0.41674,((E1BR73:0.00015,E1BS49:0.00017):0.26544,((D2HE46:0.04922,(O14727:0.00017,A7E2A2:0.00089):0.05297):0.02176,((O88879:0.0026,(A2RRK8:0.00015,Q5DU30:0.00088):0.00017):0.02035,(Q8VI66:0.00344,(D3ZA56:0.09057,Q9EPV5:0.00017):0.00098):0.02368):0.0708):0.15795):0.09069):0.11555):0.43916):0.18436):0.11567):0")
  ,tags$h1("phylogram radial")
  ,phyloNetwork("((A7RLM8:0.6571,(B3SBJ1:0.60468,B3SB47:1.39873):0.32942):0.0564,(C3YZV6:0.63868,(B7PB18:1.48452,((Q9I9H8:0.00775,A5WVJ8:0.00101):0.44669,(Q6GNU6:0.41674,((E1BR73:0.00015,E1BS49:0.00017):0.26544,((D2HE46:0.04922,(O14727:0.00017,A7E2A2:0.00089):0.05297):0.02176,((O88879:0.0026,(A2RRK8:0.00015,Q5DU30:0.00088):0.00017):0.02035,(Q8VI66:0.00344,(D3ZA56:0.09057,Q9EPV5:0.00017):0.00098):0.02368):0.0708):0.15795):0.09069):0.11555):0.43916):0.18436):0.11567):0",type ="phylogram.radial")    
  ,tags$h1("phylonator")
  ,phyloNetwork("((A7RLM8:0.6571,(B3SBJ1:0.60468,B3SB47:1.39873):0.32942):0.0564,(C3YZV6:0.63868,(B7PB18:1.48452,((Q9I9H8:0.00775,A5WVJ8:0.00101):0.44669,(Q6GNU6:0.41674,((E1BR73:0.00015,E1BS49:0.00017):0.26544,((D2HE46:0.04922,(O14727:0.00017,A7E2A2:0.00089):0.05297):0.02176,((O88879:0.0026,(A2RRK8:0.00015,Q5DU30:0.00088):0.00017):0.02035,(Q8VI66:0.00344,(D3ZA56:0.09057,Q9EPV5:0.00017):0.00098):0.02368):0.0708):0.15795):0.09069):0.11555):0.43916):0.18436):0.11567):0",type ="phylonator")
  ,tags$h1("phylonator no scaling")
  ,phyloNetwork("((A7RLM8:0.6571,(B3SBJ1:0.60468,B3SB47:1.39873):0.32942):0.0564,(C3YZV6:0.63868,(B7PB18:1.48452,((Q9I9H8:0.00775,A5WVJ8:0.00101):0.44669,(Q6GNU6:0.41674,((E1BR73:0.00015,E1BS49:0.00017):0.26544,((D2HE46:0.04922,(O14727:0.00017,A7E2A2:0.00089):0.05297):0.02176,((O88879:0.0026,(A2RRK8:0.00015,Q5DU30:0.00088):0.00017):0.02035,(Q8VI66:0.00344,(D3ZA56:0.09057,Q9EPV5:0.00017):0.00098):0.02368):0.0708):0.15795):0.09069):0.11555):0.43916):0.18436):0.11567):0",type ="phylonator", skipBranchLengthScaling = T)  
  ,tags$h1("phylonator no scaling")
  ,phyloNetwork(
    "((A7RLM8:0.6571,(B3SBJ1:0.60468,B3SB47:1.39873):0.32942):0.0564,(C3YZV6:0.63868,(B7PB18:1.48452,((Q9I9H8:0.00775,A5WVJ8:0.00101):0.44669,(Q6GNU6:0.41674,((E1BR73:0.00015,E1BS49:0.00017):0.26544,((D2HE46:0.04922,(O14727:0.00017,A7E2A2:0.00089):0.05297):0.02176,((O88879:0.0026,(A2RRK8:0.00015,Q5DU30:0.00088):0.00017):0.02035,(Q8VI66:0.00344,(D3ZA56:0.09057,Q9EPV5:0.00017):0.00098):0.02368):0.0708):0.15795):0.09069):0.11555):0.43916):0.18436):0.11567):0"
    , type ="phylonator"
    , diagonal = htmlwidgets:::JS('d3.phylonator.radialRightAngleDiagonal()')
    , tree= htmlwidgets:::JS('
    d3.layout.tree()
      .size([360, 500])
      //.sort(function(node) { return node.children ? node.children.length : -1; })
      .children( function(node) {
        return node.branchset
      })
      .separation(function(a, b) { return (a.parent == b.parent ? 1 : 2) / a.depth })
    ')
    , skipBranchLengthScaling=T, skipTicks = T, skipLabel = T
  )  
)) -> ex

path = "C:\\Users\\KENT~1.TLE\\AppData\\Local\\Temp\\RtmpYpJMmH\\viewhtmle90541c701c"
gist_create(
  list.files(
    path
    ,recursive=T
    ,full.names= T
  )
  ,description = "phylogram options for networkD3"
)



# kind of a parent child json of dendrogram
jsonlite::toJSON(rapply(unclass(dend1),attributes,how="list"),auto_unbox=T)


http://stackoverflow.com/questions/11934862/d3-use-nest-function-to-turn-flat-data-with-parent-key-into-a-hierarchy
http://stackoverflow.com/questions/11088303/how-to-convert-to-d3s-json-format
http://stackoverflow.com/questions/15912966/d3-json-data-conversion/15914716#15914716 + underscore.nest
# ding ding ding I think to the answer below
http://stackoverflow.com/questions/17847131/generate-multilevel-flare-json-data-format-from-flat-json
# really like this one; add DataStructures from github?
http://stackoverflow.com/questions/27576807/d3-js-zoomable-sunburst-visualization-from-self-referencing-csv-input




# for transitions, i just had to reference this very nice example
http://stackoverflow.com/questions/20930401/smooth-transitioning-between-tree-cluster-radial-tree-and-radial-cluster-layo