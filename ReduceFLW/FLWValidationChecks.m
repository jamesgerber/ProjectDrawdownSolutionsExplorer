% 'Meat' category is sum of Bovine + Mutton + Pig + Poultry +Other
% 'Meat' for world in 2020 = 333335 (units = 1000t)
% 'Bovine' for world in 2020 = 73726
% 'Mutton/Goat' for world in 2020 = 15574
% Pig:     104423
% Chicken: 133476
%
%


FBS0=ReturnFBSData; % Need list of items here
FBS0=subsetofstructureofvectors(FBS0,FBS0.Year==YYYY)
FullItemsList=unique(FBS0.Item);
FullItemsList=setdiff(FullItemsList,'Alcohol, Non-Food');
FullItemsList=setdiff(FullItemsList,'Grand Total');
FullItemsList=setdiff(FullItemsList,'Animal Products');

F=subsetofstructureofvectors(FBS0,strmatch('Uruguay',FBS0.Area))
F=subsetofstructureofvectors(F,strmatch('Domestic',F.Element))

      pullfromsov(F,'Value','Item','Bovine Meat')
sum(F.Value)

load intermediatedatafiles/FLWresults/FLWCalculationResultsall_Beef_2020.mat
sum(WeightWithReportedFLvect)

load intermediatedatafiles/FLWresults/FLWCalculationResultsproc_Beef_2020.mat
sum(WeightWithReportedFLvect)

load intermediatedatafiles/FLWresults/FLWCalculationResultswaste_Beef_2020.mat
sum(WeightWithReportedFLvect)


load intermediatedatafiles/FLWresults/FLWCalculationResultsall_Chicken_2020.mat
sum(WeightWithReportedFLvect)
sum(WeightWithNoReportedFLvect)

load intermediatedatafiles/FLWresults/FLWCalculationResultsall_Chicken_2020.mat
sum(WeightWithReportedFLvect)
sum(WeightWithNoReportedFLvect)

load intermediatedatafiles/FLWresults/FLWCalculationResultswaste_Egg_2020.mat
sum(WeightWithReportedFLvect)
sum(WeightWithNoReportedFLvect)


load intermediatedatafiles/FLWresults/FLWCalculationResultswaste_Meat_2020.mat
sum(WeightWithReportedFLvect)
sum(WeightWithNoReportedFLvect)