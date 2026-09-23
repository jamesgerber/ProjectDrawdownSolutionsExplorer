% I've worked through a version of this, but now "_updated"
% because (a) I'd like to have a more unified approach to doing Forest
% Restoration for both Drawdown for nature (formerly Nexus) and Drawdown
% Explorer.  Also, subsequent to the challenges I had with zonal stats for
% protect forests I'm pretty sure that the previous version wasn'tn going
% to check out, so best, I think, to just redo it.


THIS CODE NOW OBSOLETE ... NEED TO CARRY OVER FROM RESTOREFORESTS_ANALYSISFORDRAWDOWNFORNATURE.M

%Here are the sections:

% 1. Extent (adoption) for Explorer
% 2. Extent (adoption) for D4N
% 3. Effectiveness for Explorer
% 4. Effectiveness for D4N
% 5. zonal stats for Explorer
%   - tropical, etc
%  Agree with published solution?
%  if yes, then proceed, else debug.
%
% 6. zonal stats for D4N
% 



%x=pgt([ DataProductsDir  'ext/Carbon/ForestRegrowth_Busch/BuschCarbon5min.mat']);
% /Users/jsgerber/DataProducts/ext/Carbon/ForestRegrowth_Busch/NaturalRegrowthCarbon_Busch_tonsCperha_after30years.tif
% /Users/jsgerber/DataProducts/ext/Carbon/ForestRegrowth_Busch/NaturalRegrowthMoreCostEffective_Busch.tif
% /Users/jsgerber/DataProducts/ext/Carbon/ForestRegrowth_Busch/PlantationCarbon_Busch_tonsCperha_after30years.tif
% /Users/jsgerber/DataProducts/ext/Carbon/ForestRegrowth_Busch/PlantationRegrowthMoreCostEffective_Busch.tif


%% Extent (for Explorer)

