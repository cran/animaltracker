% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data_analysis.R
\name{qqplot_time}
\alias{qqplot_time}
\title{Generates a QQ plot to show the distribution of time between GPS measurements.}
\usage{
qqplot_time(rds_path)
}
\arguments{
\item{rds_path}{Path of .rds animal data file to read in}
}
\value{
quantile-quantile plot to show distribution of time between GPS measurements
}
\description{
Generates a QQ plot to show the distribution of time between GPS measurements.
}
\examples{
# QQ plot of GPS measurment time differences for demo data .rds

qqplot_time(system.file("extdata", "demo_nov19.rds", package = "animaltracker"))
}
