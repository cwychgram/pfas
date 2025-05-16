library(bslib)
library(cartography)
library(colourvalues)
library(data.table)
library(dplyr)
library(leafgl)
library(leaflet)
library(leaflet.extras)
library(sf)
library(shiny)
library(stringr)

# df <- fread(
#   "data/nw_2010tract_pfas_16April2025_nhgis.csv",
#   colClasses = c(geoid_2010_tract = "character")
# ) %>%
#   dplyr::select(
#     geoid_2010_tract, 
#     starts_with(
#       c(
#         "pfhxs",
#         "pfna",
#         "pfoa",
#         "pfos")
#     ),
#     -ends_with("popserved")
#   ) 
# 
# tract_centroids <- fread(
#   "data/tract_centroids.csv"
# ) %>%
#   mutate(
#     GEOID10 = str_pad(
#       GEOID10,
#       width = 11,
#       side = "left",
#       pad = "0"
#     )
#   )
# 
# df <- df %>%
#   left_join(
#     tract_centroids,
#     by = c(
#       "geoid_2010_tract" = "GEOID10"
#     )
#   )
# 
# write.csv(df, "data/data_tidy.csv", row.names = FALSE)

df <- read.csv("data/data_tidy.csv")
