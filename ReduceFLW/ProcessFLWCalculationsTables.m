% script to make a bunch of tables.

% Agricultural production
% Post-harvest handling & storage
% Manufacturing
% Distribution & Retail
% Consumption
% + Total of the five
% + Percent Food wasted;
% + Percent food waste emissions from beef

% some preliminaries
    YYYY=2020;


FBS0=ReturnFBSData; % Need list of items here
FBS0=subsetofstructureofvectors(FBS0,FBS0.Year==YYYY)
FullItemsList=unique(FBS0.Item);
FullItemsList=setdiff(FullItemsList,'Alcohol, Non-Food');
FullItemsList=setdiff(FullItemsList,'Grand Total');
FullItemsList=setdiff(FullItemsList,'Animal Products');

option=2

switch option
    case 1
clear ISOlist
clear CountryNamelist
c=0;
for m=[2 3 4 5 6 7 9 10 11 ]
    c=c+1;
    [ISOlist{c},CountryNamelist{c}]=SEAsia11(m);
end
fid=fopen('intermediatedatafiles/FLWresultsSEAsia.csv','w');
    case 2
        y=load('intermediatedatafiles/FLWresults/FLWCalculationResultsall_AllItems_2020.mat');

ISOlist=y.constructedISOList;
CountryNamelist=y.faocountrynamelistvect;
fid=fopen('intermediatedatafiles/FLWresultsAllCountries.csv','w');




end






fprintf(fid,'name,validation name,ISO,year,WhichLossStages,AllFoodDomesticSupply,AllBeefDomesticSupply,AllFoodPercentWasted,BeefPercentWasted\n');
fprintf(fid,' ,   , , , ,1000 tonnes,1000 tonnes,%%,%%\n');





for jFLW=[1 3:7];
    jItem=2;


    switch jFLW
        case 1
            FLWColumnFlag='all';
        case 2
            FLWColumnFlag='distandcons';
        case 3
            FLWColumnFlag='prod';
        case 4
            FLWColumnFlag='hand';
        case 5
            FLWColumnFlag='proc';
        case 6
            FLWColumnFlag='dist';
        case 7
            FLWColumnFlag='cons';

        otherwise
            error
    end
    switch jItem
        case 1
            ItemsFlag='beef';
        case 2
            ItemsFlag='all';
        case 3
            ItemsFlag='meat'
        case 4
            ItemsFlag='egg'
        case 5
            ItemsFlag='chicken'
        case 6
            ItemsFlag='milk'
        case 7
            warndlg('pigmeat analysis leads to crashing - not reported in some countries')
            ItemsFlag='pig'
        otherwise
            error
    end



    switch FLWColumnFlag
        case 'all'
            iiFLWColumns=[1 2 3 4 5];
            FLWColumntext='allFLWStages';
        case 'distandcons'
            iiFLWColumns=[4 5];
            FLWColumntext='wasteFLWStages';
        case 'prod'
            iiFLWColumns=[1 ];
            FLWColumntext='prodFLWStages';
        case 'hand'
            iiFLWColumns=[2 ];
            FLWColumntext='handFLWStages';
        case 'proc'
            iiFLWColumns=[3 ];
            FLWColumntext='procFLWStages';
        case 'dist'
            iiFLWColumns=[4 ];
            FLWColumntext='distFLWStages';
        case 'cons'
            iiFLWColumns=[5 ];
            FLWColumntext='consFLWStages';
        case 'distandcons'
            iiFLWColumns=[3 ];
            FLWColumntext='distandconsFLWStages';
        otherwise
            error
    end

    switch ItemsFlag
        case {'beef','bovine'};
            ItemText='Beef';
            ItemsList={'Bovine Meat'};
        case {'all'}
            ItemText='AllItems';
            ItemsList=FullItemsList;
        case {'meat'}
            ItemText='Meat';
            ItemsList={'Meat'}
        case 'chicken'
            ItemText='Chicken'
            ItemsList={'Poultry Meat'};
        case 'pig'
            ItemText='Pig'
            ItemsList={'Pigmeat'};
        case 'egg'
            ItemText='Egg'
            ItemsList={'Eggs'};
        case 'milk'
            ItemText='Milk'
            ItemsList={'Butter, Ghee','Milk - Excluding Butter'};
    end


    SaveFileNameText=[FLWColumnFlag '_' ItemText '_' num2str(YYYY)];
    SaveFileNameTextAll=[FLWColumnFlag '_' 'AllItems' '_' num2str(YYYY)];
    SaveFileNameTextBeef=[FLWColumnFlag '_' 'Beef' '_' num2str(YYYY)];


    xBeef=    load(['intermediatedatafiles/FLWresults/FLWCalculationResults' SaveFileNameTextBeef],...
            'DiagnosticPercentageFoodIncludedVect',...
            'AvgFLPercentagevect',...
            'AvgEmissionsFactorvect',...
            'TotalGHGEmissionsCountryvect',...
            'WeightWithNoReportedFLvect',...
            'WeightWithReportedFLvect',...
            'populationvect',...
            'faocountrynamelistvect',...
            'iimapdata',...
            'constructedISOList',...
            'constructedgtapisolist');


   xAll=    load(['intermediatedatafiles/FLWresults/FLWCalculationResults' SaveFileNameTextAll],...
            'DiagnosticPercentageFoodIncludedVect',...
            'AvgFLPercentagevect',...
            'AvgEmissionsFactorvect',...
            'TotalGHGEmissionsCountryvect',...
            'WeightWithNoReportedFLvect',...
            'WeightWithReportedFLvect',...
            'populationvect',...
            'faocountrynamelistvect',...
            'iimapdata',...
            'constructedISOList',...
            'constructedgtapisolist');


    
    
    for m=1:numel(ISOlist)
        ISO=ISOlist{m};
        CountryName=CountryNamelist{m};

    idx=strmatch(ISO,xAll.constructedISOList);
   
    AllFood=sum(xAll.WeightWithNoReportedFLvect(idx)+xAll.WeightWithReportedFLvect(idx));
    AllBeef=sum(xBeef.WeightWithNoReportedFLvect(idx)+xBeef.WeightWithReportedFLvect(idx));
    FoodWastePercent=sum(xAll.AvgFLPercentagevect(idx));
    BeefWastePercent=sum(xBeef.AvgFLPercentagevect(idx));
    
    
    
   fprintf(fid,'%s,%s,%s,%d,%s,%f,%f,%f,%f\n',xAll.faocountrynamelistvect{idx},CountryName,ISO,YYYY,FLWColumntext,AllFood,AllBeef,FoodWastePercent,BeefWastePercent);
end
   

end

fclose(fid)
