% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data_processing.R
\name{process_elevation}
\alias{process_elevation}
\title{Process and optionally export modeled elevation data from existing animal data file}
\usage{
process_elevation(
  zoom = 11,
  get_slope = TRUE,
  get_aspect = TRUE,
  in_path,
  export = FALSE,
  out_path = NULL
)
}
\arguments{
\item{zoom}{level of zoom, defaults to 11}

\item{get_slope}{logical, whether to compute slope (in degrees), defaults to True}

\item{get_aspect}{logical, whether to compute aspect (in degrees), defaults to True}

\item{in_path}{animal tracking data file to model elevation from}

\item{export}{logical, whether to export data with elevation, defaults to False}

\item{out_path}{.rds file path for processed data when export is True}
}
\value{
list of data frames with gps data augmented by elevation
}
\description{
Process and optionally export modeled elevation data from existing animal data file
}
