library(treemap)
library(d3treeR)
library(networkD3)


# example 1 from ?treemap
data(GNI2010)
tm <- treemap(
  GNI2010
  ,index=c("continent"),#, "iso3")
  ,vSize="population"
  ,vColor="GNI"
  ,type="value"
)

tm$tm$y_size <- tm$tm$w * 100
tm$tm$x_size <- tm$tm$h * 100
tm_d3 <- d3treeR:::convert_treemap(tm$tm,rootname="world")
tm_d3$x_size <- 100
tm_d3$y_size <- 100

flexNetwork(tm_d3,spacing = htmlwidgets::JS("function(a,b){return 1}"))


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




library(data.tree)

# Create URL. paste0 used purely to keep within line width.
URL <- paste0("https://cdn.rawgit.com/christophergandrud/networkD3/",
              "master/JSONdata//flare.json")

## Convert to list format
flare <- jsonlite::fromJSON(URL, simplifyDataFrame = FALSE)
flare_node <- as.Node(flare, explicit = TRUE)
flare_node$Do(
  function(x) x$size <- Aggregate(x,"size",sum,cacheAttribute="size"),
  traversal="post-order"
)
flare_df <- ToDataFrameTable(flare_node,"name","pathString","size")


flare_tm <- treemap(
  data.frame(
    dplyr::rbind_all(
      lapply(
        strsplit(
          gsub(
            x = flare_df$pathString,
            pattern = "children2/",
            replacement = ""
          ),
          "/"
        ),
        function(x)data.frame(t(unlist(x)))
      )
    ),
    flare_df
  ),
  index=c("X1","X2","X3"),
  vSize="size"
)

flare_tm$tm$y_size <- flare_tm$tm$w
flare_tm$tm$x_size <- flare_tm$tm$h
flare_tm_d3 <- d3treeR:::convert_treemap(flare_tm$tm,rootname="flare")
flare_tm_d3$x_size <- 1
flare_tm_d3$y_size <- 1

flexNetwork(
  flare_tm_d3$children[[1]],
  spacing = htmlwidgets::JS("function(a,b){return 0}")
)
