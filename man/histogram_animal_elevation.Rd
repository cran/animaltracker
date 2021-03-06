% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data_processing.R
\name{histogram_animal_elevation}
\alias{histogram_animal_elevation}
\title{Generate a histogram of the distribution of modeled elevation - measured altitude}
\usage{
histogram_animal_elevation(datapts)
}
\arguments{
\item{datapts}{GPS data with measured Altitude and computed Elevation data}
}
\value{
histogram of the distribution of modeled elevation - measured altitude
}
\description{
Generate a histogram of the distribution of modeled elevation - measured altitude
}
\examples{
# Histogram of elevation - altitude for the demo data

histogram_animal_elevation(demo)
}
