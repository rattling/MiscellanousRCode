#ADD AN ATTRIBUTE FROM CSO 2011 TO THE SHAPE FILE AND DISPLAY CHLOROPLETH OF IT
#John Curry 26th November 2017 
#Based heavily on examples below 
library(rgdal)
library(classInt)
library(RColorBrewer)

rootPath = <INSERT ROOT PATH>;

# https://mgimond.github.io/Spatial/data-manipulation-in-r.html
####################################################################################
#EXAMPLE BELOW FROM WEB LINK BELOW FOR PLOTTING CHLOROPLETH FOR SHAPE FILE
####################################################################################

tmp <- tempfile()
download.file("http://colby.edu/~mgimond/Spatial/Data/Income_schooling.zip", destfile = tmp)
unzip(tmp, exdir = ".")

s1 <- readOGR(".", "Income_schooling")


# Generate breaks
brks <-  classIntervals(s1$Income, n = 4, style = "quantile")$brks
brks[length(brks)] <- brks[length(brks)] + 1

# Define color swatches
pal  <- brewer.pal(4, "Greens")

# Generate the map
spplot(s1, z="Income", at = brks, col.regions=pal)



####################################################################################
#DO THE SAME THING WITH CSO DATA ON A FIELD SUCH AS VACANT2011 ALREADY ON THE SHAPE FILE
####################################################################################
#Note - takes minutes to load up graph and not so clear 
#Better to operate on higher level e.g. county level shape file and associated table


dataPath=paste0(rootPath, 'Inputs/')
ogrInfo('C:/Users/JohnArm/Documents/GitHub/GeoSpatial/Inputs','Census2011_Small_Areas_generalised20m')
shpFile=paste0(dataPath, 'Census2011_Small_Areas_generalised20m.shp')
csoData=paste0(dataPath, 'AllThemesTablesSA.csv')

s2 <- readOGR(shpFile)

# Generate breaks
brks <-  classIntervals(s2$VACANT2011, n = 4, style = "quantile")$brks
brks[length(brks)] <- brks[length(brks)] + 1

# Define color swatches
pal  <- brewer.pal(4, "Greens")

spplot(s2, z="VACANT2011", at = brks, col.regions=pal)


####################################################################################
#ADD A CALCULATED FIELD TO THE CSO SHAPE FILE AND PLOT THAT
####################################################################################
# http://blog.revolutionanalytics.com/2009/11/choropleth-challenge-result.html
# census data

Census2011 <- data.frame(read.csv(csoData))

attach(Census2011)
Age18_44  <- ( T1_1AGE18M + T1_1AGE19M + T1_1AGE20_24M + T1_1AGE25_29T + T1_1AGE30_34T + T1_1AGE35_39T + T1_1AGE40_44T ) 
Age45_64  <- ( T1_1AGE45_49T + T1_1AGE50_54T + T1_1AGE55_59T + T1_1AGE60_64T ) 
Age65over <- ( T1_1AGE65_69T + T1_1AGE70_74T + T1_1AGE75_79T + T1_1AGE80_84T + T1_1AGEGE_85T ) 
Arthro <- (Age18_44*.62*.7)+(Age45_64*.24*.29)+(Age65over*.14*.50)

#THIS IS BIZARRE GEOGID HAS A REALLY WEIRD NAME SO ADD GEOGID COL AND GET RID OF THAT
#AND PUT IT INTO A NEW COL CALLED GEOGID
joindata$GEOGID=joindata$Census2011.ï..GEOGID
joindata=joindata[c(2,3)]

s3 <- merge(s2, joindata, by.x="GEOGID", by.y="GEOGID")


# Generate breaks
brks <-  classIntervals(s3$Arthro, n = 4, style = "quantile")$brks
brks[length(brks)] <- brks[length(brks)] + 1

# Define color swatches
pal  <- brewer.pal(4, "Greens")

spplot(s3, z="Arthro", at = brks, col.regions=pal)



