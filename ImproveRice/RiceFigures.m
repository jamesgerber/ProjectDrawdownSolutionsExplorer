

%addpath('~jsgerber/source/ProjectDrawdownMatlab/ProjectDrawdownMatlab/ImproveRice/','-end');

wd='~/DrawdownSolutions/ImproveRice/';

SEAsiaWorkingDirectory='~/SEAsiaProject';

RegionList={'SEAsia'};
RegionList=''

cd(SEAsiaWorkingDirectory);
addpath('~/SEAsiaProject/codes/SEAsiaProject/','-end');
load intermediatedatalayers/rice/Year2020RiceCH4eEmissions.mat area2020      

[CH4CurrentEmissions,CurrentAWDUptake,BoUptake,...
    CH4EmissionsIntensityImprovementWithAWDUptake,WetRiceArea,DryRiceArea]=calculatepotentialuptakerice;
% CurrentEmissions - methane emissions from flooded rice (tons CO2-eq per
% harvested ha)
% CurrentAWDUptake - estimates of current uptake of AWD (national level
% data)
% BoUptake         - Bo et al uptake of AWD (5 minute pixel level data)
% EmissionsIntensityImprovementWithAWDUptake - province level avg emissions intensity improvement
% WetRiceArea  - area of rice (fraction of grid cell) that is irrigated or flooded paddy
% DryRiceArea - upland rice
[N2OEmissionsPerHA_AWD_CO2eq,N2OEmissionsPerHA_CF_CO2eq,fractionhaperpixel,...
    fractionAWD,fractionCF,EmissionsPerHA_AWD_CO2eq_HighAdoption,EmissionsPerHA_CF_CO2eq_HighAdoption]=...
    ReturnFloodedRiceN2OEmissions;

% Return CO2eq emissions from N application to Flooded Rice
% EmissionsPerHA_AWD_CO2eq  - N2O emissions per cultivated ha if AWD
% EmissionsPerHA_CF_CO2eq   - N2O emissions per cultivated ha if CF
% fractionhaperpixel  - fraction of pixel that is cultivated (can exceed 1)
% fractionAWD- fraction of cultivated rice where AWD appropriate (per Bo)
% fractionCF - fraction of cultivated rice  where AWD not appropriate (per Bo)
% EmissionsPerHA_AWD_CO2eq_HighAdoption -  N2O emissions per cultivated ha
% if AWD (high adoption of solution)
% EmissionsPerHA_CF_CO2eq_HighAdoption

% TotalRiceEmissionsTonsCO2eqperha=
N2OAWDEmissions=N2OEmissionsPerHA_AWD_CO2eq.*fractionAWD; 
N2OCFEmissions=N2OEmissionsPerHA_CF_CO2eq.*fractionCF;
N2OAWDEmissions(isnan(N2OAWDEmissions))=0;
N2OCFEmissions(isnan(N2OCFEmissions))=0;
CH4CurrentEmissions(isnan(CH4CurrentEmissions))=0;

TotalRiceEmissionsTonsCO2eqPerHa=CH4CurrentEmissions + N2OAWDEmissions + N2OCFEmissions;

cd(wd);

MapsAndDataFilename='ImproveRiceProductionMapsAndData';
BaseNSS=getDrawdownNSS; % this will make maps
%BaseNSS.plotflag='off'; %if you set this to off, DataToDrawdownFigures
%won't make maps





NSS=BaseNSS
NSS.cmap='white_blue_green';
NSS.caxis=[0 1];
NSS.title='Paddy rice area';
%NSS.DisplayNotes={'Data: Hansen et al.','Downloaded Nov 2024'}
NSS.cbarvisible='on';
NSS.units='fraction of land';
WetRiceArea(WetRiceArea==0)=nan;
NSS.logicalinclude=WetRiceArea>0.01;
DataToDrawdownFigures(WetRiceArea,NSS,'floodedricearea',MapsAndDataFilename,RegionList);


WetRiceAreaBinary=WetRiceArea>0.01;
DataToDrawdownFigures(WetRiceAreaBinary,'','floodedriceareabinary',MapsAndDataFilename,'');
NSS=BaseNSS
NSS.cmap=ExplorerEmissions1;
NSS.caxis=[0 10];
NSS.title='Methane emissions from paddy rice cultivation';
%NSS.DisplayNotes={'Data: Hansen et al.','Downloaded Nov 2024'}
NSS.cbarvisible='on';
NSS.units='CO_2-eq/ha';
NSS.logicalinclude=WetRiceArea>0.01;

DataToDrawdownFigures(CH4CurrentEmissions.*WetRiceArea,NSS,'methaneemissions',MapsAndDataFilename,RegionList);


NSS=BaseNSS
NSS.cmap=ExplorerEmissions1;
NSS.caxis=[0 5];
NSS.title='Methane emissions from paddy rice cultivation';
%NSS.DisplayNotes={'Data: Hansen et al.','Downloaded Nov 2024'}
NSS.cbarvisible='on';
NSS.units='CO_2-eq/ha';

DataToDrawdownFigures(CH4CurrentEmissions.*WetRiceArea,NSS,'methaneemissions_tightColorAxis',MapsAndDataFilename,RegionList);



NSS=BaseNSS
NSS.cmap=ExplorerEmissions1;
NSS.caxis=[0 2];
NSS.title='N2O emissions from paddy rice cultivation';
%NSS.DisplayNotes={'Data: Hansen et al.','Downloaded Nov 2024'}
NSS.cbarvisible='on';
NSS.units='CO_2-eq/ha';

