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

ThermalEfficiencyCalcs.m


Some calculation notes:
Tons of cement Production is necessary for calculation solution uptake.  However,
GCCA provides production as a regional aggregate.   For the single country regions, 
we use the GCCA data.   For other countries we use the production data from ClimateTrace.  
 There are some cases where we apportion the production reported by GCCA for a region 
 in proportion to the amounts reported by Climate Trace.
