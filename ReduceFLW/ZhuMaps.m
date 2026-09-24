% ad-hoc script to map the quantities in zhu et al




g0=getgeo41_g0;

%a=readgenericcsv('inputdatafiles/ZhuData_CourtesyOfAuthors_reformatted.csv');
a=readgenericcsv('inputdatafiles/ZhuData_CourtesyOfAuthors_reformatted.txt',1,tab,0);

GHG_emissions_per_ton_wasted_food_map=datablank*nan;
PercentWastedAnimal_map=datablank*nan;
GHGEmissionIfReduceTo25Percent_map=datablank*nan;

clear DS
for j=1:164

    countryname=a.Country_region_name{j};
    GHG_emissions_per_ton_wasted_food=str2double(a.GHG_emissions_per_ton_of_wasted_food_per_country_ton_ton{j});
    PercentWastedAnimal=str2double(strrep(a.Percentage_of_wasted_food_that_is_in_the_Meat_and_Animal_Products_category{j},'%',''));
    GHGEmissionIfReduceTo25Percent=str2double(a.Val25_GHG_emissions_of_global_FLW_GtCO2e{j});



    idx=strmatch(countryname,g0.namelist0,'exact');

    if numel(idx)==1
        [g00,ii]=getgeo41_g0(idx);

    else
        switch countryname

            case 'Congo'
                [g00,ii]=getgeo41_g0('COD');

            case 'Cte d''Ivoire'
                [g00,ii]=getgeo41_g0('CIV');
            case 'Sao Tome and Principe'
                [g00,ii]=getgeo41_g0('STP');

            case 'United Republic of Tanzania'
                [g00,ii]=getgeo41_g0('TZA');
            case 'India'
                [g00,ii]=getgeo41_g0('IND');
            case 'Iran (Islamic Republic of)'
                [g00,ii]=getgeo41_g0('IRN');
            case 'Pakistan'
                [g00,ii]=getgeo41_g0('PAK');
            case 'Brunei Darussalam'
                [g00,ii]=getgeo41_g0('BRN');
            case 'China'
                [g00,ii]=getgeo41_g0('CHN');
            case 'Democratic People''s Republic of Korea'
                [g00,ii]=getgeo41_g0('PRK');
            case 'Lao People''s Democratic Republic'
                [g00,ii]=getgeo41_g0('LAO');
            case 'Korea'
                [g00,ii]=getgeo41_g0('KOR');
            case 'Viet Nam'
                [g00,ii]=getgeo41_g0('VNM');
            case 'Republic of Moldova'
                [g00,ii]=getgeo41_g0('MDA');
            case 'Russian Federation'
                [g00,ii]=getgeo41_g0('RUS');
            case 'United Kingdom of Great Britain and Northern Ireland'
                [g00,ii]=getgeo41_g0('GBR');
            case 'United States of America'
                [g00,ii]=getgeo41_g0('USA');
            case 'Bolivia (Plurinational State of)'
                [g00,ii]=getgeo41_g0('BOL');
            case 'Mexico'
                [g00,ii]=getgeo41_g0('MEX');
            case 'Venezuela (Bolivarian Republic of)'
                [g00,ii]=getgeo41_g0('VEN');

            otherwise
                countryname

        end
    end

    GHG_emissions_per_ton_wasted_food_map(ii)=GHG_emissions_per_ton_wasted_food;
    PercentWastedAnimal_map(ii)=PercentWastedAnimal;
    GHGEmissionIfReduceTo25Percent_map(ii)=GHGEmissionIfReduceTo25Percent;
    %%
DS.ISO{j}=char(g00.gadm0codes);
DS.CountryName{j}=char(g00.namelist0);
DS.PercentAnimalProductsInFLW(j)=PercentWastedAnimal;

end
sov2csv(DS,'ZhuFLWMapData.csv');

NSS=getDrawdownNSS;
NSS.title='Emissions per ton wasted food';
NSS.units='tons CO_2eq / ton';
NSS.cmap=ExplorerEffectiveness1;
DataToDrawdownFigures(GHG_emissions_per_ton_wasted_food_map,NSS,'EmissionsPerTonWaste','FoodWasteMapsAndDataZhu/')



NSS=getDrawdownNSS;
NSS.title='Percent of animal products in food waste';
NSS.units='%';
NSS.cmap='white_purple_red';
DataToDrawdownFigures(PercentWastedAnimal_map,NSS,'PercentOfAnimalProductsInFoodWaste','FoodWasteMapsAndDataZhu/')
