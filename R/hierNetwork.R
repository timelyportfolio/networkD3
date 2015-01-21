#' Create Hierarchical d3 Visualization
#'
#' @param List a hierarchical list object with a root node and children.
#' @param type String type of chart.
#' \itemize{
#'      \item{Default "tree.cartesian"}
#'      \item{"tree.radial"}
#'      \item{"cluster.cartesian"}
#'      \item{"cluster.radial"}
#'      \item{"pack.nested"}
#'      \item{"pack.flattened"}
#'      \item{"partition.arc"}
#'      \item{"partition.rectangle"}
#'      \item{"treemap"}
#' }
#' @param value String name of the variable to use to size the nodes
#'    in chart "types" where applicable:
#'     \code{"pack.nested"},
#'     \code{"pack.flattened"},
#'     \code{"partition.arc"},
#'     \code{"partition.rectangle"},
#'     \code{"treemap"}.
#'    \code{"size"} is the default.
#' @param zoomable Logical Set \code{TRUE} to add pan and zoom
#' @param collapsible Logical Set \code{TRUE} to add collapsible nodes
#' @param radius = NULL
#' @param duration Integer length of duration for animations. Default is 750.
#' @param margin List of plot margins in px by side. Set the margin
#'   appropriately to accomodate long text labels.
#'   \code{margin = list(left=100,top=20)}
#' @param height height for the network graph's frame area in pixels (if
#'   \code{NULL} then height is automatically determined based on context)
#' @param width numeric width for the network graph's frame area in pixels (if
#'   \code{NULL} then width is automatically determined based on context)
#'
#'
#' @examples
#' \dontrun{
#' #### Create a tree dendrogram from an R hclust object
#' hc <- hclust(dist(USArrests), "ave")
#' 
#' #### Look at the chart types that apply to this data
#' lapply(
#'   c("tree.cartesian"
#'     ,"tree.radial"
#'     ,"cluster.cartesian"
#'     ,"cluster.radial"
#'   )
#'   ,function(chartType){
#'     hierNetwork( as.treeNetwork(hc), type = chartType, zoomable = T, collapsible = T )
#'   }
#' )
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
#' hierNetwork(List = CanadaPC, type = "cluster.radial", collapsible = T)
#' hierNetwork(List = CanadaPC, type = "cluster.cartesian"
#'   , margin = list(left=100), collapsible = T, zoomable = T )
#' }
#'
#' @source Anna Bansaghi \url{https://github.com/bansaghi/d3.chart.layout}
#'
#' Irene Ros & Mike Pennisi \url{https://github.com/misoproject/d3.chart}.
#'
#' @importFrom rjson toJSON
#' @export
#'
hierNetwork <- function(
  List,
  type = "tree.cartesian",
  value = "size",     # name of the column for size/value where applicable
  height = NULL,
  width = NULL,
  margin = NULL,      # list with any/all of top, right, left, bottom in Px
  zoomable = NULL,    # logical; add pan and zoom
  collapsible = NULL, # logical; add collapsible
  radius = NULL,
  duration = NULL
){
  # validate input
  if (!is.list(List))
    stop("List must be a list object.")
  root <- toJSON(List)
  
  # create options
  options = list(
    type = type,
    value = value,
    height = height,
    width = width,
    margin = margin,
    zoomable = zoomable,
    collapsible = collapsible,
    radius = radius,
    duration = duration
  )
  
  options = Filter(Negate(is.null),options)
  
  # create widget
  htmlwidgets::createWidget(
    name = "hierNetwork",
    x = list(root = root, options = options),
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
hierNetworkOutput <- function(outputId, width = "100%", height = "800px") {
  shinyWidgetOutput(outputId, "hierNetwork", width, height,
                    package = "networkD3")
}

#' @rdname networkD3-shiny
#' @export
renderHierNetwork <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  shinyRenderWidget(expr, hierNetworkOutput, env, quoted = TRUE)
}
