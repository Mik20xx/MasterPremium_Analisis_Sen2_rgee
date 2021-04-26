library(sp)
library(cptcity)
library(rgee)
library(sf)
library(dplyr)
library(raster)
library(geojson)
setwd('E:/HP I5 DORADA/DISCO C/MASTERGIS 01/MasterPrimiun/ANALIS DE IMAGENES SENTINEL 2 CON rgee')

ar<-st_read('Archivo/SHP/ZonaHuascaran.shp')
plot(ar)
ar_ee<-st_read('Archivo/SHP/ZonaHuascaran.shp') %>%
  sf_as_ee()
Map$centerObject(ar_ee, zoom = 12)
Map$addLayer(ar_ee)

sen<-ee$ImageCollection('COPERNICUS/S2')$
  filterDate('2020-04-01', '2021-04-01')$
  filterBounds(ee$Geometry$Point(-77.624989, -9.125505))$
  filterMetadata('CLOUDY_PIXEL_PERCENTAGE', 'less_than', 5)

ee_get_date_ic(sen)

im_2sen20<-ee$Image('COPERNICUS/S2/20200617T152651_20200617T152645_T18LTQ')$
  clip(ar_ee)
  
visParams<-list(min=450,
                max=3500,
                bands=c('B11', 'B8A', 'B2'),
                gamma=0.8)
Map$centerObject(im_2sen20)
Map$addLayer(im_2sen20, visParams)

#Calculo del NDVI
NDVI<-im_2sen20$normalizedDifference(c("B8", "B4"))

#display
Map$centerObject(NDVI)
Map$addLayer(eeObject =NDVI,  visParams = list(
  min = 0.2 ,
  max = 0.8 ,
  palette = cpt("grass_ndvi", 10)
))
#Calculo del NDSI

NDSI<-im_2sen20$normalizedDifference(c('B3', 'B11'))
col<-colorRampPalette(c('blue', 'white'))
Map$centerObject(NDSI)
Map$addLayer(eeObject =NDSI,  visParams = list(
  min = 0.2 ,
  max = 0.8 ,
  palette = col(2)
))

ee_print(NDSI)
lo_ndsi<-ee_as_raster(NDSI)

writeRaster(lo_ndsi, 'Result/Huascaran.tif')
plot(lo_ndsi, zoom=12)

