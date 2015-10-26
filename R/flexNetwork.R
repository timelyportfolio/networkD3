#' Create Reingold-Tilford Tree network diagrams with different node sizes.
#'
#' @param List a hierarchical list object with a root node and children.
#' @param height height for the network graph's frame area in pixels (if
#'   \code{NULL} then height is automatically determined based on context)
#' @param width numeric width for the network graph's frame area in pixels (if
#'   \code{NULL} then width is automatically determined based on context)
#' @param fontSize numeric font size in pixels for the node text labels.
#' @param fontFamily font family for the node text labels.
#' @param linkColour character string specifying the colour you want the link
#' lines to be. Multiple formats supported (e.g. hexadecimal).
#' @param nodeColour character string specifying the colour you want the node
#' circles to be. Multiple formats supported (e.g. hexadecimal).
#' @param nodeStroke character string specifying the colour you want the node
#' perimeter to be. Multiple formats supported (e.g. hexadecimal).
#' @param textColour character string specifying the colour you want the text to
#' be before they are clicked. Multiple formats supported (e.g. hexadecimal).
#' @param opacity numeric value of the proportion opaque you would like the
#' graph elements to be.
#' @param margin an integer or a named \code{list}/\code{vector} of integers
#' for the plot margins. If using a named \code{list}/\code{vector},
#' the positions \code{top}, \code{right}, \code{bottom}, \code{left}
#' are valid.  If a single integer is provided, then the value will be
#' assigned to the right margin. Set the margin appropriately
#' to accomodate long text labels.
#' @param spacing
#'
#' @source Reingold. E. M., and Tilford, J. S. (1981). Tidier Drawings of Trees.
#' IEEE Transactions on Software Engineering, SE-7(2), 223-228.
#'
#' Mike Bostock: \url{http://bl.ocks.org/mbostock/4339083}.
#'
#' @export
#'
flexNetwork <- function(
                          List,
                          height = NULL,
                          width = NULL,
                          fontSize = 10,
                          fontFamily = "serif",
                          linkColour = "#ccc",
                          nodeColour = "#fff",
                          nodeStroke = "steelblue",
                          textColour = "#111",
                          opacity = 0.9,
                          margin = NULL,
                          spacing = NULL,
                          separation = NULL
                       )
{
    # validate input
    if (!is.list(List))
      stop("List must be a list object.")
    root <- List
    
    margin <- margin_handler(margin)

    # create options
    options = list(
        height = height,
        width = width,
        fontSize = fontSize,
        fontFamily = fontFamily,
        linkColour = linkColour,
        nodeColour = nodeColour,
        nodeStroke = nodeStroke,
        textColour = textColour,
        margin = margin,
        opacity = opacity,
        spacing = spacing,
        separation = separation
    )

    # create widget
    htmlwidgets::createWidget(
      name = "flexNetwork",
      x = list(root = root, options = options),
      width = width,
      height = height,
      htmlwidgets::sizingPolicy(padding = 10, browser.fill = TRUE),
      package = "networkD3")
}
