%  context maps are same as for Protect Forests

% Effectivness has been calculated as part of Drawdown For Nature Protect
% Forests solution.

x=load([NexusDataDrive '/OriginalData/Carbon/ForestRegrowth_Busch/BuschCarbon5min.mat']);
totalcarbon=x.totalcarbon;
plantationcarbon=totalcarbon;
y=load([NexusDataDrive '/OriginalData/Carbon/ForestRegrowth_Robinson/RobinsonCarbon5min.mat']);
naturalregrowthcarbon=y.carbon;


carbonstockchangeperyearperha=max(plantationcarbon,naturalregrowthcarbon)/30;

% correct for above ground v belowsground

spawnagc=pgt([NexusDataDrive '/ProcessedData/Carbon/Biomass_Spawn/data/aboveground_biomass_carbon_2010_5min_MgCperha.tif']);
spawnbgc=pgt([NexusDataDrive '/ProcessedData/Carbon/Biomass_Spawn/data/belowground_biomass_carbon_2010_5min_MgCperha.tif']);


correctionfactor=(1+spawnbgc./spawnagc);
correctionfactor(correctionfactor>5)=5;

carbonstockchangeperyearperha_co2eq=carbonstockchangeperyearperha.*correctionfactor*3.667;

%PS = ParameterStructure
% % fprintf(fid,'[MapConstants]\n')
% % fprintf(fid,'input_tif_filename = %s\n', PS.input_tif_filename);
% % fprintf(fid,'MAPS_DIR = %s\n', PS.MAPS_DIR);
% % fprintf(fid,'map_filename = %s\n', PS.map_filename);
% % fprintf(fid,'data_min = %s\n', PS.data_min);
% % fprintf(fid,'data_max = %s\n', PS.data_max);
% % fprintf(fid,'cbar_title = %s\n',cbar_title) ;
% % fprintf(fid,'cbar_units = %s\n',units) ;
% % fprintf(fid,'extend_cbar = %s\n', PS.extend_cbar);

clear PS
PS.MAPS_DIR=[uwd filesep 'MapsAndData2/'];
PS.map_filename='carbonstockchangeperyear';
cmap=ExplorerEffectiveness1;
PS.cmap_string=cmap;
PS.data_min='0';
PS.data_max='4';

PS.cbar_title='carbon stock change (tons CO_2 eq/ha/yr)';
PS.cbar_units='tons C / ha / yr';
PS.extend_cbar='max';
wd=pwd;
[OutputData]=MakeAlexStyleFigsNew(carbonstockchangeperyearperha_co2eq,PS);
cd(wd)

NSS=getDrawdownNSS;
NSS.cmap=ExplorerEffectiveness1;
NSS.caxis=[0 20];
NSS.title='carbon stock change';
NSS.units='tons C / ha / yr';
NSS.panoplytriangles=[0 1];
DataToDrawdownFigures(carbonstockchangeperyearperha_co2eq,NSS,'carbonstockchangeperyear',...
    [uwd filesep 'MapsAndData2/']    )


% Low ambition adoption:
% first let's get Fesenmyer constrained

% here are notes/code from when I processed that earlier in Nexus
% [long,lat,raster]=pgt('~/nexus/NexusDataDrive/OriginalData/Landcover/Fesenmyer_RefinedReforestation/27335799/reforestation_map/output_tifs/constrained_reforestation.tif');
% gdalwarp -te -180 -90 180 90 -t_srs EPSG:4326  -tr 0.0083333333 0.00833333333 -r average constrained_reforestation.tif constrained_reforestation_30sec.tif
% fesen30s=pgt('constrained_reforestation_30sec.tif');
% peat30s=pgt('peatlands.tif');
% fesen30s=max(fesen30s-peat30s,0);
% fesen_minuspeat_5min=aggregate_rate(fesen30s,10,'hidden');
% globalarray2geotiff(fesen_minuspeat_5min,'FesenConstrainedLessPeat_5min.tif')

FesenConstrainedLessPeat=pgt(['~/nexus/NexusDataDrive/ProcessedData/Solutions/Reforestation/FesenConstrainedLessPeat_5min.tif']);

% need to exclude Mangroves

MangroveMap=pgt('~/shareddrives/Solutions/FOLU/protect coastal wetlands (on website)/Mapping/datainputfiles/mangroves_final.tif');
MangroveMap5min=aggregate_rate(MangroveMap,10,'hidden');

% need to exclude places better for plantation (note - this exclusion is
% for the DE solution, not the DFN solution.)

% need to exclude grasslands.