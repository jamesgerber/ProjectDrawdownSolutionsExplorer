% Maps of Mangrove Protect
%
% Note that this is a subset of protectcoastalwetlands - I'm getting this
% on the books so it can feed into the SEAsia report
%
%

warndlg([' Note ... there are two separate calculations of the mangrove solution, see notes in ' mfilename])

% two separate calculations.  this one here treats mangroves in analogy
% with forests.  the benefit is that it is a high-resolution approach, and
% also is what was done for a project funded by the Asia Philanthropy
% Circle.   

MapsAndDataFilename='MangroveMapsAndData';
%MapsAndDataFilename='';
SolutionInputDataDir='~/DrawdownSolutions/ProtectForests/inputdatafiles/';

BaseNSS=getDrawdownNSS;
BaseNSS.plotflag='off';
% here's the code I used to get biomass
% gdalwarp -te -180 -90 180 90 -tr 0.00833333 0.00833333 -r average total_biomass.tif total_biomass1km.tif


%LandAndCoastMap30sec=processgeotiff('inputdatafiles/LandAndCoastMap30sec.tif');


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

% Where is treecover?
treecover30sec=processgeotiff('inputdatafiles/HansenTreeCover30s.tif')/100;
treecover5min=aggregate_rate(treecover30sec,10);

% Assume that whatever percentage loss there is of treecover that this
% percentage loss applies to the mangrove area.

treecoverloss30sec=processgeotiff('inputdatafiles/HansenTreeCoverLoss1km.tif');
treecoverlossrate30sec=treecoverloss30sec./treecover30sec;



AnnualLossRate5min=aggregate_rate(treecoverlossrate30sec,10,'hidden');


mangroves30sec=processgeotiff([SolutionInputDataDir '/mangroves_final.tif']);
mangroves5min=aggregate_rate(mangroves30sec,10,'hidden');
mangroves5min(isnan(mangroves5min))=nan;

fractionmangrove=mangroves5min./treecover5min;
fractionmangrove(fractionmangrove>1)=0;
fractionmangrove(isnan(fractionmangrove) & mangroves5min>0)=1;
fractionmangrove(isnan(fractionmangrove))=0;


AnnualLossRateAllocatedToMangrove=AnnualLossRate5min.*fractionmangrove;

save intermediatedatalayers/mangroves/mangroves5min mangroves5min
save intermediatedatalayers/mangroves/AnnualLossRateAllocatedToMangrove AnnualLossRateAllocatedToMangrove
save intermediatedatalayers/mangroves/fractionmangrove fractionmangrove


% carbon stocks
% whereas used total carbon stocks for forests on mineral soils, here we
% need to keep soil and biomass separate.  For mangroves, all biomass goes
% away, 50-63% of soil goes away.

biomass30sec=3.67*processgeotiff([SolutionInputDataDir '/total_biomass1km.tif']);
biomass5min=aggregate_rate(biomass30sec,10,'hidden');
wd=pwd
[ISOList,~,~,~,~,MangroveSoilCO2map,MeanRatio]=MacreadieTable;

rmap=datablank( (1+2.1355)/2);

c=0;
clear rvect
for j=1:11
    [ISO,~,ii]=SEAsia11(j);
    idx=strmatch(ISO,ISOList);
    if numel(idx)==1
        r=MeanRatio(idx)

        if r>0
        rmap(ii)=r;
        c=c+1;
        rvect(c)=r;
        end
    end
end

MangroveSoilCO2mapCorrected=MangroveSoilCO2map.*rmap;

% let's correct the MangroveSoilCO2map by the MeanRatio

biomass5min(isnan(biomass5min))=0;
MangroveSoilCO2mapCorrected(isnan(MangroveSoilCO2mapCorrected))=0;
atriskCO2=biomass5min+0.5*MangroveSoilCO2mapCorrected;

save intermediatedatalayers/mangroves/atriskCO2 atriskCO2


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

%% Current emissions
% current emissions are all carbon in woody biomass + 1/2 of the soil
% carbon.  soil carbon from Wang et al



% want biomass + half of soilcarbon.
mangrovesoil30sec=...
    processgeotiff('inputdatafiles/WangMangroveSoil/output_carbon_stock_2000_30s_4326_average.tif');

AtRiskMangroveCarboneq30sec=mangrovesoil30sec*3.667*0.5+biomass30sec;
AtRiskMangroveCarboneq30sec(mangrovesoil30sec==0)=0;
AtRiskMangroveCarbon5min=aggregate_rate(AtRiskMangroveCarboneq30sec,10,'hidden');

% where is there deforestation?
SimsRaster=processgeotiff('inputdatafiles/drivers_forest_loss_1km_2001_2024_v1_2_band1_30s.tif');

treecoverloss30sec=processgeotiff('inputdatafiles/HansenTreeCoverLoss1km.tif');
treecoverlossrate30sec=treecoverloss30sec./treecover30sec;
TCLossPercentage30sec=treecoverlossrate30sec;
TCLossPercentage30sec(TCLossPercentage30sec>1)=1;
TCLossFractionPerYear30sec=TCLossPercentage30sec/22;
TCLossFractionPerYear30secSimsLimited=TCLossFractionPerYear30sec;
% now turn off TCL associated with wildfire (5) or other natural dist (7)
TCLossFractionPerYear30secSimsLimited(SimsRaster==5 | SimsRaster==7)=0;

