airports <- read.csv("airports.dat", header = FALSE, stringsAsFactors = FALSE)
colnames(airports) <- c("ID", "name", "city", "country", 
                        "IATA_FAA", "ICAO", "lat", "lon", 
                        "altitude", "timezone", "DST", "tzdb",
                        "type", "source")

head(airports)

routes <- read.csv("routes.dat", header = FALSE, stringsAsFactors = FALSE)
colnames(routes) <- c("airline", "airlineID", "sourceAirport", 
                        "sourceAirportID", "destinationAirport",
                        "destinationAirportID", "codeshare",
                        "stops", "equipment")

library(plyr)
departures <- ddply(routes, .(sourceAirportID), "nrow")

names(departures)[2] <- "departures"

airports_with_departures <- merge(airports, departures, by.x = "ID", by.y = "sourceAirportID")

library(ggmap)

map <- get_map(location = "USA", zoom = 3)

ggmap(map) + geom_point(aes(x=lon, y = lat, size=sqrt(departures)), data=airports_with_departures, alpha=0.5)

