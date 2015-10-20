# instead of building, try to adapt d3heatmap for this purpose

#devtools::install_github("timelyportfolio/networkD3@feature/adjacency")
#devtools::install_github("rstudio/d3heatmap")

library(networkD3)
library(d3heatmap)
library(igraph)

data(karate, package="igraphdata")
karate <- upgrade_graph(karate)

d3heatmap(
  get.adjacency(karate,sparse=FALSE),
  colors = "Blues",
  dendrogram="none"
)

d3heatmap(
  get.adjacency(karate,sparse=FALSE,attr="weight"),
  colors = "Blues",
  dendrogram="none"
)

Cl <- cor(longley)
d3heatmap(
  Cl,
  # play with colors to remember how
  colors = col_numeric("RdBu",c(-.2,1)),
  dendrogram="none"
)
