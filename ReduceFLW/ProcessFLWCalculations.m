%ProcessFLWCalculations - script to postprocess FLW calculations.  See
%CalculationsOfFLW.m
%
% 

makemaps=0;
maketables=1;
ISOList=SEAsia11;

if maketables==1
% Agricultural production	
% Post-harvest handling & storage	
% Manufacturing
% Distribution & Retail
% Consumption
% + Total of the five
% + Percent Food wasted;
% + Percent food waste emissions from beef

ProcessFLWCalculationsTables


end


if makemaps==1
    %%

% need to construct maps

EmissionsMap=datablank;
WastePercentageMap=datablank;
PercentageLossMap=datablank;
WastePercentageMap=datablank;
PercentageFoodIncludedMap=datablank;
EmissionsPerCapitaMap=datablank;
EmissionsFactorMap=datablank;
TonsWastedPerCapitaMap=datablank;
TonsWastedMap=datablank;

populationvect(populationvect==0)=nan;  % so they fall out ofmaps

for j=1:numel(populationvect);

    iimap=iimapdata{j};
    EmissionsMap(iimap)=TotalGHGEmissionsCountryvect(j);
    WastePercentageMap(iimap)=AvgFLPercentagevect(j);

    PercentageLossMap(iimap)=AvgFLPercentagevect(j);
    %    PercentageFoodIncludedMap(iimap)=WeightWithNoReportedFL/(WeightWithNoReportedFL+WeightWithReportedFL);
    %    EmissionsMap(iimap)=TotalGHGEmissionsCountry;
    EmissionsPerCapitaMap(iimap)=TotalGHGEmissionsCountryvect(j)/populationvect(j);
    EmissionsFactorMap(iimap)=AvgEmissionsFactorvect(j);
    TonsWastedPerCapitaMap(iimap)=1000*WeightWithReportedFLvect(j)/populationvect(j);
    TonsWastedMap(iimap)=1000*WeightWithReportedFLvect(j);
