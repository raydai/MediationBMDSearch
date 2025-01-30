#' Launch the MediationBMDSearch Shiny App
#'
#' This function starts the Shiny app for searching mediation effects on BMD.
#' @export
runMediationBMDApp <- function() {
  appDir <- system.file("shiny-app", package = "MediationBMDSearch")
  if (appDir == "") {
    stop("Could not find Shiny app directory. Try re-installing the package.", call. = FALSE)
  }
  shiny::runApp(appDir, launch.browser = TRUE)
}