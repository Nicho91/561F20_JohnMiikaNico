rm ( list = ls() )

library(tidyverse)
library(fields)
library(lubridate)
library(openair)
library(sp)
library(maps)
library(maptools)
library(usmap)

latlong2county <- function(pointsDF) {
  # Prepare SpatialPolygons object with one SpatialPolygon per county
  counties <- map('county', fill=TRUE, col="transparent", plot=FALSE)
  IDs <- sapply(strsplit(counties$names, ":"), function(x) x[1])
  counties_sp <- map2SpatialPolygons(counties, IDs=IDs,
                                     proj4string=CRS("+proj=longlat +datum=WGS84"))
  # Convert pointsDF to a SpatialPoints object 
  pointsSP <- SpatialPoints(pointsDF, 
                            proj4string=CRS("+proj=longlat +datum=WGS84"))
  # Use 'over' to get _indices_ of the Polygons object containing each point 
  indices <- over(pointsSP, counties_sp)
  # Return the county names of the Polygons object containing each point
  countyNames <- sapply(counties_sp@polygons, function(x) x@ID)
  countyNames[indices]
}

load('data/fires.rda')

fires %>% 
  summarise_all(funs(sum(is.na(.))))

fires_clean <- fires %>% 
  mutate(date = as.POSIXct(strptime(paste(FIRE_YEAR, DISCOVERY_DOY), format="%Y %j", tz=""))) %>% 
  mutate(cont_date = as.POSIXct(strptime(paste(FIRE_YEAR, CONT_DOY), format="%Y %j", tz=""))) %>% 
  filter(STAT_CAUSE_DESCR != "Missing/Undefined") %>%
  select(-c(OBJECTID, FOD_ID, SOURCE_SYSTEM_TYPE:LOCAL_INCIDENT_ID, ICS_209_INCIDENT_NUMBER:DISCOVERY_DOY, CONT_DATE:CONT_DOY, FIPS_CODE, FIPS_NAME, Shape)) %>% 
  cutData(type='season') %>% 
  mutate(COUNTY = latlong2county(data.frame(LONGITUDE, LATITUDE))) %>%
  mutate(human = ifelse(STAT_CAUSE_DESCR != "Lightning", 1, 0))

# save(fires_clean, file='data/fires_clean.rda')
# write to csv if need 

fires_clean %>% 
  summarise_all(funs(sum(is.na(.))))

fires_clean_county <- fires_clean %>% 
  filter(!is.na(COUNTY))

# save(fires_clean_county, file='data/fires_clean_county.rda')
# write to csv if need be

pa <- fires_clean %>% 
  filter(STATE %in% c('PA')) %>% 
  select(LONGITUDE, LATITUDE, FIRE_SIZE)
trans_pa <- usmap_transform(pa)

pa_map <- plot_usmap('counties', include=c('PA'), labels=TRUE, label_color='black',) +
  geom_point(data = trans_pa, aes(x = LONGITUDE.1, y = LATITUDE.1, size = FIRE_SIZE),
             color = "red", alpha = 0.25) +
  labs(title = "Fire Size",
       subtitle = "Pennsylvania",
       size = "Fire Size") +
  theme(legend.position = "right") + 
  scale_size(breaks = round(seq(1000, 3800, length.out = 10)))
pa_map$layers[[2]]$aes_params$size <- 3