% this was from MatlabVersionOfAverysFesenmyerReductionCode
%ExtentForExplorer30s=pgt('AdoptionPotential_naturalregen_ExplorerCalculation30s.tif');
ExtentForExplorer30s=pgt(unSymLink('~/DataProducts/ext/Carbon/ForestRegrowth_Busch/AdoptionPotential_naturalregen_ExplorerCalculation30s.tif'));
ExtentForExplorer=aggregate_rate(ExtentForExplorer30s,10,'hidden');
ExtentForExplorer(isnan(ExtentForExplorer))=0;
ExtentForD4N30s=ExtentForExplorer30s;  % let's save this now.
% 
% % For explorer, ought to exclude Mangroves - since those are other
% solutions.  However, in practice there are very few areas (based on
% observation) where forest restoration overlaps with areas with Mangroves.
% So, for mapping purposes (which is what's going on in this script) I'm
% not going to remove mangroves.
% MangroveMap=pgt('~/shareddrives/Solutions/FOLU/protect coastal wetlands (on website)/Mapping/datainputfiles/mangroves_final.tif');
% MangroveMap5min=aggregate_rate(MangroveMap,10,'hidden');
% 
% % need to exclude natural Grasslands
% % we'll exclude Parente natural grasslands
% 
ParenteNatural30sec=processgeotiff([NexusDataDrive 'ProcessedData/Landcover/ParenteGrasslands/grassland_class2_2020.tif']);
% ParenteCultivated5min=processgeotiff([NexusDataDrive 'ProcessedData/Landcover/ParenteGrasslands/grassland_class1_2020_5min.tif']);
% 
% Extent for explorer is not allowed to exceed whatever is left over after
% you set aside for Natural Grasslands.  (Of course, this shouldn't be necessary,
% hopefully this was removed by Fesenmyer, but let's make sure so that maps
% look consistent.)
ExtentForExplorer=max(1-ParenteNatural30sec,ExtentForExplorer30s);



% 
% % now remove plantation more cost effective
PlantationMoreCostEffective=pgt([ DataProductsDir  'ext/Carbon/ForestRegrowth_Busch/PlantationRegrowthMoreCostEffective_Busch.tif']);
ExtentForExplorerExtentForExplorer(PlantationMoreCostEffective==1)=0;
% 

%%%%%%%%%%%%%%%%%%%%%
%% Effectivness
%%%%%%%%%%%%%%%%%%%%%

%     %%%%%%%%%%%%%%%%%%%%%
%     %%  Correction factor for above ground v belowground
%     %%%%%%%%%%%%%%%%%%%%%

% First get correction factor for above ground v belowground (we only have ABG,
% let's use spawn to get the correction factor.

spawnagc=pgt([NexusDataDrive '/ProcessedData/Carbon/Biomass_Spawn/data/aboveground_biomass_carbon_2010_5min_MgCperha.tif']);
spawnbgc=pgt([NexusDataDrive '/ProcessedData/Carbon/Biomass_Spawn/data/belowground_biomass_carbon_2010_5min_MgCperha.tif']);

accountforBGCcorrectionfactor=(1+spawnbgc./spawnagc);
accountforBGCcorrectionfactor(accountforBGCcorrectionfactor>5)=5;

%     %%%%%%%%%%%%%%%%%%%%%
%     %%  effectiveness for Explorer 
%     %%%%%%%%%%%%%%%%%%%%%
% for Explorer, follow Solution Methods
% Explorer: 
%    Low Intensity Restoration (Natural)
x=pgt([ DataProductsDir  'ext/Carbon/ForestRegrowth_Robinson/AboveGroundCarbon_After30years_tonsCperha_Robinson.tif']);
LowIntensityRestorationtonCperhaperyear=x/30.*accountforBGCcorrectionfactor;

%    High Intensity (Planted forests)
x=pgt([ DataProductsDir  'ext/Carbon/ForestRegrowth_Busch/PlantationCarbon_Busch_tonsCperha_after30years.tif']);
HighIntensityRestorationtonCperhaperyear=x/30.*accountforBGCcorrectionfactor;


% upload Busch natural regrowth

x=pgt([ DataProductsDir  'ext/Carbon/ForestRegrowth_Busch/NaturalRegrowthCarbon_Busch_tonsCperha_after30years.tif']);
LowIntensityRestorationtonCperhaperyear_Busch=x/30.*accountforBGCcorrectionfactor;

% I propose for mapping ... harmonized maps of Rob and JB



     %%%%%%%%%%%%%%%%%%%%%
     %%  effectiveness for Drawdown for Nature
     %%%%%%%%%%%%%%%%%%%%%

     % CombinedLowIntensity:  Busch where that is defined and non-0, else Robinson
     % if Busch (aka JB) is not defined or 0, use Robinson
     CombinedLowIntensity=LowIntensityRestorationtonCperhaperyear_Busch;
     ii=isnan(CombinedLowIntensity) | CombinedLowIntensity==0;
     CombinedLowIntensity(ii)=LowIntensityRestorationtonCperhaperyear(ii);

     %  Now, any place where High Intensity restoration is zero, let's swap
     %  in the LowIntensity.
     InclusiveHighIntensity=HighIntensityRestorationtonCperhaperyear;
     ii=InclusiveHighIntensity==0 | isnan(InclusiveHighIntensity);
     InclusiveHighIntensity(ii)=CombinedLowIntensity(ii);

%%%%%%%%%%%%%%%%%%%%%
%% Zonal statistics
%%%%%%%%%%%%%%%%%%%%%
%%
EffectivenessLow=LowIntensityRestorationtonCperhaperyear*3.667;
EffectivenessHigh=HighIntensityRestorationtonCperhaperyear*3.667;
currentadoptionraster=datablank;

highadoptionraster=ExtentForExplorer*.75;
lowadoptionraster=ExtentForExplorer*0.5;
disp('Low Intensity Effectiveness')
ClimateZoneStatsCalcs(EffectivenessLow,currentadoptionraster,lowadoptionraster,highadoptionraster)

disp('High Intensity Effectiveness')
EffectivenessHigh(EffectivenessHigh==0)=nan;
EffectivenessHigh(PlantationMoreEffective==1)=nan;

ClimateZoneStatsCalcs(EffectivenessHigh,currentadoptionraster,lowadoptionraster,highadoptionraster)
%%

%% Mapping narrative, Drawdown Explorer:

% context 1: Fesenmyer constrained

















% Effectiveness has been calculated as part of Drawdown For Nature Protect
% Forests solution.

x=load([NexusDataDrive '/OriginalData/Carbon/ForestRegrowth_Busch/BuschCarbon5min.mat']);
totalcarbon=x.totalcarbon;
plantationcarbon=totalcarbon;
y=load([NexusDataDrive '/OriginalData/Carbon/ForestRegrowth_Robinson/RobinsonCarbon5min.mat']);
naturalregrowthcarbon=y.carbon;


carbonstockchangeperyearperha=max(plantationcarbon,naturalregrowthcarbon)/30;


carbonstockchangeperyearperha_co2eq=carbonstockchangeperyearperha.*accountforBGCcorrectionfactor*3.667;

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