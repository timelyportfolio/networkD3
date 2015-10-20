library(networkD3)

# using Miserables data draw adjacency matrix
adjacencyNetwork(
  Links = MisLinks, Nodes = MisNodes,
  Source = "source", Target = "target",
  NodeID = "name", Group = "group"
)

library(igraph)
data(karate, package = "igraphdata")
karate <- upgrade_graph(karate)

karate_df <- get.data.frame(karate, what = "both")
karate_df$edges$from <- match(karate_df$edges$from,karate_df$vertices$name) - 1
karate_df$edges$to <- match(karate_df$edges$to,karate_df$vertices$name) - 1
adjacencyNetwork(
  Links = karate_df$edges,
  Nodes = karate_df$vertices[,c(2,1)],
  Source = "from",
  Target = "to",
  NodeID = "name",
  Group = "Faction",
  margin = list(left=100, top=100)
)

# nodes provided in alphabetical order in example above
#  let's look at how to sort based on network measures
# start with a random order
karate_df <- get.data.frame(karate, what = "both")
karate_df$vertices <- karate_df$vertices[sample(1:nrow(karate_df$vertices)),]
karate_df$edges$from <- match(karate_df$edges$from,karate_df$vertices$name) - 1
karate_df$edges$to <- match(karate_df$edges$to,karate_df$vertices$name) - 1

adjacencyNetwork(
  Links = karate_df$edges,
  Nodes = karate_df$vertices[,c(2,1)],
  Source = "from",
  Target = "to",
  NodeID = "name",
  Group = "Faction",
  margin = list(left=100, top=100)
)

# authority score sorting
karate_df <- get.data.frame(karate, what = "both")

karate_df$vertices <- karate_df$vertices[
  match(
    names(sort(authority.score(karate)$vector,decreasing=TRUE)),
    karate_df$vertices$name
  ),
]
karate_df$edges$from <- match(karate_df$edges$from,karate_df$vertices$name) - 1
karate_df$edges$to <- match(karate_df$edges$to,karate_df$vertices$name) - 1

adjacencyNetwork(
  Links = karate_df$edges,
  Nodes = karate_df$vertices[,c(2,1)],
  Source = "from",
  Target = "to",
  NodeID = "name",
  Group = "Faction",
  margin = list(left=100, top=100)
)


# community then by degree sorting
library(dplyr)
fc <- fastgreedy.community(karate)
karate_df <- get.data.frame(karate, what = "both")
karate_df$vertices <- data.frame(membership = unclass(membership(fc)), degree = degree(karate)) %>%
  mutate( name = rownames(.) ) %>%
  arrange( membership, desc( degree ) ) %>%
  select( name ) %>%
  as.vector %>%
  inner_join( karate_df$vertices )
karate_df$edges$from <- match(karate_df$edges$from,karate_df$vertices$name) - 1
karate_df$edges$to <- match(karate_df$edges$to,karate_df$vertices$name) - 1

adjacencyNetwork(
  Links = karate_df$edges,
  Nodes = karate_df$vertices[,c(2,1)],
  Source = "from",
  Target = "to",
  NodeID = "name",
  Group = "Faction",
  margin = list(left=100, top=100)
)
