
### Summary Functions

if(getRversion() >= '2.5.1') {
  globalVariables(c('GPS', 'Altitude', 'Distance', 'Course',
                    'n.x', 'n.y', 'meanLat.x', 'meanLat.y', 'sdLat.x', 'sdLat.y',
                    'meanLong.x', 'meanLong.y', 'sdLong.x', 'sdLong.y', 'meanDist.x',
                    'meanDist.y', 'sdDist.x', 'sdDist.y', 'meanCourse.x', 'meanCourse.y',
                    'sdCourse.x', 'sdCourse.y', 'meanRate.x', 'meanRate.y', 'sdRate.x',
                    'sdRate.y', 'meanElev.x', 'meanElev.y', 'sdElev.x', 'sdElev.y',
                    'nDiff', 'meanLatDiff', 'meanLongDiff', 'sdLongDiff', 'meanDistDiff',
                    'sdDistDiff', 'meanCourseDiff', 'sdCourseDiff', 'meanRateDiff',
                    'sdRateDiff', 'meanElevDiff', 'sdLatDiff', 'sdElevDiff',
                    'avg', 'Data', 'obs', 'Latitude.x', 'Latitude.y', 'Longitude.x',
                    'Longitude.y', 'Distance.x', 'Distance.y', 'Rate.x', 'Rate.y', 'Course.x',
                    'Course.y', 'Elevation.x', 'Elevation.y', 'Slope.x', 'Slope.y',
                    'cumDist.y', 'Rate.y', 'RateFlag.x', 'RateFlag.y', 'CourseFlag.x', 'CourseFlag.y',
                    'DistanceFlag.x', 'DistanceFlag.y', 'TotalFlags.x', 'TotalFlags.y',
                    'DistanceFlag'))
}

#'
#'Summarise a number of animal datasets by GPS unit
#'
#'@param rds_path Path of .rds cow data file to read in
#'@return summary statistics for animals by GPS unit
#'@examples
#'# Read in .rds of demo data and summarise by GPS unit
#'
#'summarise_unit(system.file("extdata", "demo_nov19.rds", package = "animaltracker"))
#'@export
#'
summarise_unit <- function(rds_path) {
  ani <- readRDS(rds_path)
  anidata <- bind_rows(ani) 
  summary <- anidata %>% 
    group_by(GPS) %>%
    summarize( nani = length(unique(Animal)),
               meanAlt = mean(Altitude),
               sdAlt = stats::sd(Altitude),
               minAlt = min(Altitude),
               maxAlt = max(Altitude))
  return(summary)
}

#'
#'Determines the GPS measurement time value difference values
#'roughly corresponding to quantiles with .05 intervals.
#'
#'@param rds_path Path of .rds animal data file to read in
#'@return approximate time difference values corresponding to quantiles (.05 intervals)
#'@examples
#'# Read in .rds of demo data and calculate time difference quantiles
#'
#'quantile_time(system.file("extdata", "demo_nov19.rds", package = "animaltracker"))
#'@export
#'
quantile_time <- function(rds_path) {
  ani <- readRDS(rds_path)
  anidata <- bind_rows(ani) 
  quantile <- quantile(anidata$TimeDiffMins, probs = seq(0,1,.05))
  return(quantile)
}

#'
#'Get summary statistics for a single column in an animal data frame
#'
#'@param df animal data frame
#'@param col column to get summary stats for, as a string
#'@return data frame of summary stats for col
#'@examples
#'# Get summary statistics for Distance column of demo data
#'
#'summarise_col(demo, Distance)
#'
#'@export
summarise_col <- function(df, col) {
  summary <- df %>%
    dplyr::group_by(Animal) %>%
    dplyr::filter(!all(is.na({{col}}))) %>% 
    dplyr::summarise(
      N = n(),
      Mean = mean({{col}}),
      Median = stats::median({{col}}),
      SD = stats::sd({{col}}),
      Variance = stats::var({{col}}),
      Q1 = stats::quantile({{col}}, 0.25),
      Q3 = stats::quantile({{col}}, 0.75),
      IQR = stats::IQR({{col}}),
      Range = (max({{col}})-min({{col}})),
      Min = min({{col}}),
      Max = max({{col}})
    )
  return(summary)
}

