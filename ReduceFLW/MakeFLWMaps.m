% I (jsg) am rewriting this code Jan 2026.  Previously maps were made in
% 'ProcessFLWCalculations.m' but that code is a bit of a mismash of earlier
% versions, and relies on running previous codes and having things in the
% workspace.  boo.
%
%

%% first load in files:
YYYY=2020;
FLWColumnFlag='all';
SaveFileNameTextAll=[FLWColumnFlag '_' 'AllItems' '_' num2str(YYYY)];
SaveFileNameTextBeef=[FLWColumnFlag '_' 'Beef' '_' num2str(YYYY)];


xBeef=    load(['intermediatedatafiles/FLWresults/FLWCalculationResults' SaveFileNameTextBeef],...
    'DiagnosticPercentageFoodIncludedVect',...
    'AvgFLPercentagevect',...
    'AvgEmissionsFactorvect',...
    'TotalGHGEmissionsTonnesCountryvect',...
    'WeightWithNoReportedFLvect',...
    'WeightWithReportedFLvect',...
    'populationvect',...
    'populationvectFAO',...
    'faocountrynamelistvect',...
    'iimapdata',...
    'constructedISOList',...
    'constructedgtapisolist');


xAll=    load(['intermediatedatafiles/FLWresults/FLWCalculationResults' SaveFileNameTextAll],...
    'DiagnosticPercentageFoodIncludedVect',...
    'AvgFLPercentagevect',...
    'AvgEmissionsFactorvect',...
    'TotalGHGEmissionsTonnesCountryvect',...
    'WeightWithNoReportedFLvect',...
    'WeightWithReportedFLvect',...
    'populationvect',...
    'populationvectFAO',...
    'faocountrynamelistvect',...
    'iimapdata',...
    'constructedISOList',...
    'constructedgtapisolist');


%%
populationvect=xAll.populationvect;

EmissionsMap=datablank;
WastePercentageMap=datablank;
PercentageLossMap=datablank;
WastePercentageMap=datablank;
PercentageFoodIncludedMap=datablank;
EmissionsPerCapitaMap=datablank;
EmissionsFactorMap=datablank;
TonsWastedPerCapitaMap=datablank;
TonsWastedMap=datablank;
TotalFoodPerCapitaMap=datablank;
PopulationMap=datablank;

populationvect(populationvect==0)=nan;  % so they fall out ofmaps
%xAll=xBeef;
clear DS


for j=1:numel(populationvect);

    iimap=xAll.iimapdata{j};
    EmissionsMap(iimap)=xAll.TotalGHGEmissionsTonnesCountryvect(j);
    WastePercentageMap(iimap)=xAll.AvgFLPercentagevect(j);

    PercentageLossMap(iimap)=xAll.AvgFLPercentagevect(j);
    %    PercentageFoodIncludedMap(iimap)=WeightWithNoReportedFL/(WeightWithNoReportedFL+WeightWithReportedFL);
    %    EmissionsMap(iimap)=TotalGHGEmissionsCountry;
    EmissionsPerCapitaMap(iimap)=xAll.TotalGHGEmissionsTonnesCountryvect(j)./xAll.populationvectFAO(j);
    EmissionsFactorMap(iimap)=xAll.AvgEmissionsFactorvect(j);
    TonsWastedPerCapitaMap(iimap)=xAll.WeightWithReportedFLvect(j).*xAll.AvgFLPercentagevect(j)./xAll.populationvectFAO(j)/100;
    TonsWastedMap(iimap)=1000*xAll.WeightWithReportedFLvect(j).*xAll.AvgFLPercentagevect(j)/100;
    TotalFoodPerCapitaMap(iimap)=(xAll.WeightWithReportedFLvect(j)+xAll.WeightWithNoReportedFLvect(j))/xAll.populationvect(j);
    PopulationMap(iimap)=xAll.populationvectFAO(j);

    DS.ISO{j}=xAll.constructedISOList{j};
    DS.countryname{j}=xAll.faocountrynamelistvect{j};
    DS.FoodWastedPerCapita(j)=xAll.WeightWithReportedFLvect(j).*xAll.AvgFLPercentagevect(j)./xAll.populationvectFAO(j)/100*1e6;
    DS.EmissionsNationalLevelMt(j)=xAll.TotalGHGEmissionsTonnesCountryvect(j)/1e6;

end

sov2csv(DS,'GattoBasedFLWEmissionsDataForMapping.csv');
logicalinclude=WastePercentageMap>0;

NSS=getDrawdownNSS;
NSS.caxis=.99;
NSS.cmap='white_purple_red';
NSS.title='Food waste per capita';
NSS.units='kg/person/year';
NSS.logicalinclude=logicalinclude;
OS=nsg(TonsWastedPerCapitaMap*1000,NSS)
maketransparentoceans_noant_nogridlinesnostates_removeislands('temp.png','FWTonsPerCapita_Cols4and5_cmap1.png',[1 1 1],1);
DataToDrawdownFigures(TonsWastedPerCapitaMap*1000,NSS,'TonsWastedPerCapita','FoodWasteMapsAndData')


NSS=getDrawdownNSS;
NSS.caxis=[.99];
NSS.title='Food waste emissions';
NSS.units='Gt CO_2-eq/yr';
NSS.cmap='dark_orange_red';
NSS.logicalinclude=logicalinclude;
DataToDrawdownFigures(EmissionsMap/1e9,NSS,'FoodWasteEmissions','FoodWasteMapsAndData')
OS=nsg(EmissionsMap/1e6,NSS)
maketransparentoceans_noant_nogridlinesnostates_removeislands('temp.png','FWEmissions_Cols4and5.png_cmap3',[1 1 1],1);


NSS=getDrawdownNSS;
NSS.caxis=[.99];
NSS.title='tons wasted per capita';
NSS.units='tons/';
NSS.cmap='dark_orange_red';
NSS.logicalinclude=logicalinclude;
