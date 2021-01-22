library(data.table)
library(ggplot2)
library(sqldf)

StormData <- read.csv("Data/repdata_data_StormData.csv.bz2"
                                      , header = TRUE)

# Lets group the data by Region (accepted divisions by the US Census Bureau
# Link https://www2.census.gov/geo/pdfs/maps-data/maps/reference/us_regdiv.pdf ) 

NorthEast <- sqldf('SELECT *
                   FROM StormData
                   WHERE STATE = "CT" 
                      OR STATE = "ME"
                      OR STATE = "MA"
                      OR STATE = "NH"
                      OR STATE = "RI"
                      OR STATE = "VT"
                      OR STATE = "NJ"
                      OR STATE = "NY"
                      OR STATE = "PA"')


MidWest <- sqldf('SELECT *
                 FROM StormData
                 WHERE STATE = "IN"
                    OR STATE = "IL"
                    OR STATE = "MI"
                    OR STATE = "OH"
                    OR STATE = "WI"
                    OR STATE = "IA"
                    OR STATE = "KS"
                    OR STATE = "MN"
                    OR STATE = "MO"
                    OR STATE = "NE"
                    OR STATE = "ND"
                    OR STATE = "SD"') 
                    
South <- sqldf('SELECT *
               FROM StormData
               WHERE STATE = "DE"
                  OR STATE = "DC"
                  OR STATE = "FL"
                  OR STATE = "GA"
                  OR STATE = "MD"
                  OR STATE = "NC"
                  OR STATE = "SC"
                  OR STATE = "VA"
                  OR STATE = "WV"
                  OR STATE = "AL"
                  OR STATE = "KY"
                  OR STATE = "MS"
                  OR STATE = "TN"
                  OR STATE = "AR"
                  OR STATE = "LA"
                  OR STATE = "OK"
                  OR STATE = "TX"')

West <- sqldf('SELECT *
              FROM StormData
              WHERE STATE = "AZ"
                 OR STATE = "CO"
                 OR STATE = "ID"
                 OR STATE = "NM"
                 OR STATE = "MT"
                 OR STATE = "UT"
                 OR STATE = "NV"
                 OR STATE = "WY"
                 OR STATE = "AK"
                 OR STATE = "CA"
                 OR STATE = "HI"
                 OR STATE = "OR"
                 OR STATE = "WA"')

# okay.. but this leaves two problems, first that the "south" region is HUGE! 
# including states like Delaware and Maryland 
# Second that the 4 regions 'only' add up to 883,623 while the StormData
# has 902,297, so where are the other 18,674 observations? 

# To answer problem 1, we can subset further into geographic region
# i.e. splitting the North East into the "New England" and "Mid Atlantic" regions

NewEngland <- sqldf('SELECT *
                    FROM NorthEast
                    WHERE STATE = "CT"
                       OR STATE = "ME"
                       OR STATE = "MA"
                       OR STATE = "NH"
                       OR STATE = "RI"
                       OR STATE = "VT"')

MidAtlantic <- sqldf('SELECT *
                     FROM NorthEast
                     WHERE STATE = "NJ"
                        OR STATE = "NY"
                        OR STATE = "PA"')

EastNorthCentral <- sqldf('SELECT *
                          FROM MidWest
                          WHERE STATE = "IN"
                             OR STATE = "IL"
                             OR STATE = "MI"
                             OR STATE = "OH"
                             OR STATE = "WI"')

WestNorthCentral <- sqldf('SELECT *
                          FROM MidWest
                          WHERE STATE = "IA"
                             OR STATE = "KS"
                             OR STATE = "MN"
                             OR STATE = "MO"
                             OR STATE = "NE"
                             OR STATE = "ND"
                             OR STATE = "SD"')

SouthAtlantic <- sqldf('SELECT *
                       FROM South
                       WHERE STATE = "DE"
                          OR STATE = "DC"
                          OR STATE = "FL"
                          OR STATE = "GA"
                          OR STATE = "MD"
                          OR STATE = "NC"
                          OR STATE = "SC"
                          OR STATE = "VA"
                          OR STATE = "WV"')

EastSouthCentral <- sqldf('SELECT *
                          FROM South
                          WHERE STATE = "AL"
                             OR STATE = "KY"
                             OR STATE = "MS"
                             OR STATE = "TN"')

WestSouthCentral <- sqldf('SELECT *
                          FROM South
                          WHERE STATE = "AR"
                             OR STATE = "LA"
                             OR STATE = "OK"
                             OR STATE = "TX"')

Mountian <- sqldf('SELECT *
                  FROM West
                  WHERE STATE = "AZ"
                    OR STATE = "CO"
                    OR STATE = "ID"
                    OR STATE = "NM"
                    OR STATE = "MT"
                    OR STATE = "UT"
                    OR STATE = "NV"
                    OR STATE = "WY"')

Pacific <- sqldf('SELECT *
                 FROM West
                 WHERE STATE = "AK"
                    OR STATE = "CA"
                    OR STATE = "HI"
                    OR STATE = "OR"
                    OR STATE = "WA"')

# A few sanity checks 

21202 + 51359
112607 + 210396
130683 + 88744 + 174955
67826 + 25851


#Now, we need to answer the question of what happened to the other 18,674 
#observations still trapped in the StormData DataFrame 

US_Observations <- rbind(NorthEast, MidWest, South, West)

#Looks like the "Other Observations" are ones in US Terrtories, including 
#American Samoa, Guam, Puerto Rico, etc. 
Other_Observations <- sqldf('SELECT *
                            FROM StormData
                            EXCEPT SELECT *
                            FROM US_Observations')
883623 + 18674

#Question 1: What events are the most harmful with respect to population health? 


#Question 2: What types of events have the greatest economic consequences? 

hist(Pacific$INJURIES)