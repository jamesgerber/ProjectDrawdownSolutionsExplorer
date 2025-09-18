% Maps of Protect Saltmarshes
%
% Note that this is a subset of protectcoastalwetlands 
%

MapsAndDataFilename='SaltmarshMapsAndData';
%iMapsAndDataFilename='';
SolutionInputDataDir='~/DrawdownSolutions/ProtectForests/inputdatafiles/';
RegionList={'Caribbean'};
BaseNSS=getDrawdownNSS;
BaseNSS.plotflag='off';


% where are mangroves?
saltmarsh30sec=processgeotiff('inputdatafiles/saltmarsh_final.tif');
saltmarsh5min=aggregate_rate(saltmarsh30sec,10);
% where are mangroves?
saltmarshinpa30sec=processgeotiff('inputdatafiles/saltmarsh_final_inpa.tif');
saltmarsh5min=aggregate_rate(saltmarsh30sec,10);

wdpa30sec=saltmarshinpa30sec>0;

% Emissions:
%% SaltMarsh
% Effectiveness = 4.78 tCO2-eq/ha/yr, of which 2.9 emissions, 1.88 foregone
% sequestration
% Since average decrease in emissions from adding protection = 59%
% Emissions where there is no protection must be (2.90)/.59=5.92 tons/ha/yr
% Emissions with protection =2.02 tons/ha/year.


Emissions30sec = saltmarsh30sec.*wdpa30sec*2.02 + saltmarsh30sec.*(1-wdpa30sec)*5.92;
Emissions5min  = aggregate_rate(Emissions30sec,10,'hidden');

NSS=BaseNSS;
NSS.cmap=ExplorerEmissions1;
NSS.caxis=[.99];
NSS.title='Emissions (Salt marsh degradation)';
%NSS.DisplayNotes={'Data: Hansen et al.','Downloaded Nov 2024'}
NSS.cbarvisible='on';
NSS.units='tons CO_2-eq/ha/yr';
DataToDrawdownFigures(Emissions5min,NSS,'EmissionsSaltMarsh5min',MapsAndDataFilename,RegionList);
DataToDrawdownFigures(Emissions30sec,'','EmissionsSaltMarsh30sec',MapsAndDataFilename,RegionList);


% Effectiveness is not interesting - the same everywhere.


%%%%%%%%%%%%%%%%%
%   Adoption current  (all mangroves) %
%%%%%%%%%%%%%%%%%
%wdpa1=processgeotiff('inputdatafiles/raster_wdpa_iucncats_ItoVI.tif');
% this should be a binary, where 1 = protected area.

currentadoptionraster30sec=saltmarshinpa30sec;
DataToDrawdownFigures(currentadoptionraster30sec,'','adoptioncurrent_30sec_saltmarsh',MapsAndDataFilename,RegionList);

currentadoptionraster5min=aggregate_rate(currentadoptionraster30sec,10,'hidden');

NSS=BaseNSS;
NSS.cmap=ExplorerAdoption1;
NSS.title='Salt marsh ecosystems currently under protection'
DataToDrawdownFigures(currentadoptionraster5min,NSS,'adoptioncurrent_saltmarsh',MapsAndDataFilename,RegionList);



%%%%%%%%%%%%%%%%%%%%
%   Impact current %
%%%%%%%%%%%%%%%%%%%%
NSS=BaseNSS;
NSS.cmap=ExplorerImpact1;
NSS.title='Avoided emissions of current protection of salt marsh ecosystems';
NSS.units='t CO_2-eq/ha/yr';
NSS.caxis=[0 3];
DataToDrawdownFigures(4.78*currentadoptionraster5min,NSS,'ImpactCurrent',MapsAndDataFilename,RegionList);
DataToDrawdownFigures(4.78*currentadoptionraster30sec,'','ImpactCurrent30s',MapsAndDataFilename,RegionList);