### Plotting Functions

#'
#'Generates a boxplot to visualize the distribution of altitude
#'by GPS.
#'
#'@param rds_path Path of .rds animal data file to read in
#'@return overall boxplot of altitude by GPS
#'@examples
#'# Boxplot of altitude for demo data .rds
#'
#'boxplot_altitude(system.file("extdata", "demo_nov19.rds", package = "animaltracker"))
#'@export
#'
boxplot_altitude <- function(rds_path) {
  ani <- readRDS(rds_path)
  anidata <- dplyr::bind_rows(ani)
  plot <- ggplot(anidata, aes(x=GPS, y=Altitude))+
    geom_boxplot()+
    theme_minimal()
  return(plot)
}


#'
#'Generates a histogram to visualize the distribution of time
#'between GPS measurements.
#'
#'@param rds_path Path of .rds cow data file to read in
#'@return distribution of time between GPS measurements, as a histogram
#'@examples
#'# Histogram of GPS measurement time differences for demo data .rds
#'
#'histogram_time(system.file("extdata", "demo_nov19.rds", package = "animaltracker"))
#'@export
#'
histogram_time <- function(rds_path) {
  ani <- readRDS(rds_path)
  anidata <- bind_rows(ani) 
  plot <- ggplot(anidata, aes(x=TimeDiffMins))+
    geom_histogram( col= "white") + 
    ggtitle("Distribution of Time Between GPS Measurements" )+ 
    theme_minimal()
  return(plot)
}

#'
#'Generates a histogram to visualize the distribution of time between
#'GPS measurements by GPS unit.
#'
#'@param rds_path Path of .rds animal data file to read in
#'@return distribution of time between GPS measurements by GPS unit, as a histogram
#'@examples
#'# Histogram of GPS measurement time differences by GPS unit for demo data .rds
#'
#'histogram_time_unit(system.file("extdata", "demo_nov19.rds", package = "animaltracker"))
#'@export
#'
histogram_time_unit <- function(rds_path) {
  ani <- readRDS(rds_path)
  anidata <- bind_rows(ani) 
  plot <- ggplot(anidata, aes(x=TimeDiffMins))+
    geom_histogram( col= "white") + 
    facet_wrap(~GPS)+
    ggtitle("Distribution of Time Between GPS Measurements by GPS Unit" )+ 
    theme_minimal()
  return(plot)
}

#'
#'Generates a boxplot to visualize the distribution of time between
#'GPS measurements by GPS unit.
#'
#'@param rds_path Path of .rds animal data file to read in
#'@return distribution of time between GPS measurements by GPS unit, as a boxplot
#'@examples
#'# Boxplot of GPS measurement time differences for demo data .rds
#'
#'boxplot_time_unit(system.file("extdata", "demo_nov19.rds", package = "animaltracker"))
#'@export
#'
boxplot_time_unit <- function(rds_path) {
  ani <- readRDS(rds_path)
  anidata <- bind_rows(ani) 
  plot <- ggplot(anidata, aes(x=GPS, y=TimeDiffMins))+
    geom_boxplot() + 
    coord_flip()+
    ggtitle("Distribution of Time Between GPS Measurements by GPS Unit" )+ 
    theme_minimal()
  return(plot)
}

#'
#'Generates a QQ plot to show the distribution of time between GPS measurements.
#' 
#'@param rds_path Path of .rds animal data file to read in
#'@return quantile-quantile plot to show distribution of time between GPS measurements
#'@examples
#'# QQ plot of GPS measurment time differences for demo data .rds
#'
#'qqplot_time(system.file("extdata", "demo_nov19.rds", package = "animaltracker"))
#'@export
#'
qqplot_time <- function(rds_path) {
  ani <- readRDS(rds_path)
  anidata <- bind_rows(ani) 
  plot <- ggplot(anidata, aes(sample = TimeDiffMins)) +
  stat_qq()
  return(plot)
}

