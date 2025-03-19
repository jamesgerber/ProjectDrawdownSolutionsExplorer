% I just saved a copy of this to 'MakeProductionMapsAndTiffs'.  I am
% dictating this comment , so let's see how this works. The main changes I
% am making here are to use some codes that I recently wrote that I made
% the making of data files and in graphs, and I'm also going to use the
% drawdown color ramps that Alex has put together and I am going to get
% this code under revision control.   

LocationOfMapsFromAvery=['./maps_for_james']

[long,lat,tmp]=...
    processgeotiff([LocationOfMapsFromAvery '/map1_currentemissions_tco2e.tif']);
NfertEmissionsPerHA=tmp./fma;

[long,lat,croparea]=processgeotiff([LocationOfMapsFromAvery '/crop_area.tif']);

tmp=nansum(croparea,3)./fma;
tmp(tmp>3)=3;
NfertCropAreafrac=tmp;
NfertCropArea=tmp.*fma;

% now should be able to make some plots and tables of all of these badboys.

% % % %% Template from EVcalcs.m
% % % nsgfig=figure;
% % % NSS=getDrawdownNSS;
% % % NSS.figurehandle=nsgfig;
% % % NSS.units='g CO_2-eq/pkm';
% % % NSS.title='Current emissions benefit of Electric Cars'
% % % NSS.cmap=ExplorerEffectivenessDiverging1;
% % % NSS.caxis=[-80 80]
% % % 



%%
%%%%%%%%%%%%%%%%%%%%%%%%
% Emissions
%%%%%%%%%%%%%%%%%%%%%%%%
% Emissions
nsgfig=figure;
NSS=getDrawdownNSS;
NSS.caxis=[0 1];
NSS.figurehandle=nsgfig;
NSS.cmap='ExplorerEmissions1';
NSS.title='Emissions from Nutrient Management';
NSS.units='tons CO_2-eq/ha';
DataToDrawdownFigures(NfertEmissionsPerHA,NSS,'Emissions_nutrman','NutrientManagementFigsAndData/','');

% Context / Auxiliary
DataToDrawdownFigures(fma,'','HectaresPerPixel','NutrientManagementFigsAndData/','');
DataToDrawdownFigures(NfertCropAreafrac,'','CropAreaFractionOfGridcell23Crops','NutrientManagementFigsAndData/','');


%%
%%%%%%%%%%%%%%%%%%%%%%%%
% Effectiveness
%%%%%%%%%%%%%%%%%%%%%%%%

[long,lat,tmp]=...
    processgeotiff([LocationOfMapsFromAvery '/map2_currentEFs_tco2e_tN.tif']);
%tmp(isnan(tmp))=0;
NfertEmissionsPerUnitSolution=tmp;


NSS=getDrawdownNSS;
NSS.figurehandle=nsgfig;
NSS.caxis=[0 9];
NSS.cmap=ExplorerEffectiveness1;
NSS.title='Emissions avoided per ton N avoided';
NSS.units='tons CO_2-eq/ton N';

nsg(NfertEmissionsPerUnitSolution,NSS);
DataToDrawdownFigures(NfertEmissionsPerUnitSolution,NSS,'Effectiveness_nutrman','NutrientManagementFigsAndData/','');


%%
%%%%%%%%%%%%%%%%%%%%%%%%
% Current adoption
%%%%%%%%%%%%%%%%%%%%%%%%
[long,lat,tmp]=...
    processgeotiff([LocationOfMapsFromAvery '/map3_currentadoption_tN.tif']);
%tmp(isnan(tmp))=0;
CurrentAdoption=tmp./fma;

[long,lat,tmp]=...
    processgeotiff([LocationOfMapsFromAvery '/map7_achievablelow_TN.tif']);
%tmp(isnan(tmp))=0;
LowAdoption=tmp./fma;

[long,lat,tmp]=...
    processgeotiff([LocationOfMapsFromAvery '/map6_achievablehigh_TN.tif']);
