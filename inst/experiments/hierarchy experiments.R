devtools::install_github("timelyportfolio/networkD3@feature/d3.chart.layout")

library(networkD3)
library(pipeR)
library(htmltools)

hc <- hclust(dist(USArrests), "ave")
flare <- RJSONIO::fromJSON("JSONdata/flare.json")

tagList(
  lapply(
    c("tree.cartesian"
      ,"tree.radial"
      ,"cluster.cartesian"
      ,"cluster.radial"
    )
    ,function(chartType){
      hierNetwork( as.treeNetwork(hc), type = chartType, zoomable = T, collapsible = T )
    }
  ),
  lapply(
    c("pack.nested"
      ,"pack.flattened"
      ,"partition.arc"
      ,"partition.rectangle"
      ,"treemap"
    )
    ,function(chartType){
      hierNetwork( flare, type = chartType, value = "size", zoomable = T, collapsible = T)
    }
  )
) %>>% html_print

# -----------------------------------------
#To Do:
#  
#  1. add in all the options
#  2. margin and sizing
#  3. labels for sunburst / partition.arc
