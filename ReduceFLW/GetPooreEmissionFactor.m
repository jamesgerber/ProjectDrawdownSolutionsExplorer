function EF=GetPooreEmissionFactor(FBSCode,FBSItemName)


%SimplefoodwasteGHGcomparisons = ImportPoore("/Users/jsgerber/sandbox/jsg216_MappingIndividualSolutions/Sol24_ReduceFoodLossAndWaste/flwfromgattotables/Simple-food-waste-GHG-comparisonsPlus.csv", [2, Inf]);

persistent SimplefoodwasteGHGcomparisons FBSToPoore

if isempty(FBSToPoore)
SimplefoodwasteGHGcomparisons = ImportPoorePlus("inputdatafiles/Simple-food-waste-GHG-comparisonsPlus.csv", [2, Inf]);

FBSToPoore = FBStoPoore("inputdatafiles/FBSToPoore.xlsx", "Sheet1", [2, Inf]);
end

% first look up
idx=find(SimplefoodwasteGHGcomparisons.FBSIVCode==FBSCode);


if numel(idx)==1
    EF=SimplefoodwasteGHGcomparisons.SUMkg(idx);
else

    idx=find(FBSCode==FBSToPoore.FBSItem_Code);
    PooreCode=FBSToPoore.UniqueCode(idx);

if isempty(idx)
   warning('fuck ... something wrong')
    PooreCode=9999;
end


    if isequal(PooreCode,9999)
        EF=nan;
        return
    end
    FBSCode,FBSItemName
    jdx=find(PooreCode==SimplefoodwasteGHGcomparisons.UniqueCode);

    EF=SimplefoodwasteGHGcomparisons.SUMkg(jdx);

end


% %
% %
% % idx=find(SimplefoodwasteGHGcomparisons.FBSIVCode==FBSCode);
% %
% %
% % if numel(idx)==1
% %     EF=SimplefoodwasteGHGcomparisons.SUMkg(idx);
% % else
% %
% %   %  disp([char(FBSItemName) ' has no unique match; FBSCode=' int2str(FBSCode)]);
% %     disp([int2str(FBSCode) ]);
% %     EF=nan;
% % end