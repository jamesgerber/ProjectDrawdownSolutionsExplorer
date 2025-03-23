README file for Cement Solution.

This solution relies on data from GCCA (Global Cement and Concrete Association).
Note that this data was provided with the understanding that we can't share
the data.


There are three sub-solutions for the improved cement solution:
(1) Clinker substitution
(2) Alternate fuels
(3) Improved process efficiency

For all of these, we rely on detailed data provided by GCCA.

Here is the calculation process:


importGCCAData('~/DrawdownSolutions/ImproveCement/inputdatafiles/Dradwdown_NGO_GNR_2022.xlsx',...
'~/DrawdownSolutions/ImproveCement/intermediatedatafiles/CementGCCAData.csv');
 this creates CementGCCAData.csv
% 