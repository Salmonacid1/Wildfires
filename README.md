# Climate Change and Wildfires in California 

This repository was created by Samantha Almonacid, Audrey Kang, and Kelly Shin as 
a final project for our data exploration and analysis course (EESC4464). The provided
code analyzes the climatology of California's climate divisions and the Sequoia Forest,
and projects future trends in these location's climatology up to the year 2050.

## Data Availability Statement

The data used in this analysis can be found at the following sites, and accesed with the
directions below. 

The data on the acres burned by wildfires in California are available at 
https://www.fire.ca.gov/media/11397/fires-acres-all-agencies-thru-2018.pdf. 

Spatial fire perimeter data was found at https://firms.modaps.eosdis.nasa.gov/download/. To get data specifically for California go to download request, select "Custom Region" and "Map". 
Once brought to the map, select "Draw Polygon", and outline the boundaries of California. 

California climate division temperature and precipitation data came from https://www.ncdc.noaa.gov/cag/divisional/time-series/0401/tavg/all/1/1950-2021. 
To get the temperature data select the following specifications: "Average Temperature", "All Months", "January", "1950", "2021", "California", and the climate
division. To get the precipitation data follow the same specifications replacing "Average Temperature" with "Precipitation". 

Climatology data for Lodgepole Station was downloaded at https://www.ncdc.noaa.gov/cdo-web/search. To access this data use the follow specifications: 
"Daily Summaries", "1950-01-01 to 2021-05-11", "Stations", "LODGEPOLE, CA US". After hitting search, download the two datasets for Lodgepole Station. They have Station IDs of
GHCND:USC00045028 and GHCND:USC00045026. 

## Analysis
All of the code is found under the .m file title "Code_For_Analysis". Within this file, the code loads all of the datasets, plots and projects future
and historical climatology trends, and examines the acres burned by historical wildfires in California. 

The code relies of a function called "Time Conversion" which is included in the repository. 

