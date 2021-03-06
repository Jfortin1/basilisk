#' The BasiliskEnvironment class
#'
#' The BasiliskEnvironment class provides a simple structure 
#' containing all of the information to construct a \pkg{basilisk} environment.
#' It is used by \code{\link{basiliskStart}} to perform lazy installation.
#'
#' @author Aaron lun
#'
#' @section Constructor:
#' \code{BasiliskEnvironment(envname, pkgname, packages)} will return a BasiliskEnvironment object, given:
#' \itemize{
#' \item \code{envname}, string containing the name of the environment.
#' Environment names starting with an underscore are reserved for internal use.
#' \item \code{pkgname}, string containing the name of the package that owns the environment.
#' \item \code{packages}, character vector containing the names of the required Python packages from conda,
#' see \code{\link{setupBasiliskEnv}} for requirements.
#' \item \code{pip}, character vector containing names of additional Python packages from PyPi,
#' see \code{\link{setupBasiliskEnv}} for requirements.
#' }
#' 
#' @examples
#' BasiliskEnvironment("my_env1", "AaronPackage", 
#'     packages=c("scikit-learn=0.22.0", "pandas=0.24.1"))
#' @docType class
#' @name BasiliskEnvironment-class
#' @aliases BasiliskEnvironment-class
#' BasiliskEnvironment
NULL

#' @export
setClass("BasiliskEnvironment", slots=c(envname="character", pkgname="character", packages="character", pip="character"))

#' @export
#' @import methods 
BasiliskEnvironment <- function(envname, pkgname, packages, pip=character(0)) {
    new("BasiliskEnvironment", envname=envname, pkgname=pkgname, packages=packages, pip=pip)
}

setValidity("BasiliskEnvironment", function(object) {
    msg <- character(0)

    if (length(val <- .getEnvName(object))!=1 || is.na(val) || !is.character(val)){ 
        msg <- c(msg, "'envname' should be a non-NA string")
    }
    if (grepl("^_", val)) {
        msg <- c(msg, "environment names starting with an underscore are reserved")
    }

    if (length(val <- .getPkgName(object))!=1 || is.na(val) || !is.character(val)){ 
        msg <- c(msg, "'pkgname' should be a non-NA string")
    }

    if (any(is.na(.getPackages(object)))) {
        msg <- c(msg, "'packages' should not contain NA strings")
    }

    if (any(is.na(.getPipPackages(object)))) {
        msg <- c(msg, "'pip' should not contain NA strings")
    }

    if (length(msg)) {
        msg
    } else {
        TRUE
    }
})

setGeneric(".getEnvName", function(x) standardGeneric(".getEnvName"))

setGeneric(".getPkgName", function(x) standardGeneric(".getPkgName"))

setMethod(".getEnvName", "BasiliskEnvironment", function(x) x@envname)

setMethod(".getPkgName", "BasiliskEnvironment", function(x) x@pkgname)

setMethod(".getEnvName", "character", identity)

setMethod(".getPkgName", "character", function(x) NULL) 

.getPackages <- function(x) x@packages

.getPipPackages <- function(x) x@pip
