README file for Cement Solution.

This solution relies on data from GCCA (Global Cement and Concrete Association).
Note that this data was provided with the understanding that we can't share
the data.


There are three sub-solutions for the improved cement solution:
(1) Clinker substitution
(2) Alternate fuels
(3) Improved process efficiency

For all of these, we rely on detailed data provided by GCCA.

Input files and sources
Dradwdown_NGO_GNR_2022.xlsx - provided by GCCA 
cement_country_emissions_production_2024.csv - this was provided by Alex Sweeney and contains data from Climate Trace
GCCA_RegionGroups.csv - relates ISO country codes to the GCCA regions
 XXXXX.csv - 


Here is the calculation process:


importGCCAData.m - a preprocessing step that parses the .xlsx data using matlab-written
import functions and then some jsg-written functions to pull out the relevant data which
is stored in the file CementGCCAData.csv (which is created now)

CountrySpecificCementFactors.m - returns the factors necessary to calculate effectiveness,
adoption, and impact.   The three functions below each call this.


A note on production values:
Tons of cement Production is necessary for calculation solution uptake.  However,
GCCA provides production as a regional aggregate.  For simplicity, we use
production data from ClimateTrace.  We have verified that the numbers are
similar for the cases where GCCA provides data for a single country.
The code was written to allow us to apportion the production reported by GCCA 
for a region in proportion to the amounts reported by Climate Trace, but
this isn't used (to change this, set UseGCCAProduction to 1 in GCCA_RegionGroups.csv)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ThermalEfficiencyCalcs.m    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Some calculation notes:
This code originally mapped a few different versions of adoption:
1) Value of thermal efficiency in Joules energy per ton cement
2) Adoption in terms of tons of concrete produced cleanly
3) Adoption as a percentage of concrete that is produced cleanly

Only the first one of those is the "real" definition of adoption.  I have 
commented out #2 and #3 in the code - there is no way to define them that
doesn't have some arbitrary way of going from 0 uptake to 100% uptake (to
explain this by analogy, what is half-way between a car with 10mpg and a car
with 30 mpg? - multiple ways to calculate)

The calculation of emissions for each country is as follows:
Emissions=Prod*C2C*TEC*EmissionsPerThermalEnergy
  
Prod                      = production in tons
C2C                       = clinker to cement ratio
TEC                       = thermal efficiency coefficient
EmissionsPerThermalEnergy = globally constant emissions per joule


TEC is obtained for each country from GCCA data
this Emissions equation is also carried out for TEC values corresponding
to worst-case emissions, baseline, low-ambition, high-ambition, and 
ceiling-ambition adoption

Impact of current adoption is calculated by comparison to the worst-case emissions.
Worst-case emissions assumes a TEC of 3914.7, which is the highest value observed
for the latest year in the dataset.



%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Clinker Substitution    %
% ClinkerSubstition.m     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%

Emissions associated with clinker substitution is calculated as follows:

todayemissionsvalue=Prod*(SP/100)*0.24;

where 
Prod = production in Mt
0.24 = Solution effectiveness (t CO2-eq/t cement)
SP   = "substition percent"

SP=95-C2C*100;
C2C = clinker to cement ratio
95 represents highst possible value

This solution / code is structured a bit differently than in 
thermalefficiencycalcs.m:
 the emissions layers are calculated as relative changes



%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Alternate fuels         %
% AltFuelsCement.m        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%

Emissions associated with use alt fuels calculated as follows:

Emissions = Production * AltFuelsRatio * Effectiveness

where
Effectiveness=0.096  t CO2-eq/t cement
Production = t cement
AFR = Alt Fuels Ratio, which is determined from the GCCA data as the ratio 
(Falt+Fbiomass)/(Falt+Fbiomass+Ffossil)
Falt = alternate fossil and mixes wastes
Fbiomass = biomass
Ffossil = fossil fuel

Solution code is modeled closely on Clinker Substitution.







