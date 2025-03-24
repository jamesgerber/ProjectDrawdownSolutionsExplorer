function [TEC,Production,C2C,AltFuelsRatio,Emissions]=CountrySpecificCementFactors(ISO);
%CountrySpecificCementFactors - return GCCA data
%
%
%  Syntax:
%      [TEC,Production,C2C,AltFuelsRatio,Emissions]=CountrySpecificCementFactors(ISO);
%
% Return data from GCCA.  When GCCA records a region, use data from Climate
% Trace to allocate Production and Emissions accordingly.
%
%  Note: we do not have permission from GCCA to share this data.

persistent b c GCCA

if isempty(c)

    b=readgenericcsv('inputdatafiles/GCCA_RegionGroups.csv');
    GCCA=readgenericcsv('intermediatedatafiles/CementGCCAData.csv');
    c=readgenericcsv('intermediatedatafiles/cement_country_emissions_production_2024.csv');
end


idx=find(strcmp(ISO,b.ISO3));
if isempty(idx)
    TEC=[];
    Production=[];
    C2C=[];
    AltFuelsRatio=[];
    Emissions=[];

    % see if it's in c
    idx=strmatch(ISO,c.GID_0);
    EmissionsThisCountry=str2double(c.emissions_quantity(idx));
    ProductionThisCountry=str2double(c.prod_country_total_megatons(idx));

    Production=ProductionThisCountry;
    Emissions=EmissionsThisCountry;


    return
end
Region=b.Region{idx};
UseGCCAProduction=b.UseGCCAProduction(idx);
ii=strmatch(Region,GCCA.Region);

a=subsetofstructureofvectors(GCCA,ii);

% lots of stupid code below - but i'm pulling in from a previous script.
aTEC=subsetofstructureofvectors(a,strmatch('25aAG',a.TableKey));
aProd=subsetofstructureofvectors(a,strmatch('21TGWcm',a.TableKey));
aC2C=subsetofstructureofvectors(a,strmatch('92AGW',a.TableKey));
TEC=pullfromsov(aTEC,'Value','Region',Region);
% Thermal energy consumption
% Mj/t

RegionalProduction=pullfromsov(aProd,'Value','Region',Region);
% production
%tons

C2C=pullfromsov(aC2C,'Value','Region',Region);

idx=strmatch('25aTGW',a.TableKey);

AltFuelsRatio=(a.Value(idx)+str2double(a.Value2{idx})) / ...
    (a.Value(idx)+str2double(a.Value2{idx})+str2double(a.Value3{idx}));

idx=strmatch('59cTGW',a.TableKey);
RegionalEmissions=a.Value(idx);

% now ... apportion Production and Emissions into the countries in the
% region


iiRegion=strmatch(Region,b.Region);

RegionalISOList=b.ISO3(iiRegion);

% what are the emissions values from c?  need to loop

for j=1:numel(RegionalISOList);
    tmpISO=RegionalISOList{j};
    idx=strmatch(tmpISO,c.GID_0);
    ProductionVect(j)=str2double(c.prod_country_total_megatons(idx));
    EmissionsVect(j)=str2double(c.emissions_quantity(idx));
end

% what are emissions from this country?
idx=strmatch(ISO,c.GID_0);
EmissionsThisCountry=str2double(c.emissions_quantity(idx));
ProductionThisCountry=str2double(c.prod_country_total_megatons(idx));


if isempty(EmissionsThisCountry);
    % No emissions - zero out everything
    TEC=[];
    Production=[];
    C2C=[];
    AltFuelsRatio=[];
    Emissions=[];
    return
end

if UseGCCAProduction==1
    Production=RegionalProduction.*ProductionThisCountry/nansum(ProductionVect);
    Emissions=RegionalEmissions.*EmissionsThisCountry/nansum(EmissionsVect);
else
    Production=ProductionThisCountry;
    Emissions=EmissionsThisCountry;
end



