% make maps for improving diet emissions
%
%


RegionList={''};
MapsAndDataFilename='ShiftDietsMapsAndData'
a=readgenericcsv('inputdatafiles/countrytoregionnq.txt',1,tab,1);
b=readgenericcsv('inputdatafiles/RuminantMeatnq.txt',1,tab,1);


HighAdoptionEmissionsReductionMap=datablank;
pcconsumptionmap=datablank;
nationalruminantconsumptionemissionsmap=datablank;
BaseNSS=getDrawdownNSS;

c=0;
for j=1:263

    [g0,ii,name,ISO]=getgeo41_g0(j);

    idx=strmatch(ISO,a.Country_Code);

    if numel(idx)>0

if numel(idx)>1
    ISO
    keyboard
end

        FAOName=a.Country{idx};

        jdx=strmatch(FAOName,b.Country);

        if numel(jdx)==1;
            pcc=b.Per_capita_consumption(jdx);
            pcconsumptionmap(ii)=pcc;
            HighAdoptionEmissionsReduction=b.High_adoption_emissions_reduction_tons_CO2_eq_kg(jdx);
            HighAdoptionEmissionsReduction=max(HighAdoptionEmissionsReduction,0);
            HighAdoptionEmissionsReductionMap(ii)=HighAdoptionEmissionsReduction;
            nationalruminantconsumptionemissionstonsco2eq=b.Total_ruminant_meat_kg(jdx).*.075;
            % .075 = Total emissions of ruminant meat per kilogram per
            % year, 100 year basis, CO2-eq from Improve Diets Assessment
            % Spreadsheet
            nationalruminantconsumptionemissionsmap(ii)=nationalruminantconsumptionemissionstonsco2eq;

            c=c+1;
            ISOlist{c}=ISO;
            HighAdoptionEmissionsReductionList(c)=HighAdoptionEmissionsReduction;
            PerCapitaConsumptionList(c)=pcc;
            NationalRumConsEmsList(c)=nationalruminantconsumptionemissionstonsco2eq;
        else
        end
    end
end

% Maps
clear DS
DS.ISO=ISOlist;
DS.HighAdoptionEmissionsReductiontonspercountry=HighAdoptionEmissionsReductionList;
DS.PerCapitaConsumptionkgperyear=PerCapitaConsumptionList;
DS.NationalRuminantConsumptionEmissionsList=NationalRumConsEmsList;

mkdir(MapsAndDataFilename)
sov2csv(DS,[MapsAndDataFilename '/VectorDataShiftDiets.csv'])


% Context

NSS=BaseNSS;
NSS.cmap=eggplant;
NSS.caxis=[.99];
NSS.title='Per capita ruminant meat consumption';
%NSS.DisplayNotes={'Data: Hansen et al.','Downloaded Nov 2024'}
NSS.cbarvisible='on';
NSS.units='kg/person/yr';
DataToDrawdownFigures(pcconsumptionmap,NSS,'PerCapitaRuminantMeatConsumption',MapsAndDataFilename,RegionList);


% Emissions

NSS=BaseNSS;
NSS.cmap=ExplorerEmissions1;
NSS.caxis=[.99];
NSS.title='Emissions, ruminant meat consumption';
%NSS.DisplayNotes={'Data: Hansen et al.','Downloaded Nov 2024'}
NSS.cbarvisible='on';
NSS.units='tons CO_2-eq/yr';
DataToDrawdownFigures(nationalruminantconsumptionemissionsmap,NSS,'EmissionsRuminantConsumption',MapsAndDataFilename,RegionList);

% Impact

NSS=BaseNSS;
NSS.cmap=ExplorerImpact1;
NSS.caxis=[.99];
NSS.title='Impact, high ambition adoption of diet change.'
%NSS.DisplayNotes={'Data: Hansen et al.','Downloaded Nov 2024'}
NSS.cbarvisible='on';
NSS.units='tons CO_2-eq/yr';
DataToDrawdownFigures(HighAdoptionEmissionsReductionMap,NSS,'Impact_HighAmbitionAdoption',MapsAndDataFilename,RegionList);