#'
#'Compares two animal data frames and calculates summary statistics. 
#'GPS, date, lat, long, course, distance, rate, elevation column names should match. 
#'
#'@param correct reference data frame
#'@param candidate data frame to be compared to the reference
#'@param use_elev logical, whether to include elevation in summary, defaults to True
#'@param export logical, whether to export summaries to .csv, defaults to False
#'@param gps_out desired file name of .csv output summary by GPS collar when export is True
#'@param date_out desired file name of .csv output summary by date when export is True
#'@return list containing gps_out and date_out as data frames
#'@examples
#'# Compare and summarise unfiltered demo cows to filtered 
#
#'compare_summarise_data(demo_unfiltered_elev, demo_filtered_elev)
#'@export
#'
compare_summarise_data <- function(correct, candidate, use_elev = TRUE, export = FALSE, gps_out = NULL, date_out = NULL) {
  if(use_elev) {
    correct_gps_summary <- correct %>% 
      summarise_anidf(GPS, Latitude, Longitude, Distance, Course, Rate, Elevation)
    
    correct_date_summary <- correct %>% 
      summarise_anidf(Date, Latitude, Longitude, Distance, Course, Rate, Elevation)
    
    candidate_gps_summary <- candidate %>% 
      summarise_anidf(GPS, Latitude, Longitude, Distance, Course, Rate, Elevation)
    
    candidate_date_summary <- candidate %>% 
      summarise_anidf(Date, Latitude, Longitude, Distance, Course, Rate, Elevation)
  }
  else {
    correct_gps_summary <- correct %>% 
      summarise_anidf(GPS, Latitude, Longitude, Distance, Course, Rate, use_elev = FALSE)
    
    correct_date_summary <- correct %>% 
      summarise_anidf(Date, Latitude, Longitude, Distance, Course, Rate, use_elev = FALSE)
    
    candidate_gps_summary <- candidate %>% 
      summarise_anidf(GPS, Latitude, Longitude, Distance, Course, Rate, use_elev = FALSE)
    
    candidate_date_summary <- candidate %>% 
      summarise_anidf(Date, Latitude, Longitude, Distance, Course, Rate, use_elev = FALSE)
  }
 
  
  gps_summary <- join_summaries(correct_gps_summary, candidate_gps_summary, by_str="GPS")
  date_summary <- join_summaries(correct_date_summary, candidate_date_summary, by_str="Date")
  
  if(export & !is.null(gps_out) & !is.null(date_out)) {
    utils::write.csv(gps_summary, gps_out, row.names = FALSE)
    utils::write.csv(date_summary, date_out, row.names = FALSE)
  }
  
  return(list(GPS = gps_summary, Date = date_summary))
}

#'
#'Calculates summary statistics for an animal data frame
#'
#'@param anidf the animal data frame
#'@param by column to group by, null if daily=TRUE
#'@param lat latitude column
#'@param long longitude column
#'@param dist distance column
#'@param course course column
#'@param rate rate column
#'@param elev elevation column, must be defined when use_elev is true, otherwise NULL
#'@param use_elev logical, whether to include elevation in summary, defaults to true
#'@param daily whether to group by both GPS and Date for daily summary, defaults to false
#'@return data frame of summary statistics for the animal data frame
#'@examples
#'# Summary of demo data by date
#'
#'summarise_anidf(demo, Date, Latitude, Longitude, Distance, Course, Rate, Elevation)
#'
#'@export
#'
summarise_anidf <- function(anidf, by, lat, long, dist, course, rate, elev = NULL, use_elev = TRUE, daily = FALSE) {
  if(daily) {
    anidf <- anidf %>% 
      dplyr::group_by(GPS, Date)
  }
  else {
    anidf <- anidf %>% 
      dplyr::group_by({{by}}) 
  }
  summary <- anidf %>% 
    dplyr::summarise(n = n(),
                     meanLat = mean({{lat}}),
                     sdLat = stats::sd({{lat}}),
                     meanLong = mean({{long}}),
                     sdLong = stats::sd({{long}}),
                     meanDist = mean({{dist}}),
                     sdDist = stats::sd({{dist}}),
                     meanCourse = mean({{course}}),
                     sdCourse = stats::sd({{course}}),
                     meanRate = mean({{rate}}),
                     sdRate = stats::sd({{rate}}))
  if(use_elev) {
    if(daily) {
      summary <- dplyr::full_join(summary, anidf %>% dplyr::summarise(meanElev = mean({{elev}}), sdElev = stats::sd({{elev}})), by = c("GPS", "Date"))
    }
    else {
      summary <- dplyr::full_join(summary, anidf %>% dplyr::summarise(meanElev = mean({{elev}}), sdElev = stats::sd({{elev}})), by = colnames(summary)[1])
    }
  }
  return(summary %>% dplyr::ungroup())
}

