% Maps of Protect Seagrasses
%
% Note that this is a subset of protectcoastalwetlands 
%

MapsAndDataFilename='SeagrassMapsAndData';
%iMapsAndDataFilename='';
SolutionInputDataDir='~/DrawdownSolutions/ProtectForests/inputdatafiles/';

BaseNSS=getDrawdownNSS;
BaseNSS.plotflag='off';
RegionList={'Caribbean'};

seagrass30sec=processgeotiff('inputdatafiles/seagrass_prop_regridded.tif');
seagrass5min=aggregate_rate(seagrass30sec,10);

seagrass30sec_inpa=processgeotiff('inputdatafiles/seagrass_prop_regridded_inpa.tif');

wdpa30sec=seagrass30sec_inpa>0;


% Emissions:

%% SeaGrass
% Note on logic here:  Effectiveness = 3.56 tCO2-eq/ha/yr, of which 2.33
% emissions, 1.22 foregone sequestration.
%
% Since average decrease in emissions from adding protection = 53%
% Emissions where there is no protection must be (2.33)/.53=4.40 tons/ha/yr
% Emissions with protection =2.07 tons/ha/year.





Emissions30sec=seagrass30sec.*wdpa30sec*2.07 + seagrass30sec.*(1-wdpa30sec)*4.40;
Emissions5min=aggregate_rate(Emissions30sec,10,'hidden');

NSS=BaseNSS;
NSS.cmap=ExplorerEmissions1;
NSS.caxis=[.99];
NSS.title='Emissions (Seagrass degradation)';
%NSS.DisplayNotes={'Data: Hansen et al.','Downloaded Nov 2024'}
NSS.cbarvisible='on';
NSS.units='tons CO_2-eq/ha/yr';
DataToDrawdownFigures(Emissions5min,NSS,'EmissionsSeagrass5min',MapsAndDataFilename,RegionList);
DataToDrawdownFigures(Emissions30sec,'','EmissionsSeagrass30sec',MapsAndDataFilename,RegionList);


% Effectiveness is not interesting - the same everywhere.


%%%%%%%%%%%%%%%%%
%   Adoption current  (all mangroves) %
%%%%%%%%%%%%%%%%%


currentadoptionraster30sec=seagrass30sec_inpa;
DataToDrawdownFigures(currentadoptionraster30sec,'','adoptioncurrent_30sec_seagrass',MapsAndDataFilename,RegionList);

currentadoptionraster5min=aggregate_rate(currentadoptionraster30sec,10,'hidden');

NSS=BaseNSS;
NSS.cmap=ExplorerAdoption1;
NSS.title='Seagrass ecosystems currently under protection'
DataToDrawdownFigures(currentadoptionraster5min,NSS,'adoptioncurrent_seagrass',MapsAndDataFilename,RegionList);



%%%%%%%%%%%%%%%%%%%%
%   Impact current %
%%%%%%%%%%%%%%%%%%%%
NSS=BaseNSS;
NSS.cmap=ExplorerImpact1;
NSS.title='Avoided emissions of current protection of seagrass ecosystems';
NSS.units='t CO_2-eq/ha/yr';
NSS.caxis=[0 3];
DataToDrawdownFigures(3.56*currentadoptionraster5min,NSS,'ImpactCurrent',MapsAndDataFilename,RegionList);
DataToDrawdownFigures(3.56*currentadoptionraster30sec,'','ImpactCurrent30s',MapsAndDataFilename,RegionList);

