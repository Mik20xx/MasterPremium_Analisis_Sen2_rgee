#loading packages
library(sp)
library(cptcity)
library(rgee)
library(sf)
library(raster)

#address the folder where we are working
setwd('E:/HP I5 DORADA/DISCO C/MASTERGIS 01/MasterPrimiun/ANALIS DE IMAGENES SENTINEL 2 CON rgee')

#loading area
ar<-st_read('Archivo/SHP/ZonaHuascaran.shp')
plot(ar)

# Local to GEE
ar_ee<-ar %>%
  sf_as_ee()

#display in GEE 
Map$centerObject(ar_ee, zoom = 12)
Map$addLayer(ar_ee)

#loading a satellite image collection of GEE
sen<-ee$ImageCollection('COPERNICUS/S2')$
  filterDate('2020-04-01', '2021-04-01')$
  filterBounds(ee$Geometry$Point(-77.624989, -9.125505))$
  filterMetadata('CLOUDY_PIXEL_PERCENTAGE', 'less_than', 5)

#Display ID
ee_get_date_ic(sen)

#loading a satellite image of GEE
im_2sen<-ee$Image('COPERNICUS/S2/20200617T152651_20200617T152645_T18LTQ')$
  clip(ar_ee)

visParams<-list(min=450,
                max=3500,
                bands=c('B11', 'B8A', 'B2'),
                gamma=0.8)
#Display
Map$centerObject(im_2sen)
Map$addLayer(im_2sen, visParams)

#NDVI calculation
NDVI<-im_2sen$normalizedDifference(c("B8", "B4"))

#display
Map$centerObject(NDVI)
Map$addLayer(eeObject =NDVI,  visParams = list(
  min = 0.2 ,
  max = 0.8 ,
  palette = cpt("grass_ndvi", 10)
))

#NDSI calculation

NDSI<-im_2sen$normalizedDifference(c('B3', 'B11'))

#Palette of snow
col<-colorRampPalette(c('blue', 'white'))

#Display
Map$centerObject(NDSI)
Map$addLayer(eeObject =NDSI,  visParams = list(
  min = 0.2 ,
  max = 0.8 ,
  palette = col(2)
))

#Display of information
ee_print(NDSI)

#GEE to local
lo_ndsi<-ee_as_raster(NDSI)

# Export raster 
writeRaster(lo_ndsi, 'D:/MASTERGIS/Analisis Sen2 rgee/Result/ZonaHuascaran.tif')
plot(lo_ndsi, zoom=12)

