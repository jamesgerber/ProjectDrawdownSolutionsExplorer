% Maps of Mangrove Protect
%
% Note that this is a subset of protectcoastalwetlands - I'm getting this
% on the books so it can feed into the SEAsia report
%
%

MapsAndDataFilename='MangroveMapsAndData';

% here's the code I used to get biomass
% gdalwarp -te -180 -90 180 90 -tr 0.00833333 0.00833333 -r average total_biomass.tif total_biomass1km.tif

% where are mangroves?
mangroves30sec=processgeotiff('inputdatafiles/mangroves_final.tif');
mangroves5min=aggregate_rate(mangroves30sec,10);

% what is biomass?
biomass30sec=processgeotiff('inputdatafiles/total_biomass1km.tif');
biomass5sec=aggregate_rate(biomass30sec,10,'hidden');
% how much carbon in the soil?
% 
 %[ISOList,CountryNameList,AreaLB,BiomassLB,FiveMinuteIndices,SoilCO2map]=MacreadieTable;
 [~,~,~,~,~,SoilCO2map]=MacreadieTable;
warndlg('Macreadie table is not complete - but has SEAsia so leaving it for now');
%TODO - fix this.

% Where is treecover?
treecover30sec=processgeotiff('inputdatafiles/HansenTreeCover30s.tif')/100;
treecover5min=aggregate_rate(treecover30sec,10);


% Assume that whatever percentage loss there is of treecover that this
% percentage loss applies to the mangrove area.

treecoverloss30sec=processgeotiff('inputdatafiles/HansenTreeCoverLoss1km.tif');
treecoverlossrate30sec=treecoverloss30sec./treecover30sec;

%% Intactness
flii30sec=processgeotiff('inputdatafiles/flii_earth_highintegrity_binary_30s_raavg_compressed.tif');
flii5min=aggregate_rate(flii30sec,10);

%% Context Map:
%% Mangrove Area
NSS=getDrawdownNSS;
NSS.cmap='greens_deep';
NSS.caxis=[0 100];
NSS.title='Mangrove Area 2014';
%NSS.DisplayNotes={'Data: Hansen et al.','Downloaded Nov 2024'}
NSS.cbarvisible='on';
NSS.units='% ground cover';

DataToDrawdownFigures(mangroves30sec*100,NSS,'context_mangrovecover',MapsAndDataFilename);