#'
#'Joins two animal data frame summaries by a column and appends differences
#'
#'@param correct_summary summary data frame of reference dataset, returned by summarise_anidf
#'@param candidate_summary summary data frame of dataset to be compared to reference, returned by summarise_anidf
#'@param by_str column to join by as a string, null if daily=TRUE
#'@param daily whether to group by both GPS and Date for daily summary, defaults to False
#'@param use_elev logical, whether to include elevation in summary, defaults to true
#'@return data frame of joined summaries with differences
#'@examples
#'# Join date summaries of unfiltered and filtered demo data

#'## Summarise unfiltered demo by date
#'unfiltered_summary <- summarise_anidf(demo_unfiltered_elev, Date, Latitude, Longitude, 
#'Distance, Course, Rate, Elevation, daily=FALSE)
#'
#'## Summarise filtered demo by date
#'filtered_summary <- summarise_anidf(demo_filtered_elev, Date, Latitude, Longitude, 
#'Distance, Course, Rate, Elevation, daily=FALSE)
#'
#'## Join
#'join_summaries(unfiltered_summary, filtered_summary, "Date", daily=FALSE)
#'@export
#'
#'
join_summaries <- function(correct_summary, candidate_summary, by_str, daily = FALSE, use_elev = TRUE) {
  if(daily) {
    summary_all <- dplyr::full_join(correct_summary, candidate_summary, by = c("GPS", "Date"))
  }
  else {
    summary_all <- dplyr::full_join(correct_summary, candidate_summary, by = by_str)
  }
  
  summary_all <- summary_all %>% 
    # create difference columns
    dplyr::mutate(nDiff = n.x - n.y) %>% 
    dplyr::mutate(meanLatDiff = meanLat.x - meanLat.y) %>% 
    dplyr::mutate(sdLatDiff = sqrt((sdLat.x)^2 + (sdLat.y)^2)) %>% 
    dplyr::mutate(meanLongDiff = meanLong.x - meanLong.y) %>% 
    dplyr::mutate(sdLongDiff = sqrt((sdLong.x)^2 + (sdLong.y)^2)) %>% 
    dplyr::mutate(meanDistDiff = meanDist.x - meanDist.y) %>% 
    dplyr::mutate(sdDistDiff = sqrt((sdDist.x)^2 + (sdDist.y)^2)) %>% 
    dplyr::mutate(meanCourseDiff = meanCourse.x - meanCourse.y) %>% 
    dplyr::mutate(sdCourseDiff = sqrt((sdCourse.x)^2 + (sdCourse.y)^2)) %>% 
    dplyr::mutate(meanRateDiff = meanRate.x - meanRate.y) %>% 
    dplyr::mutate(sdRateDiff = sqrt((sdRate.x)^2 + (sdRate.y)^2))
  
  if(use_elev) {
    summary <- summary_all %>% 
      dplyr::mutate(meanElevDiff = meanElev.x - meanElev.y) %>% 
      dplyr::mutate(sdElevDiff = sqrt((sdElev.x)^2 + (sdElev.y)^2)) 
  }
   
   return(summary_all)
}

