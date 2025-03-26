
% Here are the steps

% This assumes that matlab is in a working directory that contains
% the directory inputdatafiles

%Dradwdown_NGO_GNR_2022.xlsx
%GCCA_RegionGroups.csv
%GNR_country regions.xlsx
%cement_country_emissions_production_2024.csv

if ~isdir('inputdatafiles')
    error('Can''t find inputdatafiles/  this will end in tears.')
end

% make 'intermediatedatafiles
mkdir intermediatedatafiles/

ParseDataFromGCCA('inputdatafiles/Dradwdown_NGO_GNR_2022.xlsx','intermediatedatafiles/CementGCCAData.csv')


AltFuelsCement
ClinkerSubstitution
ThermalEfficiencyCalcs