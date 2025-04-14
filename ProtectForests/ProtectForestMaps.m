
% some notes:
% This wont run unless you've already run processwolfdata


MapsAndDataFilename='ProtectForestMapsAndData';
MapsAndDataFilename='';  % if you keep this empty, DataToDrawdownFigures
%won't make maps


% load some data at 30 second, make 5 minute versions.
mangroves30sec=processgeotiff('inputdatafiles/mangroves_final.tif');
mangroves5min=aggregate_rate(mangroves30sec,10);
% 
peatlands30sec=processgeotiff('inputdatafiles/peatlands.tif');
peatlands5min=aggregate_rate(peatlands30sec,10);

treecover30sec=processgeotiff('inputdatafiles/HansenTreeCover30s.tif')/100;
treecover5min=aggregate_rate(treecover30sec,10);

treecoverloss30sec=processgeotiff('inputdatafiles/HansenTreeCoverLoss1km.tif');
treecoverloss5min=aggregate_rate(treecoverloss30sec,10);
treecoverlossrate5min=treecoverloss5min./treecover5min;






GHGFluxPos30sec=processgeotiff('inputdatafiles/GFWForestPosFlux2001_2023_30sec.tif');
GHGFluxPos5min=aggregate_rate(GHGFluxPos30sec,10);
%%

%  Now excluding peatlands and mangroves from the tree cover map.  I'm only
%  doing this at 5minute resolution, and my definition of peatland and
%  mangrove here is strictly for mapping.  Since the true calculation was
%  done at 30 seconds, this doesn't correspond.

ii=peatlands5min>.5;
jj=mangroves5min>.5;
treecover5min(ii)=0;
treecover5min(jj)=0;
binarypeatormangrove5min=ii | jj;


%% Intactness
flii30sec=processgeotiff('inputdatafiles/flii_earth_highintegrity_binary_30s_raavg_compressed.tif');
flii5min=aggregate_rate(flii30sec,10);


%% Planted trees

plantationraster30sec=processgeotiff('inputdatafiles/FractionOfAllPlantationTypes30s.tif');
plantationraster5min=aggregate_rate(plantationraster30sec,10);

% first a context map:  treecover, masking out area

NSS=getDrawdownNSS;
NSS.cmap='greens_deep';
NSS.caxis=[0 100];
NSS.title='Percent tree cover 2000 (excluding mangrove and peatland)';
%NSS.DisplayNotes={'Data: Hansen et al.','Downloaded Nov 2024'}
NSS.cbarvisible='on';
NSS.units='% ground cover';

DataToDrawdownFigures(treecover5min*100,NSS,'context_treecover',MapsAndDataFilename);

% Here is what it looks like when I write out the high-resolution datafiles
% in the format for transferring data over to you.  (the NSS argument is
% empty)
DataToDrawdownFigures(treecover30sec*100,'','context_treecover30sec',MapsAndDataFilename);



%% Tree cover loss - limited to agriculture

TreeCoverLoss5min=treecoverloss5min;


curtisraster5min=processgeotiff('inputdatafiles/CurtisTCLByDriverClassification.tif');
 % Curtis: 0:5
 % CategoryTitles={
 %     'Zero or Minor Loss',...
 %     'Commodity Driven Deforestation',...
 %     'Shifting Agriculture',...
 %     'Forestry',...
 %     'Wildfire',...
 %     'Urbanization'...
 %     }


tcllimited=TreeCoverLoss5min;
iiag=curtisraster5min==1 | curtisraster5min==2;
tcllimited(~iiag)=nan;
tcllimited(binarypeatormangrove5min)=nan;


NSS=getDrawdownNSS;
NSS.caxis=[0 .5];
NSS.title='Deforestation for agriculture, 2001-2023';
NSS.cmap='eggplant';
NSS.units='fraction of landscape'
DataToDrawdownFigures(tcllimited,NSS,'Context_Defor_agriculture',MapsAndDataFilename);

%%%%%%%%%%
%% Tree cover loss - limited to non-wildfire
%%%%%%%%%%
tcllimited=TreeCoverLoss5min;
tcllimited(curtisraster5min==4)=nan;
tcllimited(binarypeatormangrove5min)=nan;


NSS=getDrawdownNSS;
NSS.caxis=[0 .5];
NSS.title='Non-wildfire Deforestation, 2001-2023';
NSS.cmap='eggplant';
NSS.units='fraction of landscape'
DataToDrawdownFigures(tcllimited,NSS,'Context_Defor_nonwildfire',MapsAndDataFilename);



%%%%%%%%%%%%%%%%%
% Emissions     %
%%%%%%%%%%%%%%%%%
%% Emissions, flux in landscape hectares, limited to non-wildfire
EmissionsInLandscapeHA=GHGFluxPos5min/22;
%EmissionsInLandscapeHA(~iiag)=nan;
EmissionsInLandscapeHA(binarypeatormangrove5min)=nan;
EmissionsInLandscapeHA(curtisraster5min==4)=nan;