#'
#'Compares summary statistics from two datasets as side-by-side violin plots
#'
#'@param df_summary data frame of summary statistics from both datasets to be compared
#'@param by GPS or Date
#'@param col_name variable in df_summary to be used for the y-axis, as a string
#'@param export logical, whether to export plot, defaults to False
#'@param out .png file name to save plot when export is True
#'@return side-by-side violin plots
#'@examples
#'# Violin plot comparing unfiltered and filtered demo data summaries by date for a single variable

#'## Summarise unfiltered demo
#'unfiltered_summary <- summarise_anidf(demo_unfiltered_elev, Date, Latitude, Longitude, 
#'Distance, Course, Rate, Elevation, daily=FALSE)
#'
#'## Summarise filtered demo
#'filtered_summary <- summarise_anidf(demo_filtered_elev, Date, Latitude, Longitude, 
#'Distance, Course, Rate, Elevation, daily=FALSE)
#'
#'## Join
#'summary <- join_summaries(unfiltered_summary, filtered_summary, "Date", daily=FALSE)
#'
#'## Violin plot
#'
#'violin_compare(summary, Date, "meanElev")
#'
#'@export
#'
violin_compare <- function(df_summary, by, col_name, export = FALSE, out = NULL) {
  df_summary <- df_summary %>% 
    dplyr::select({{by}}, paste0(col_name, ".x"), paste0(col_name, ".y")) %>% 
    tidyr::gather("source", obs, -{{by}}) %>% 
    dplyr::mutate(source = gsub(paste0(col_name, "\\."), "", source)) %>% 
    dplyr::mutate(source = gsub("x", "Correct", source)) %>% 
    dplyr::mutate(source = gsub("y", "Candidate", source))
  
  violin <- ggplot(df_summary, aes(x = source, y=obs, fill=source)) +
    geom_violin(draw_quantiles = c(0.25, 0.5, 0.75)) +
    scale_x_discrete(limits=c("Correct", "Candidate")) +
    xlab("Data") +
    ylab(col_name) + 
    theme_minimal() +
    theme(legend.position = "none") 
  
  if(export & !is.null(out)) {
    ggsave(out, violin)
  }
  
  return(violin)
}

#'
#'Compares moving averages of a variable for two datasets over time, grouped by GPS
#'GPS, Date, and col columns should match
#'
#'@param correct reference data frame
#'@param candidate data frame to be compared to the reference
#'@param col variable to plot the moving average for
#'@param export logical, whether to export plot, defaults to False
#'@param out .png file name to save plot when export is True
#'@return faceted line plot of moving averages over time grouped by GPS
#'@examples
#'# Faceted line plot comparing moving averages over time 
#'# grouped by GPS for unfiltered and filtered demo data
#'## Set distance as the y axis
#'line_compare(demo_unfiltered, demo_filtered, Distance)
#'@export
#'
line_compare <- function(correct, candidate, col, export = FALSE, out = NULL) {
  
  correct <- correct %>% 
    dplyr::group_by(GPS, Date) %>% 
    dplyr::summarise(avg = mean({{col}})) %>% 
    dplyr::mutate(Data = "Correct")
  
  candidate <- candidate %>% 
    dplyr::group_by(GPS, Date) %>% 
    dplyr::summarise(avg = mean({{col}})) %>% 
    dplyr::mutate(Data = "Candidate")
  
  plot_data <- dplyr::bind_rows(correct, candidate)
  
  line <- ggplot(plot_data, aes(x=Date, y=avg, group=Data, color=Data)) +
    geom_line() +
    ylab(paste0("Mean ", deparse(substitute(col)))) +
    scale_color_discrete(guide = guide_legend(reverse = TRUE)) +
    facet_wrap(vars(GPS))
  
  if(export & !is.null(out)) {
    ggsave(out, line)
  }
  
  return(line)
}

