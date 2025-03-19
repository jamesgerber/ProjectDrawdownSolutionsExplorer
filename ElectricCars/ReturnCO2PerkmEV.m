function [W_EV,EmissionsIntensity]=ReturnCO2PerkmEV(ISO);
% return CO2 emissions per km EV

% Use Our World in Data 
%https://ourworldindata.org/grapher/carbon-intensity-electricity.csv?v=1&csvType=full&useColumnShortNames=true

persistent a
if isempty(a)
    a=readgenericcsv('carbon-intensity-electricity.csv');
end


idx=strmatch(ISO,a.Code);
b=subsetofstructureofvectors(a,idx);

maxyear=max(b.Year);


idx=find(b.Year==maxyear);

EmissionsIntensity=b.Carbon_intensity_of_electricity_gCO2_kWh(idx);


kwhperkm=0.186;   % this is the median value in the spreadsheet (T263:T690 of the Ref Cars Emissions sheet, pull out Mon, Mar 10 2025)



W_EV=EmissionsIntensity*kwhperkm;

if isempty(W_EV)
    W_EV=nan;
end



