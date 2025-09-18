% make an integer layer, at both 30seconds and 5 minutes with 
% 1- mineral soil forests
% 2- peatlands
% 3 - mangroves
% 4 - salt marsh
% 5 - seagrass
% 6 - binary landmask (WRI land, but none of categories 1-3)
% 0 - none of the above
% 
% 3-5 are the coastal wetlands solution
% 

% Some key assumptions
% cut off tree cover at 2.5%


% load some data at 30 second, make 5 minute versions.
mangroves30sec=processgeotiff('inputdatafiles/mangroves_final.tif');
mangroves5min=aggregate_rate(mangroves30sec,10);
% 
peatlands30sec=processgeotiff('inputdatafiles/peatlands.tif');
peatlands5min=aggregate_rate(peatlands30sec,10);

treecover30sec=processgeotiff('inputdatafiles/HansenTreeCover30s.tif')/100;
treecover5min=aggregate_rate(treecover30sec,10);

binarylandmask_WRI_data=processgeotiff('ProtectForestMapsAndData/data_geotiff/binarylandmask_WRI_data.tif');

saltmarsh30sec=processgeotiff('inputdatafiles/saltmarsh_final.tif');
seagrass30sec=processgeotiff('inputdatafiles/seagrass_prop_regridded.tif');

%

LandCoverLayer=single(treecover30sec>0.025);

LandCoverLayer(peatlands30sec > 0.5) =2;
LandCoverLayer(mangroves30sec > 0.5) =3;

% if land mask layer is finite but equal to zero then give itvalue 6
LandCoverLayer(isfinite(binarylandmask_WRI_data) & LandCoverLayer==0)=6;

% identify salt marsh pixels
% here is a less-inclusive condition that I'm commenting out:
%LandCoverLayer(saltmarsh30sec>0.5)=5;

% here is a more inclusive condition (intended to scoop up pixels where there is more
% saltmarsh than forest)
LandCoverLayer(saltmarsh30sec>treecover30sec/2)=5;



LandCoverLayer(seagrass30sec>0.5)=4;
LandCoverLayer(LandCoverLayer==0 & seagrass30sec>0.025)=4;


globalarray2geotiffwithnodatavalue(LandCoverLayer,'LandAndCoastMap30sec.tif')



