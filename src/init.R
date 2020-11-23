library(DBI)
library(RSQLite)
library(tidyverse)
library(purrr)

#----nice fresh start----#
rm( list = ls() )


#-----make sure fires.sqlite is in current directory or replace below; create connection----#
# fire_connection <- dbConnect(SQLite(), '../data/fires.sqlite')


#-----print out a list of all the tables----#
# list_of_tables <- as_tibble(dbListTables(fire_connection)) %>% modify_if(is.factor, as.character)
# (list_of_tables <- list_of_tables$value)


#-----tables that have rows (observations) within them-----#
# valid_tables <- list_of_tables[-c(1, 3, 5, 9, 20, 24, 26:33)]


#-----assign each valid table to a matching variable name being certain of lowercase letters---#
# for (table in valid_tables) {
#   assign(tolower(table), dbReadTable(fire_connection, table))
# }
# dbDisconnect(fire_connection)
# rm(fire_connection, list_of_tables, table, valid_tables)


#----create a single rda file for the database----#
# save(list=ls(), file='wildfires_data.rda')
load(file = '../data/wildfires_data.rda')


#----Save the different groups of variables by name similarity---#
# save(fires, file='../data/fires.rda')
# save(list=ls()[2:6], file='../data/geometry_columns.rda')
# save(list=ls()[7:10], file='../data/idx_fires_shape.rda')
# save(list=ls()[12:15], file='../data/spatial_ref_sys.rda')
# save(list=ls()[17:19], file='../data/vector_layers.rda')
# save(list=ls()[c(11,16)], file='../data/misc.rda')