DataToDrawdownFigures((N2OAWDEmissions + N2OCFEmissions).*WetRiceArea,NSS,'n2oemissions',MapsAndDataFilename,RegionList);

NSS=BaseNSS
NSS.cmap=ExplorerEmissions1;
NSS.caxis=[0 10];
NSS.title='Emissions from paddy rice cultivation';
%NSS.DisplayNotes={'Data: Hansen et al.','Downloaded Nov 2024'}
NSS.cbarvisible='on';
NSS.units='CO_2-eq/ha';

DataToDrawdownFigures((CH4CurrentEmissions+N2OAWDEmissions + N2OCFEmissions).*WetRiceArea,NSS,'totalpaddyriceemissions',MapsAndDataFilename,RegionList);


NSS=BaseNSS
NSS.cmap=ExplorerEmissions1;
NSS.caxis=[0 10];
NSS.title='Methane emissions from paddy rice cultivation';
%NSS.DisplayNotes={'Data: Hansen et al.','Downloaded Nov 2024'}
NSS.cbarvisible='on';
NSS.units='CO_2-eq/ha';

DataToDrawdownFigures(CH4CurrentEmissions.*WetRiceArea,NSS,'methaneemissions',MapsAndDataFilename,RegionList);


NSS=BaseNSS
NSS.cmap='eggplant';
NSS.caxis=[0 10];
NSS.title='Methane emissions decrease with uptake of AWD';
%NSS.DisplayNotes={'Data: Hansen et al.','Downloaded Nov 2024'}
NSS.cbarvisible='on';
NSS.units='CO_2-eq/ha';

DataToDrawdownFigures(CH4EmissionsIntensityImprovementWithAWDUptake.*WetRiceArea,NSS,'methaneemissionsdecrease',MapsAndDataFilename,RegionList);

NSS=BaseNSS
NSS.cmap='eggplant';
NSS.caxis=[0 5];
NSS.title='Methane emissions decrease with uptake of AWD';
%NSS.DisplayNotes={'Data: Hansen et al.','Downloaded Nov 2024'}
NSS.cbarvisible='on';
NSS.units='CO_2-eq/ha';

DataToDrawdownFigures(CH4EmissionsIntensityImprovementWithAWDUptake.*WetRiceArea,NSS,'methaneemissionsdecrease_tightColorAxis',MapsAndDataFilename,RegionList);



NSS=BaseNSS
NSS.cmap=ExplorerEmissions1;
NSS.caxis=[0 10];
NSS.title='Methane emissions decrease with uptake of AWD';
%NSS.DisplayNotes={'Data: Hansen et al.','Downloaded Nov 2024'}
NSS.cbarvisible='on';
NSS.units='CO_2-eq/ha';

DataToDrawdownFigures(CH4EmissionsIntensityImprovementWithAWDUptake.*WetRiceArea,NSS,'methaneemissionsdecrease_EmissionsColorbar',MapsAndDataFilename,RegionList);

NSS=BaseNSS
NSS.cmap=ExplorerAdoption1;
NSS.caxis=[0 100];
NSS.title='Estimated adoption of advanced water management';
%NSS.DisplayNotes={'Data: Hansen et al.','Downloaded Nov 2024'}
NSS.cbarvisible='on';
NSS.units='percent of harvested paddy rice area';
NSS.logicalinclude=isfinite(WetRiceArea);

DataToDrawdownFigures(CurrentAWDUptake*100,NSS,'AdoptionOfNoncontinuousFlooding',MapsAndDataFilename,RegionList);


NSS=BaseNSS
NSS.cmap=ExplorerEffectiveness1;
NSS.caxis=[0 10];
NSS.title='Effectiveness of advanced water management';
%NSS.DisplayNotes={'Data: Hansen et al.','Downloaded Nov 2024'}
NSS.cbarvisible='on';
NSS.units='CO_2-eq/ha';
NSS.logicalinclude=isfinite(WetRiceArea);

DataToDrawdownFigures(CH4EmissionsIntensityImprovementWithAWDUptake,NSS,'EffectivenessOfAdoptionOfNoncontinuousFlooding',MapsAndDataFilename,RegionList);


%% Impact of High-ambition adoption

NSS=BaseNSS
NSS.cmap=ExplorerImpact1;
NSS.caxis=[0 10];
NSS.title='Impact of adoption of advanced water management';
%NSS.DisplayNotes={'Data: Hansen et al.','Downloaded Nov 2024'}
NSS.cbarvisible='on';
NSS.units='CO_2-eq/ha';
NSS.logicalinclude=isfinite(WetRiceArea);

DelUptake=BoUptake-CurrentAWDUptake;
DelUptake(DelUptake<0)=0;

DataToDrawdownFigures(CH4EmissionsIntensityImprovementWithAWDUptake.*DelUptake.*WetRiceArea,NSS,'HighAmbitionImpactOfAdoptionOfNoncontinuousFlooding',MapsAndDataFilename,RegionList);

NSS.caxis=[0 5];
DataToDrawdownFigures(CH4EmissionsIntensityImprovementWithAWDUptake.*DelUptake.*WetRiceArea,NSS,'HighAmbitionImpactOfAdoptionOfNoncontinuousFloodingtightColorAxis',MapsAndDataFilename,RegionList);
DataToDrawdownFigures(CH4EmissionsIntensityImprovementWithAWDUptake.*DelUptake.*WetRiceArea,NSS,'HighAmbitionImpactOfAdoptionOfNoncontinuousFloodingtightColorAxis',MapsAndDataFilename,{'SEAsia'});