#'
#'Compares two animal datasets and calculates daily summary statistics by GPS
#'GPS, date, lat, long, course, distance, rate, elevation column names should match. 
#'
#'@param correct reference data frame
#'@param candidate data frame to be compared to the reference
#'@param export logical, whether to export summary to .csv, defaults to False
#'@param out desired file name of .csv output summary when export is True
#'@param use_elev logical, whether to include elevation in summary, defaults to true
#'@return summary data frame
#'@examples
#'# Compare and summarise unfiltered demo cows to filtered, grouped by both Date and GPS
#'
#'compare_summarise_daily(demo_unfiltered_elev, demo_filtered_elev)
#'@export
#'
compare_summarise_daily <- function(correct, candidate, use_elev = TRUE, export = FALSE, out = NULL) {
  if(use_elev) {
    correct_summary <- correct %>% 
      summarise_anidf(NULL, Latitude, Longitude, Distance, Course, Rate, Elevation, daily=TRUE)
    candidate_summary <- candidate %>% 
      summarise_anidf(NULL, Latitude, Longitude, Distance, Course, Rate, Elevation, daily=TRUE)
  }
  else {
    correct_summary <- correct %>% 
      summarise_anidf(NULL, Latitude, Longitude, Distance, Course, Rate, use_elev=FALSE, daily=TRUE)
    candidate_summary <- candidate %>% 
      summarise_anidf(NULL, Latitude, Longitude, Distance, Course, Rate, use_elev=FALSE, daily=TRUE)
  }
  summary_all <- join_summaries(correct_summary, candidate_summary, daily=TRUE)
  
  if(export) {
    utils::write.csv(summary_all, out, row.names = FALSE)
  }
  
  return(summary_all)
}


#'
#'Joins and reformats two animal data frames for the purpose of flag comparison
#'
#'@param correct reference data frame
#'@param candidate df to be compared to the reference
#'@param use_elev logical, whether to include elevation in comparison, defaults to true
#'@param use_slope logical, whether to include slope in comparison, defaults to true
#'@param has_flags logical, whether correct data frame has predefined flags, defaults to false
#'@param dropped_flag dropped flag column, must be defined when has_flags is true, otherwise null
#'@return joined and reformatted data frame
#'@examples
#'# Join and reformat unfiltered demo data and filtered demo data
#'
#'compare_flags(demo_unfiltered_elev, demo_filtered_elev)
#'@export
compare_flags <- function(correct, candidate, use_elev = TRUE, use_slope = TRUE, has_flags = FALSE, dropped_flag = NULL) {
    correct <- correct %>% 
      dplyr::mutate(DateTime = as.POSIXct(DateTime, format="%Y-%m-%d %H:%M:%S")) %>% 
      dplyr::group_by(GPS) %>% 
      dplyr::distinct(DateTime, .keep_all = TRUE) %>% 
      dplyr::ungroup()
    candidate <- candidate %>% 
      dplyr::mutate(DateTime = as.POSIXct(DateTime, format="%Y-%m-%d %H:%M:%S")) %>% 
      dplyr::group_by(GPS) %>% 
      dplyr::distinct(DateTime, .keep_all = TRUE) %>% 
      dplyr::ungroup()
    join <- dplyr::full_join(correct, candidate, by=c("DateTime", "GPS"))
    join_select <- join %>% 
      dplyr::select(DateTime, GPS,
                    Latitude.x, Latitude.y, Longitude.x, Longitude.y,
                    Distance.x, Distance.y, Rate.x, Rate.y,
                    Course.x, Course.y)
    if(use_elev) {
      join_select <- join_select %>% 
        dplyr::bind_cols(join %>% dplyr::select(Elevation.x, Elevation.y))
    }
    if(use_slope) {
      join_select <- join_select %>% 
        dplyr::bind_cols(join %>% dplyr::select(Slope.x, Slope.y))
    }
    if(has_flags) {
      join_select <- join_select %>%
        dplyr::bind_cols(join %>% dplyr::select(RateFlag.x, RateFlag.y, 
                                                CourseFlag.x, CourseFlag.y,
                                                DistanceFlag.x, DistanceFlag.y,
                                                TotalFlags.x, TotalFlags.y, {{dropped_flag}}))
    }
    else {
      join_select <- join_select %>%
        dplyr::bind_cols(join %>% dplyr::select(RateFlag, CourseFlag, DistanceFlag, TotalFlags))
    }
   
    join_select <- join_select %>% dplyr::mutate( Date = as.Date(DateTime, format="%Y-%m-%d"),
                   TimeDiff = NA,
                   TimeDiffMins = NA,
                   cumDist.x = NA,
                   cumDist.y = NA
                   ) %>%
    dplyr::group_by(GPS, Date) %>% 
    dplyr::arrange(DateTime, .by_group = TRUE) %>% 
    dplyr::mutate(Distance.y = dplyr::lag(Distance.y,1), 
                  Distance.x = ifelse(is.na(Distance.x), 0, Distance.x),
                  Distance.y = ifelse(is.na(Distance.y), 0, Distance.y),
                  
                  cumDist.x = cumsum(Distance.x),
                  cumDist.y = cumsum(Distance.y),
                  
                  TimeDiff = ifelse((is.na(dplyr::lag(DateTime,1)) | as.numeric(difftime(DateTime, dplyr::lag(DateTime,1), units="mins")) > 100), 0, as.numeric(DateTime - dplyr::lag(DateTime,1))), 
                  TimeDiffMins = ifelse(TimeDiff == 0, 0, as.numeric(difftime(DateTime, dplyr::lag(DateTime,1), units="mins")))
                  )
    if(has_flags) {
      join_select <- join_select %>%
        dplyr::mutate(Dropped.y = ifelse((TotalFlags.x < 2 & !DistanceFlag.y), 0, 1))
    }
    else {
      join_select <- join_select %>% 
        dplyr::mutate(Dropped.x = ifelse(!is.na(Latitude.x), 0, 1),
                      Dropped.y = ifelse((TotalFlags < 2 & !DistanceFlag), 0, 1)) 
    }
      
    return(as.data.frame(join_select %>% dplyr::ungroup()))
}


