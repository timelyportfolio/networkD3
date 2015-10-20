# instead of building, try to adapt d3heatmap for this purpose

#devtools::install_github("timelyportfolio/networkD3@feature/adjacency")
#devtools::install_github("rstudio/d3heatmap")

library(networkD3)
library(d3heatmap)
library(igraph)
library(scales)

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

d3heatmap(
  Cl,
  # play with cellnote to remember how
  cellnote = matrix(percent(Cl),nrow=nrow(Cl)),
  colors = col_bin("BuPu",c(-1,1),bins=10),
  dendrogram="none",
  cexRow = 0.5,
  cexCol = 0.5,
  height = 400, width = 400
)


# adjacency network with 2015 NCAA football data
#   https://github.com/octonion/football

library(dplyr)
library(igraph)
library(pipeR)

# get game data
"https://cdn.rawgit.com/octonion/football/master/ncaa/tsv/ncaa_games_2016.tsv" %>>%
  read.delim(stringsAsFactors = FALSE) %>>%
  mutate( opponent_name = gsub(x=opponent_name,pattern = "(%\\n)[\\s]{2,}", replacement = "", perl =T ) )-> games

# get school meta data
"https://cdn.rawgit.com/octonion/football/master/ncaa/tsv/ncaa_schools_2016.tsv" %>>%
  read.delim(stringsAsFactors = FALSE) -> schools

# join schools and games to only get division 1 games
games %>>%
  inner_join( schools ) %>>%
  filter( division_id == 11 ) %>>%
  inner_join( schools, c( "opponent_id" = "school_id" )) %>>%
  filter( division_id.y == 11) %>>%
  (
    list(
      nodes = rbind(
        select(., id = school_id, name = school_name.x),
        select(
          .,
          id = opponent_id,
          name = opponent_name
        )
      ) %>>% unique,
      edges = select(
        .,
        source = school_id,
        target = opponent_id,
        game_date
      )
    )
  ) -> game_network

graph_from_data_frame(
  game_network$edges,
  vertices = game_network$nodes,
  directed = FALSE
) %>>%
  get.adjacency(sparse = FALSE) %>>%
  d3heatmap(col = "Blues")

# try to get colors by date
graph_from_data_frame(
  game_network$edges %>>%
    mutate( game_date = as.Date(game_date,format="%m/%d/%Y")),
  vertices = game_network$nodes,
  directed = FALSE
) %>>%
  get.adjacency(sparse = FALSE, attr="game_date") %>>%
  (
    d3heatmap(
      x = .,
      cellnote = as.Date(.,origin="1970-01-01"),
      colors = "Blues"
    )
  )