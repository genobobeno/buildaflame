#' Disable Action Button
#' 
#' Yup
#'
#' @param val1 href domain
#' @param val2 text
#' 
#' @return string
utils_disableActionButton <- function(id,session) {
  session$sendCustomMessage(type="jsCode",
                            list(code= paste("$('#",id,"').prop('disabled',true)"
                                             ,sep="")))
}