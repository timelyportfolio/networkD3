library(treemap)
library(d3treeR)
library(networkD3)


# example 1 from ?treemap
data(GNI2010)
tm <- treemap(
  GNI2010
  ,index=c("continent")#, "iso3")
  ,vSize="population"
  ,vColor="GNI"
  ,type="value"
)

tm$tm$x_size <- tm$tm$w * 100
tm$tm$y_size <- tm$tm$h * 100
tm_d3 <- d3treeR:::convert_treemap(tm$tm)
tm_d3$x_size <- 100
tm_d3$y_size <- 100

flexNetwork(tm_d3)



library(jsonlite)
test01 <- fromJSON(
  "https://rawgit.com/Klortho/d3-flextree/master/test/cases/tree-a.json",
  simplifyDataFrame = FALSE
)
flexNetwork(test01, spacing = htmlwidgets::JS("function(a,b){return 0;}"))

flexNetwork(
  test01,
  spacing = htmlwidgets::JS("
function(a, b) {
  return a.parent == b.parent ? 0 : tree.rootXSize();
}")
)

test11 <- fromJSON(
  "https://rawgit.com/Klortho/d3-flextree/master/test/cases/tree-j.json",
  simplifyDataFrame = FALSE
)
flexNetwork(test11)