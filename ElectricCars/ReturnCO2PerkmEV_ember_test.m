function [W_EV,EmissionsIntensity]=ReturnCO2PerkmEV_ember_test(ISO);
% return CO2 emissions per km EV

% Use Our World in Data 
%https://ourworldindata.org/grapher/carbon-intensity-electricity.csv?v=1&csvType=full&useColumnShortNames=true

persistent a
if isempty(a)
    %    a=readgenericcsv('inputdatafiles/carbon-intensity-electricity.csv');
    a=readgenericcsv('inputdatafiles/yearly_full_release_long_format.txt',1,tab,1);
end


%idx=strmatch(ISO,a.Code);
%b=subsetofstructureofvectors(a,idx);



%maxyear=max(b.Year);
maxyear=2023

%idx=find(b.Year==maxyear);

b=subsetofstructureofvectors(a,strmatch('CO2 intensity',a.Variable))

idx=strmatch(ISO,b.ISO_3_code);
b=subsetofstructureofvectors(b,idx);


%EmissionsIntensity=b.Carbon_intensity_of_electricity_gCO2_kWh(idx);
idx=find(b.Year==maxyear);
EmissionsIntensity=b.Value(idx);

kwhperkm=0.186;   % this is the median value in the spreadsheet (T263:T690 of the Ref Cars Emissions sheet, pull out Mon, Mar 10 2025)



W_EV=EmissionsIntensity*kwhperkm;

if isempty(W_EV)
    W_EV=nan;
end



