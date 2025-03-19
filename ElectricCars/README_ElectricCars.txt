Notes for ElectricCars solution

Here is what the calculation looks like:  
% EmissionsFromCars=  (% vehicle km calculation)
%     Ncars.* ...  % number cars
%     D.* ...      % distance per car per year 
%     (etaEV).*W_EV.*...  % fraction EV * kWh/vkm.*CO2-eq/kWh
%     (1-etaEV).*W_ICE;   % (1-etaEV)* (1/mpg)*(m/km)*(CO2-eq/km)
% 
% Emissions=Ncars*D*[(etaEV).*W_EV +(1-etaEV).*W_ICE ];
% % however, this doesn't map to the adoption unit.
% 
% Emissions=Ncars*D*1.5*[(etaEV).*W_EV/1.5 +(1-etaEV).*W_ICE/1.5 ];


Main code is EVcalcs.m

Here are the files that the codes will look for in inputdatafiles/


IEA-EV-dataEV_salesHistoricalCarsnq.txt
# International Energy Association
# downloaded from https://www.iea.org/data-and-statistics/data-tools/global-ev-data-explorer
# jsg downloaded a copy on Mar 19, 2025, confirmed it agreed with what 
# was in the solution.  nq.txt ending is because I turned a .csv into a
# .txt using the utility code csv2tabdelimited, and ran the embedded sed
# command.

OICAExcerpt_PassengerVehicles.csv
# source: International Organization of Motor Vehicle Manufacturers
#  https://www.oica.net/category/vehicles-in-use/
# downloaded PC-World-vehicles-in-use-2020.xlsx, pull out an excerpt.
# Downloaded Mar 19, 2025, confirmed same data that Cameron used.

pkmPerYearPerCountry.xlsx
# I put this together from the data in the solutions assessment spreadsheet.