%tmp(isnan(tmp))=0;
HighAdoption=tmp./fma;


CumulativeLowAdoption=LowAdoption;
ii=CurrentAdoption>LowAdoption;
CumulativeLowAdoption(ii)=CurrentAdoption(ii);


CumulativeHighAdoption=HighAdoption;
ii=CurrentAdoption>HighAdoption;
CumulativeHighAdoption(ii)=CurrentAdoption(ii);



NSS=getDrawdownNSS;
NSS.figurehandle=nsgfig;
NSS.caxis=[0 .1];
NSS.units='tons N/ha';
NSS.cmap=ExplorerAdoption1;
NSS.title='Current adoption of Improved Nutrient Management';
DataToDrawdownFigures(CurrentAdoption,NSS,'CurrentAdoption_nutrman','NutrientManagementFigsAndData/','');



NSS=getDrawdownNSS;
NSS.figurehandle=nsgfig;
NSS.caxis=[0 .1];
NSS.units='tons N/ha';
NSS.cmap=ExplorerAdoption1;
NSS.title='Improved Nutrient Management, Low Adoption';
DataToDrawdownFigures(CumulativeLowAdoption,NSS,'CumulativeLowAdoption_nutrman','NutrientManagementFigsAndData/','');


NSS=getDrawdownNSS;
NSS.figurehandle=nsgfig;
NSS.caxis=[0 .1];
NSS.units='tons N/ha';
NSS.cmap=ExplorerAdoption1;
NSS.title='Improved Nutrient Management, High Adoption';
DataToDrawdownFigures(CumulativeHighAdoption,NSS,'CumulativeHighAdoption_nutrman','NutrientManagementFigsAndData/','');


%%
%%%%%%%%%%%%%%%%%%%%%%%%
% Potential adoption - low/high uptake 
%%%%%%%%%%%%%%%%%%%%%%%%

NSS=getDrawdownNSS;
NSS.figurehandle=nsgfig;
NSS.caxis=[0 1];
NSS.units='tons CO_2-eq/ha';
NSS.cmap=ExplorerImpact1;
NSS.title='Current impact of Improved Nutrient Management';
DataToDrawdownFigures(CurrentAdoption.*NfertEmissionsPerUnitSolution,NSS,'CurrentImpact_nutrman','NutrientManagementFigsAndData/','');


NSS=getDrawdownNSS;
NSS.figurehandle=nsgfig;
NSS.caxis=[0 1];
NSS.units='tons CO_2-eq/ha';
NSS.cmap=ExplorerImpact1;
NSS.title='Low adoption impact of Improved Nutrient Management';
DataToDrawdownFigures(CumulativeLowAdoption.*NfertEmissionsPerUnitSolution,NSS,'LowImpact_nutrman','NutrientManagementFigsAndData/','');



NSS=getDrawdownNSS;
NSS.figurehandle=nsgfig;
NSS.caxis=[0 1];
NSS.units='tons CO_2-eq/ha';
NSS.cmap=ExplorerImpact1;
NSS.title='High adoption impact of Improved Nutrient Management';
DataToDrawdownFigures(CumulativeHighAdoption.*NfertEmissionsPerUnitSolution,NSS,'HighImpact_nutrman','NutrientManagementFigsAndData/','');





%%%%%%%%%%%%%%%%%%%%%%%%
% Bonus maps: Total applied N
%%%%%%%%%%%%%%%%%%%%%%%%

load N2O_PaperFigs/TotalappliedN_SavedFigureData  % data will be in OS.Data
NSSsave=NSS;
NSS.figurehandle=nsgfig;
NSS=getDrawdownNSS;
NSS.title='Total applied N';
NSS.caxis=[0 300];
NSS.cmap='eggplant';
NSS.units='kg N / ha';

DataToDrawdownFigures(OS.Data,NSS,'Contextmap_TotalAppliedNFertilizer_nutrman','NutrientManagementFigsAndData','');
