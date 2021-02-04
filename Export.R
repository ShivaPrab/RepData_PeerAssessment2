library(xlsx)
library(sqldf)
library(data.table)

# Storm Data Documentation 
# https://d396qusza40orc.cloudfront.net/repdata%2Fpeer2_doc%2Fpd01016005curr.pdf

StormData <- read.csv("Data/repdata_data_StormData.csv.bz2"
                      , header = TRUE
                      , sep = ",")

StormData <- subset(StormData, select = -c(StormData$STATE__
                                         , StormData$COUNTY)) 

write.csv2(StormData,
"/Users/shivaprab/Desktop/Files/Coding/R/Reproducable Data/Peer_Assessment_2/StormData.csv",
           row.names = FALSE) 

# Since Excel Breaks after 1M rows, and this is getting pretty close, 
# I think it'd be worthwhile to subset in meaningful ways. The first way is 
# through Region 

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

# The 4 regions 'only' add up to 883,623 while the StormData
# has 902,297, so where are the other 18,674 observations? 


#Now, we need to answer the question of what happened to the other 18,674 
#observations still trapped in the StormData DataFrame 

US_Observations <- rbind(NorthEast, MidWest, South, West)

#Looks like the "Other Observations" are ones in US Territories, including 
#American Samoa, Guam, Puerto Rico, etc. 

Other_Observations <- sqldf('SELECT *
                            FROM StormData
                            EXCEPT SELECT *
                            FROM US_Observations')

# So now we have 5 regions 

