
MapsAndDataFilename='ProtectForestMapsAndData';

% let's map treecover, mangroves, forests

mangroves=processgeotiff('inputdatafiles/mangroves_final.tif');
mangroves5min=aggregate_rate(mangroves,10);
mangroves5km=aggregate_rate(mangroves,5);

% 

peatlands=processgeotiff('inputdatafiles/peatlands.tif');
peatlands5km=aggregate_rate(peatlands,5);


treecover=processgeotiff('inputdatafiles/HansenTreeCover30s.tif')/100;
treecover5km=aggregate_rate(treecover,5);

treecoverloss=processgeotiff('inputdatafiles/HansenTreeCoverLoss1km.tif');
treecoverloss5km=aggregate_rate(treecoverloss,5);

treecoverlossrate=treecoverloss5km./treecover5km;


x=load('~/DataProducts/ext/ForestGHGFlux_Harris/GFWForestPosFlux2001_2023_30sec.mat');
GHGFluxPos=x.GHGFlux;
GHGFluxPos5km=aggregate_rate(GHGFluxPos,5);

x=load('~/DataProducts/ext/ForestGHGFlux_Harris/GFWForestPosFlux2001_2023_5min.mat');
GHGFluxPos5min=x.GHGFlux5min;
%%

% first a context map:  treecover, masking out area

NSS=getDrawdownNSS;
NSS.cmap='greens_deep';
NSS.caxis=[0 100];
NSS.title='Percent tree cover 2000 (excluding mangrove and peatland)';
%NSS.DisplayNotes={'Data: Hansen et al.','Downloaded Nov 2024'}
NSS.cbarvisible='on';
NSS.units='% ground cover';


ii=peatlands5km>.5;
jj=mangroves5km>.5;


treecover5km(ii)=0;
treecover5km(jj)=0;

DataToDrawdownFigures(treecover5km*100,NSS,'treecover',MapsAndDataFilename);

%% Tree cover loss - limited to agriculture
[long,lat,TreeCoverLoss5min]=processgeotiff('/Users/jsgerber/DataProducts/ext/HansenTreeCover/HansenTreeCoverLoss5min.tif');
[long,lat,TreeCoverGain5min]=processgeotiff('/Users/jsgerber/DataProducts/ext/HansenTreeCover/HansenTreeCoverGain5min.tif');
curtisraster=processgeotiff('/Users/jsgerber/DataProducts/ext/TreeCoverLossByDriver/FinalClassification.tif');

TreeCoverBoth5min=TreeCoverLoss5min>.1 & TreeCoverGain5min>.1;
TreeCoverLoss5min(TreeCoverBoth5min)=0;
TreeCoverGain5min(TreeCoverBoth5min)=0;


tcllimited=TreeCoverLoss5min;
iiag=curtisraster==1 | curtisraster==2;
tcllimited(~iiag)=nan;


NSS=getDrawdownNSS;
NSS.FileName ='treecoverloss';
NSS.caxis=[0 .5];
NSS.title='Deforestation for agriculture, 2001-2023';
NSS.cmap='eggplant';
NSS.units='fraction of landscape'
DataToDrawdownFigures(tcllimited,NSS,'agriculture',MapsAndDataFilename);



%%%%%%%%%%%%%%%%%
% Emissions     %
%%%%%%%%%%%%%%%%%
%% Emissions, flux in landscape hectares, limited to agriculture
EmissionsInLandscapeHA=GHGFluxPos5min/22;
EmissionsInLandscapeHA(~iiag)=nan;

NSS=getDrawdownNSS;
NSS.cmap=ExplorerEmissions1;
NSS.units='t CO_2-eq/ha/yr';
NSS.title='Annual emissions from deforestation for agriculture, 2001-2023';
NSS.caxis=[0 10];
DataToDrawdownFigures(EmissionsInLandscapeHA,NSS,'emissionsflux',MapsAndDataFilename);


%%%%%%%%%%%%%%%%%
% Effectiveness %
%%%%%%%%%%%%%%%%%
% this is a map of carbon stocks x loss rates x reduction due to protection

% Carbon Stock is from data provided by David Gibbs of WRI, it is the data
% in Harris et al, + Gibbs et al update.  
CStock5min=processgeotiff('inputdatafiles/TotalCStock5min.tif');

TCLossPercentage=treecoverlossrate;
TCLossPercentage(TCLossPercentage>1)=1;
TCLossFractionPerYear5min=aggregate_rate(TCLossPercentage,2)/22;

load intermediatedatafiles/WolfProtectedAreaEffectivenessMap PAeffectivenessmap

PAeffectivenessmap=max(PAeffectivenessmap,0);
Effectiveness=CStock5min.*3.67.*TCLossFractionPerYear5min.*PAeffectivenessmap/100;

%%%%%%%%%%%%%%%%%
% Effectiveness %
%%%%%%%%%%%%%%%%%

NSS=getDrawdownNSS;
NSS.cmap=ExplorerEffectiveness1;
NSS.units='t CO_2-eq/ha/yr';
NSS.title='Effectiveness of protecting a ha of land, 2001-2023';
NSS.caxis=[0 10];
DataToDrawdownFigures(Effectiveness,NSS,'effectiveness',MapsAndDataFilename);

