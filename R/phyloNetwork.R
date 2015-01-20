#' Create Phylogram network diagrams.
#'
#' @param newick a string in \href{http://en.wikipedia.org/wiki/Newick_format}{Newick format}
#' @param height height for the network graph's frame area in pixels (if
#'   \code{NULL} then height is automatically determined based on context)
#' @param width numeric width for the network graph's frame area in pixels (if
#'   \code{NULL} then width is automatically determined based on context)
#'
#'
#' @examples
#' \dontrun{
#' #### Create tree from JSON formatted data
#' ## Download JSON data
#' library(RCurl)
#' Flare <- getURL("http://bit.ly/1uNNAbu")
#'
#' ## Convert to list format
#' Flare <- rjson::fromJSON(Flare)
#'
#' ## Recreate Bostock example from http://bl.ocks.org/mbostock/4063550
#' treeNetwork(List = Flare, fontSize = 10, opacity = 0.9)
#'
#' #### Create a tree dendrogram from an R hclust object
#' hc <- hclust(dist(USArrests), "ave")
#' treeNetwork(as.treeNetwork(hc))
#'
#' #### Create tree from a hierarchical R list
#' CanadaPC <- list(name = "Canada", children = list(list(name = "Newfoundland",
#'                     children = list(list(name = "St. John's"))),
#'                list(name = "PEI",
#'                     children = list(list(name = "Charlottetown"))),
#'                list(name = "Nova Scotia",
#'                     children = list(list(name = "Halifax"))),
#'                list(name = "New Brunswick",
#'                     children = list(list(name = "Fredericton"))),
#'                list(name = "Quebec",
#'                     children = list(list(name = "Montreal"),
#'                                     list(name = "Quebec City"))),
#'                list(name = "Ontario",
#'                     children = list(list(name = "Toronto"),
#'                                     list(name = "Ottawa"))),
#'                list(name = "Manitoba",
#'                     children = list(list(name = "Winnipeg"))),
#'                list(name = "Saskatchewan",
#'                     children = list(list(name = "Regina"))),
#'                list(name = "Nunavuet",
#'                     children = list(list(name = "Iqaluit"))),
#'                list(name = "NWT",
#'                     children = list(list(name = "Yellowknife"))),
#'                list(name = "Alberta",
#'                     children = list(list(name = "Edmonton"))),
#'                list(name = "British Columbia",
#'                     children = list(list(name = "Victoria"),
#'                                     list(name = "Vancouver"))),
#'                list(name = "Yukon",
#'                     children = list(list(name = "Whitehorse")))
#' ))
#'
#' treeNetwork(List = CanadaPC, fontSize = 10)
#' }
#'
#' @source 
#'
#' Ken-ichi Ueda: \url{http://bl.ocks.org/kueda/1036776}.
#' 
#' Tim Thimmaiah: \url{https://github.com/tim-thimmaiah/phylonator}
#' 
#' Jason Davies: \url{https://github.com/jasondavies/newick.js}
#'
#' @importFrom rjson toJSON
#' @export
#'
phyloNetwork <- function(
                          newick,
                          height = NULL,
                          width = NULL,
                          type = "phylogram", ...)
{
    # validate input


    # create options
    options = list(
        height = height,
        width = width,
        ...
    )

    # create widget
    htmlwidgets::createWidget(
      name = "phyloNetwork",
      x = list(newick = newick, type = type, options = options),
      width = width,
      height = height,
      htmlwidgets::sizingPolicy(viewer.suppress = TRUE,
                                browser.fill = TRUE,
                                browser.padding = 75,
                                knitr.figure = FALSE,
                                knitr.defaultWidth = 800,
                                knitr.defaultHeight = 500),
      package = "networkD3")
}

#' @rdname networkD3-shiny
#' @export
phyloNetworkOutput <- function(outputId, width = "100%", height = "800px") {
    shinyWidgetOutput(outputId, "phyloNetwork", width, height,
                        package = "networkD3")
}

#' @rdname networkD3-shiny
#' @export
renderTreeNetwork <- function(expr, env = parent.frame(), quoted = FALSE) {
    if (!quoted) { expr <- substitute(expr) } # force quoted
    shinyRenderWidget(expr, phyloNetworkOutput, env, quoted = TRUE)
}

