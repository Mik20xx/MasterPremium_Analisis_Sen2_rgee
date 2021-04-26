#install packages 
install.packages('googledrive')
install.packages('rgee') 

library(googledrive)
library(rgee)

# rtools
Sys.which('make')

#install packages of rgee
ee_install()

#initializing rgee 
ee_Initialize('juniorcalvo')

ee_users()
ee_user_info()
#clean a credentials
ee_clean_credentials('junior')

#loading a satellite image collection of GEE
sen2<-ee$ImageCollection('COPERNICUS/S2')$
  filterDate('2020-04-01', '2021-04-01')$
  filterBounds(ee$Geometry$Point(-76.924989, -11.925505))$
  filterMetadata('CLOUDY_PIXEL_PERCENTAGE', 'less_than', 5)

ee_get_date_ic(sen2)
#loading a satellite image of GEE
s2<-'COPERNICUS/S2/20210326T151659_20210326T151713_T18LTM' %>% 
  ee$Image() %>%
  ee$Image$select(c( 'B11', 'B8A', 'B2'))
#display of information
ee_print(s2, img_band = 'B8A')

#display
Map$centerObject(s2)
Map$addLayer(s2, visParams = list(min=250,
                                  max=2500,
                                  gamma=1))
