load   '/Users/jsgerber/sandbox/jsg216_MappingIndividualSolutions/StatusQuoEmissionsData/EMBER/emberdata'



for j=1:numel(ccode);
try
    [W_EV,EmissionsIntensity(j)]=ReturnCO2PerkmEV(ccode{j});
end
end