#'
#'Alternative implementation of the robust peak detection algorithm by van Brakel 2014 
#'Classifies data points with modified z-scores greater than max_score as outliers ccording to Iglewicz and Hoaglin 1993
#'
#'@param df_comparison output of compare_flags 
#'@param lag width of interval to compute rolling median and MAD, defaults to 5
#'@param max_score modified z-score cutoff to classify observations as outliers, defaults to 3.5
#'@return df with classifications
#'@export
#'
detect_peak_modz <- function(df_comparison, lag = 5, max_score = 3.5) {
  peak_comparison <- df_comparison %>% 
    dplyr::group_by(GPS, Date) %>% 
    dplyr::arrange(DateTime, .by_group = TRUE) %>% 
    dplyr::mutate(
      cumDistLower = zoo::rollmedianr(cumDist.y, lag, fill=NA) - max_score*zoo::rollapplyr(cumDist.y, lag, stats::mad, fill=NA)/0.6745,
      cumDistUpper = zoo::rollmedianr(cumDist.y, lag, fill=NA) + max_score*zoo::rollapplyr(cumDist.y, lag, stats::mad, fill=NA)/0.6745,
      cumDistSignal = ifelse(0.6745*(abs(cumDist.y - zoo::rollmedianr(cumDist.y, lag, fill=NA))/zoo::rollapplyr(cumDist.y, lag, stats::mad, fill=NA)) > max_score, 1, 0),
      RateLower = zoo::rollmedianr(Rate.y, lag, fill=NA) - max_score*zoo::rollapplyr(Rate.y, lag, stats::mad, fill=NA)/0.6745,
      RateUpper = zoo::rollmedianr(Rate.y, lag, fill=NA) + max_score*zoo::rollapplyr(Rate.y, lag, stats::mad, fill=NA)/0.6745,
      RateSignal = ifelse(0.6745*(abs(Rate.y - zoo::rollmedianr(Rate.y, lag, fill=NA))/zoo::rollapplyr(Rate.y, lag, stats::mad, fill=NA)) > max_score, 1, 0)
    ) %>% 
    dplyr::ungroup()
  return(as.data.frame(peak_comparison))
}
