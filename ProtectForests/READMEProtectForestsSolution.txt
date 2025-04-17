README file for Protect Forests and Woodlands solution.

This solution relies on data from multiple sources; input files and sources:

flii_earth_highintegrity_binary_30s_raavg_compressed.tif — this file was created by taking 
the original flii_earth.tif and converting it to a binary raster where pixels with values >9600 were converted to 1s 
and all others converted to 0s. This version was then downsampled to 1km resolution using gdalwarp and the average 
resampling algorithm.


raster_wdpa_iucncats_ItoVI_alltouchedFalse_1km.tif — this file was created by rasterizing the original vector 
version of the WDPA data. The original polygonal shapefiles were combined then limited to those with “IUCN_CAT” 
values from I-VI. This was then rasterized to a 1km resolution and only polygons whose center fell within a pixel 
were coded as protected areas (pixels with a value of 1).