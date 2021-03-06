% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data_processing.R
\name{read_columbus}
\alias{read_columbus}
\title{Read and process a Columbus P-1 data file containing NMEA records into a data frame}
\usage{
read_columbus(filename)
}
\arguments{
\item{filename}{path of Columbus P-1 data file}
}
\value{
NMEA records in RMC and GGA formats as a data frame
}
\description{
Read and process a Columbus P-1 data file containing NMEA records into a data frame
}
\examples{

read_columbus(system.file("extdata", "demo_columbus.TXT", package = "animaltracker"))
}