NSS=getDrawdownNSS;
NSS.cmap=ExplorerEmissions1;
NSS.units='t CO_2-eq/ha/yr';
NSS.title='Annual emissions from non-wildfire treecover loss, 2001-2023';
NSS.caxis=[0 10];
DataToDrawdownFigures(EmissionsInLandscapeHA,NSS,'emissionsflux',MapsAndDataFilename);


%%%%%%%%%%%%%%%%%
% Effectiveness %
%%%%%%%%%%%%%%%%%
% this is a map of carbon stocks x loss rates x reduction due to protection

% Carbon Stock is from data provided by David Gibbs of WRI, it is the data
% in Harris et al, + Gibbs et al update.  
CStock30sec=processgeotiff('inputdatafiles/TotalCStock30s.tif');
CStock5min=processgeotiff('inputdatafiles/TotalCStock5min.tif');

TCLossPercentage=treecoverlossrate5min;
TCLossPercentage(TCLossPercentage>1)=1;
TCLossFractionPerYear5min=TCLossPercentage/22;

TCLossFractionPerYear5minCurtisLimited=TCLossFractionPerYear5min;
TCLossFractionPerYear5minCurtisLimited(curtisraster5min==4)=0;



load intermediatedatafiles/WolfProtectedAreaEffectivenessMap PAeffectivenessmap

PAeffectivenessmap=max(PAeffectivenessmap,0);
Effectiveness=CStock5min.*3.67.*TCLossFractionPerYear5minCurtisLimited.*PAeffectivenessmap/100;
Effectiveness(binarypeatormangrove5min)=nan;

NSS=getDrawdownNSS;
NSS.cmap=ExplorerEffectiveness1;
NSS.units='t CO_2-eq/ha/yr';
NSS.title='Effectiveness of protecting a ha of land, 2001-2023';
NSS.caxis=[0 10];
DataToDrawdownFigures(Effectiveness,NSS,'effectiveness',MapsAndDataFilename);
%%

%%%%%%%%%%%%%%%%%
%   Adoption current   %
%%%%%%%%%%%%%%%%%
%wdpa1=processgeotiff('inputdatafiles/raster_wdpa_iucncats_ItoVI.tif');
% this should be a binary, where 1 = protected area.
wdpa30sec=processgeotiff('inputdatafiles/raster_wdpa_iucncats_ItoVI_alltouchedFalse_1km.tif');
wdpa5min=processgeotiff('inputdatafiles/raster_wdpa_iucncats_ItoVI_alltouchedFalse.tif');

currentadoptionraster=wdpa5min==1 & treecover5min>.025;

%%%%%%%%%%%%%%%%%
%   Adoption - low   %
%%%%%%%%%%%%%%%%%

isintact=flii5min>.75;

lowadoptionraster=(isintact | wdpa5min==1) & treecover5min>.025 ;

%%%%%%%%%%%%%%%%%
%   Adoption - high   %
%%%%%%%%%%%%%%%%%

highadoptionraster=  treecover5min-plantationraster5min;
highadoptionraster(highadoptionraster<0)=0;

highadoptionraster=max(highadoptionraster,lowadoptionraster);


%  now map the adoptions



% current

NSS=getDrawdownNSS;
NSS.cmap=ExplorerAdoption1;
NSS.title='Forested land currently under protection'
DataToDrawdownFigures(currentadoptionraster,NSS,'adoptioncurrent',MapsAndDataFilename);

% low

NSS=getDrawdownNSS;
NSS.cmap=ExplorerAdoption1;
NSS.title='Forested land protected under low ambition protection scenario'
DataToDrawdownFigures(lowadoptionraster,NSS,'adoptionlow',MapsAndDataFilename);


% high

NSS=getDrawdownNSS;
NSS.cmap=ExplorerAdoption1;
NSS.title='Forested land protected under high ambition protection scenario'
DataToDrawdownFigures(highadoptionraster,NSS,'adoptionhigh',MapsAndDataFilename);


%%%%%%%%%%%%%%%%%
%   Impact    %
%%%%%%%%%%%%%%%%%
% Impact = Effectiveness * Adoption

NSS=getDrawdownNSS;
NSS.cmap=ExplorerImpact1;
NSS.title='Avoided emissions of current forest protection';
NSS.units='t CO_2-eq/ha/yr';
NSS.caxis=[0 3];
DataToDrawdownFigures(Effectiveness.*currentadoptionraster,NSS,'ImpactCurrent',MapsAndDataFilename);

NSS=getDrawdownNSS;
NSS.cmap=ExplorerImpact1;
NSS.title='Avoided emissions of low-ambition forest protection';
NSS.units='t CO_2-eq/ha/yr';
NSS.caxis=[0 5];
DataToDrawdownFigures(Effectiveness.*lowadoptionraster,NSS,'ImpactLow',MapsAndDataFilename);

NSS=getDrawdownNSS;
NSS.cmap=ExplorerImpact1;
NSS.title='Avoided emissions of high-ambition forest protection';
NSS.units='t CO_2-eq/ha/yr';
NSS.caxis=[0 10];
DataToDrawdownFigures(Effectiveness.*highadoptionraster,NSS,'ImpactHigh',MapsAndDataFilename);