end



    logicalinclude=WastePercentageMap>0;
    % got to FBS and get all



    NSS=getDrawdownNSS;
    NSS.caxis=[.99];
    NSS.title='Food waste emissions';
    NSS.units='Mtons CO_2-eq/yr';
    NSS.cmap='dark_orange_red';
    NSS.logicalinclude=logicalinclude;
    DataToDrawdownFigures(EmissionsMap/1e6,NSS,'FoodWasteEmissions','FoodWasteMapsAndData')
    OS=nsg(EmissionsMap/1e6,NSS)
    maketransparentoceans_noant_nogridlinesnostates_removeislands('temp.png','FWEmissions_Cols4and5.png_cmap3',[1 1 1],1);



    clear NSS
    NSS.caxis=[0 .5];
    NSS.title='FW Emissions per capita';
    NSS.units='tons CO_2-eq/person/year';
    NSS.logicalinclude=logicalinclude;
    nsg(EmissionsPerCapitaMap,NSS)

    NSS=getDrawdownNSS;
    NSS.caxis=[0 .5];
    NSS.title='Food waste emissions per capita';
    NSS.units='tons CO_2-eq/person/year';
    NSS.cmap='white_purple_red';
    NSS.logicalinclude=logicalinclude;
    OS=nsg(EmissionsPerCapitaMap,NSS)
    maketransparentoceans_noant_nogridlinesnostates_removeislands('temp.png','FWEmissionsPerCapita_Cols4and5.png',[1 1 1],1);
    DataToDrawdownFigures(EmissionsPerCapitaMap,NSS,'EmissionsPerCapita','FoodWasteMapsAndData')


    NSS=getDrawdownNSS;
    NSS.caxis=[0 .5];
    NSS.title='Food waste emissions per capita';
    NSS.units='tons CO_2-eq/person/year';
    NSS.cmap='dark_orange_red';
    NSS.logicalinclude=logicalinclude;
    OS=nsg(EmissionsPerCapitaMap,NSS)
    maketransparentoceans_noant_nogridlinesnostates_removeislands('temp.png','FWEmissionsPerCapita_Cols4and5_cmap3.png',[1 1 1],1);
    DataToDrawdownFigures(EmissionsPerCapitaMap,NSS,'EmissionsPerCapitaOrange','FoodWasteMapsAndData')




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
    NSS.caxis=.99;
    NSS.cmap='white_blue_purple';
    NSS.title='Food waste per capita';
    NSS.units='kg/person/year';
    NSS.logicalinclude=logicalinclude;
    OS=nsg(TonsWastedPerCapitaMap*1000,NSS)
    maketransparentoceans_noant_nogridlinesnostates_removeislands('temp.png','FWTonsPerCapita_Cols4and5_cmap2.png',[1 1 1],1);
    DataToDrawdownFigures(TonsWastedPerCapitaMap*1000,NSS,'TonsWastedPerCapitaBlue','FoodWasteMapsAndData')


    NSS=getDrawdownNSS;
    NSS.caxis=.99;
    NSS.cmap='dark_orange_red';
    NSS.title='Food waste per capita';
    NSS.units='kg/person/year';
    NSS.logicalinclude=logicalinclude;
    OS=nsg(TonsWastedPerCapitaMap*1000,NSS)
    maketransparentoceans_noant_nogridlinesnostates_removeislands('temp.png','FWTonsPerCapita_Cols4and5_cmap3.png',[1 1 1],1);
    DataToDrawdownFigures(TonsWastedPerCapitaMap*1000,NSS,'TonsWastedPerCapitaOrange','FoodWasteMapsAndData')



    NSS=getDrawdownNSS;

    NSS.caxis=.99;
    NSS.title='Percent Food Wasted';
    NSS.units='%';
    NSS.cmap='white_purple_red';
    OS=nsg(WastePercentageMap,NSS)
    maketransparentoceans_noant_nogridlinesnostates_removeislands('temp.png','PercentFoodWasted_Cols4and5_cmap2.png',[1 1 1],1);
    DataToDrawdownFigures(WastePercentageMap,NSS,'WastePercentage','FoodWasteMapsAndData')


    NSS=getDrawdownNSS;

    NSS.caxis=.99;
    NSS.title='Percent Food Wasted';
    NSS.units='%';
    NSS.cmap='dark_orange_red';
    NSS.logicalinclude=logicalinclude;
    OS=nsg(WastePercentageMap,NSS)
    maketransparentoceans_noant_nogridlinesnostates_removeislands('temp.png','PercentFoodWasted_Cols4and5_cmap3.png',[1 1 1],1);
    DataToDrawdownFigures(WastePercentageMap,NSS,'WastePercentageOrange','FoodWasteMapsAndData')



    NSS=getDrawdownNSS;

    NSS.caxis=.99;
    NSS.title='Average emissions intensity of wasted food';
    NSS.units='kg CO_2-eq/ kg';
    NSS.cmap='white_purple_red';
    NSS.logicalinclude=logicalinclude;
    OS=nsg(EmissionsFactorMap,NSS)
    maketransparentoceans_noant_nogridlinesnostates_removeislands('temp.png','EmissionsFactorMap_Cols4and5_cmap2.png',[1 1 1],1);
    DataToDrawdownFigures(EmissionsFactorMap,NSS,'EmissionsFactor','FoodWasteMapsAndData')



    NSS=getDrawdownNSS;

    NSS.caxis=.99;
    NSS.title='Average emissions intensity of wasted food';
    NSS.units='kg CO_2-eq/ kg';
    NSS.cmap='dark_orange_red';
    NSS.logicalinclude=logicalinclude;
    OS=nsg(EmissionsFactorMap,NSS)
    maketransparentoceans_noant_nogridlinesnostates_removeislands('temp.png','EmissionsFactorMap_Cols4and5_cmap3.png',[1 1 1],1);
    DataToDrawdownFigures(EmissionsFactorMap,NSS,'EmissionsFactorOrange','FoodWasteMapsAndData')



    %if 3==4
    x=load('workingbeefonly.mat','EmissionsPerCapitaMap');
    y=load('workingallmaps.mat','EmissionsPerCapitaMap');

    NSS=getDrawdownNSS;

    NSS.caxis=.99;
    NSS.title='Percent food waste emissions from beef';
    NSS.units='%';
    NSS.cmap='white_purple_red';
    OS=nsg(x.EmissionsPerCapitaMap./y.EmissionsPerCapitaMap,NSS)
    maketransparentoceans_noant_nogridlinesnostates_removeislands('temp.png','BeefEmissionsRatio_Cols4and5_cmap2.png',[1 1 1],1);
    DataToDrawdownFigures(x.EmissionsPerCapitaMap./y.EmissionsPerCapitaMap,NSS,'EmissionsFromBeef','FoodWasteMapsAndData')


    NSS=getDrawdownNSS;

    NSS.caxis=.99;
    NSS.title='Percent food waste emissions from beef';
    NSS.units='%';
    NSS.cmap='dark_orange_red';
    OS=nsg(x.EmissionsPerCapitaMap./y.EmissionsPerCapitaMap*100,NSS)
    NSS.logicalinclude=logicalinclude;
    maketransparentoceans_noant_nogridlinesnostates_removeislands('temp.png','BeefEmissionsRatio_Cols4and5_cmap3.png',[1 1 1],1);
    DataToDrawdownFigures(x.EmissionsPerCapitaMap./y.EmissionsPerCapitaMap,NSS,'EmissionsFromBeefOrange','FoodWasteMapsAndData')
    %end


end