clear SimsRaster
clear TCLossFractionPerYear30sec
clear biomass30sec
clear mangrovesoil30sec
clear treecover30sec

TCLossFractionPerYear5minSimsLimited=aggregate_rate(TCLossFractionPerYear30secSimsLimited,10,'hidden');

clear treecoverlossrate30sec

treecoverloss5min=aggregate_rate(treecoverloss30sec,10);
treecoverlossrate5min=treecoverloss5min./treecover5min;

clear treecoverloss30sec


MangroveEmissions30s=AtRiskMangroveCarboneq30sec.*TCLossFractionPerYear30secSimsLimited;

DataToDrawdownFigures(MangroveEmissions30s,'','MangroveEmissions_NotMENA_30s',MapsAndDataFilename);
MangroveEmissions5mins=aggregate_rate(MangroveEmissions30s,10,'hidden');

NSS=getDrawdownNSS;
NSS.cmap=ExplorerEmissions1;
NSS.caxis=[.99];
NSS.title='Emissions (Mangrove loss)';
%NSS.DisplayNotes={'Data: Hansen et al.','Downloaded Nov 2024'}
NSS.cbarvisible='on';
NSS.units='tons CO_2-eq/ha/yr';
DataToDrawdownFigures(MangroveEmissions5mins,NSS,'MangroveEmissions_NotMENA',MapsAndDataFilename);


%%%%%%%%%%%%%%%%%
% Effectiveness %
%%%%%%%%%%%%%%%%%
% this is a map of carbon stocks x loss rates x reduction due to protection
% limited to deliberate loss.


clear TCLossFractionPerYear30sec



load intermediatedatafiles/WolfProtectedAreaEffectivenessMap PAeffectivenessmap

PAeffectivenessmap=max(PAeffectivenessmap,0);

PAeffectivenessmap30sec=disaggregate_rate(PAeffectivenessmap,10);

Effectiveness30sec=AtRiskMangroveCarboneq30sec.*PAeffectivenessmap30sec/100.*TCLossFractionPerYear30secSimsLimited;

Effectiveness5min=AtRiskMangroveCarbon5min.*3.67.*TCLossFractionPerYear5minSimsLimited.*PAeffectivenessmap/100;
%Effectiveness5min(binarypeatormangrove5min)=nan;

NSS=BaseNSS;
NSS.cmap=ExplorerEffectiveness1;
NSS.units='t CO_2-eq/ha/yr';
NSS.title='Effectiveness of protecting a ha of mangrove forest, 2001-2023';
NSS.caxis=[0 10];
DataToDrawdownFigures(Effectiveness5min,NSS,'effectiveness',MapsAndDataFilename);
DataToDrawdownFigures(Effectiveness30sec,'','effectiveness30sec',MapsAndDataFilename);
%%
%%%%%%%%%%%%%%%%%
%   Adoption current  (all mangroves) %
%%%%%%%%%%%%%%%%%
%wdpa1=processgeotiff('inputdatafiles/raster_wdpa_iucncats_ItoVI.tif');
% this should be a binary, where 1 = protected area.
wdpa30sec=processgeotiff('inputdatafiles/wdpa_iucncats_ItoIV_alltouchedFalse_1km.tif');
wdpa5min=processgeotiff('inputdatafiles/wdpa_iucncats_ItoIV_alltouchedFalse_1km.tif');

%currentadoptionraster=wdpa5min==1 & fractionmangrove>0;

currentadoptionraster30sec=mangroves30sec;
currentadoptionraster30sec(wdpa30sec==0)=0;
DataToDrawdownFigures(currentadoptionraster30sec,'','adoptioncurrent_30sec_anymangrove',MapsAndDataFilename);

currentadoptionraster5min=aggregate_rate(currentadoptionraster30sec,10,'hidden');

NSS=BaseNSS;
NSS.cmap=ExplorerAdoption1;
NSS.title='Mangrove forests currently under protection'
DataToDrawdownFigures(currentadoptionraster5min,NSS,'adoptioncurrent_noMENA',MapsAndDataFilename);



%%%%%%%%%%%%%%%%%%%%
%   Impact current %
%%%%%%%%%%%%%%%%%%%%
NSS=BaseNSS;
NSS.cmap=ExplorerImpact1;
NSS.title='Avoided emissions of current protection of mangrove forests';
NSS.units='t CO_2-eq/ha/yr';
NSS.caxis=[0 3];
DataToDrawdownFigures(Effectiveness5min.*currentadoptionraster5min,NSS,'ImpactCurrent',MapsAndDataFilename);
DataToDrawdownFigures(Effectiveness30sec.*currentadoptionraster30sec,'','ImpactCurrent30s',MapsAndDataFilename);


%%%%%%%%
% future adoption
%%%%%%%%%

% % Intactness - don't actually need this.
% % flii30sec=processgeotiff('inputdatafiles/flii_earth_highintegrity_binary_30s_raavg_compressed.tif');
% % flii5min=aggregate_rate(flii30sec,10);
