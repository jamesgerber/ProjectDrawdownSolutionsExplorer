% This script calculates Food Loos and Waste.  It is uses Gatto et al to
% calculate weight of food loss at various stages from agricultural
% production to processing to consumer.   It uses Poore and Nemececk to
% relate that weight to emissions.
%
% This code is based on makecalculationsISOLoopsWithEmissions.m in
% jgerber's sandbox directory (216 ... sol 24) but i am restructuring so
% that first the code is run one or more times for desired combinations of
% FLW stages and which commodities and outputs intermediate quantities,
% then can make comparative calculations.
%
% Some notes: need to loop over GTAP "countries", many GTAP "countries" are single
% countries, but some are groups of countries.
%
% Some notes:
%

%

for jFLW=1:7
    for jItem=1:6;

        FLWColumnFlag='all';
        ItemsFlag='beef';
        YYYY=2020;

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

        FBS0=ReturnFBSData; % Need list of items here
        FBS0=subsetofstructureofvectors(FBS0,FBS0.Year==YYYY)
        FullItemsList=unique(FBS0.Item);
        FullItemsList=setdiff(FullItemsList,'Alcohol, Non-Food');
        FullItemsList=setdiff(FullItemsList,'Grand Total');
        FullItemsList=setdiff(FullItemsList,'Animal Products');


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

        %% clear some loop variables
        clear('DiagnosticPercentageFoodIncludedVect',...
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

        %% population
        [b,r]=geotiffread('inputdatafiles/gpw_v4_population_count_adjusted_to_2015_unwpp_country_totals_rev11_2020_2pt5_min.tif');
        pop=aggregate_quantity(b',2);
        pop(~isfinite(pop))=0;
        pop(pop<0)=0;
        clear b

        a=readgenericcsv('inputdatafiles/rawtablesforextraction/GTAP-FLW_Gatto-2024.csv')
        TableS13Full = importfile1("/Users/jsgerber/sandbox/jsg216_MappingIndividualSolutions/Sol24_ReduceFoodLossAndWaste/flwfromgattotables/TableS13Full.csv", [2, Inf]);
        SimplefoodwasteGHGcomparisons = ImportPoore("/Users/jsgerber/sandbox/jsg216_MappingIndividualSolutions/Sol24_ReduceFoodLossAndWaste/flwfromgattotables/Simple-food-waste-GHG-comparisons.csv", [2, Inf]);
        gtapgeostruct=getgtapgeostruct;
        b.FBS_commodity=TableS13Full.FBSCommodity;
        b.FLW_commodity_group=TableS13Full.FLWCommodityGroup;
        b.GTAP_sector=TableS13Full.GTAPSector;

        fid=fopen('intermediatedatafiles/diagnostics.csv','w');
        fprintf(fid,'faocountryname,iso,ISO,Item,wtfflag,flagtext,FLPercentage,ItemWeight\n');

        PercentageLossMap=datablank;
        PercentageFoodIncludedMap=datablank;
        EmissionsMap=datablank;
        CO2EmissionsMap=datablank;
        CH4CO2eqEmissionsMap=datablank;
        EmissionsPerCapitaMap=datablank;
        TonsWastedPerCapitaMap=datablank;
        TonsWastedMap=datablank;
        WastePercentageMap=datablank;
        EmissionsFactorMap=datablank;
        %fid=1

        countrycount=0;
        for jcountry=1:numel(a.GTAP_Country);

            gtapiso=a.GTAP_Country{jcountry};
            ISO=upper(gtapiso);
            region=a.Mapping_to_FLW_data_regions{jcountry};


            switch region
                case 'North America & Oceania'
                    SheetNo=3;
                case 'Western Europe'
                    SheetNo=1;
                case 'Eastern Europe'
                    SheetNo=2;
                case 'High-income Asia'
                    SheetNo=4;
                case  {'Middle-East & North Africa'}
                    SheetNo=5;
                case {'Latin America & Caribbean' }
                    SheetNo=6;
                case 'Southeast Asia'
                    SheetNo=7;
                case 'Sub-Saharan Africa'
                    SheetNo=8;
                case 'China'
                    SheetNo=9;
                case 'United States of America'
                    SheetNo=10;
                case 'India'
                    SheetNo=11;
            end
            FLTable=extracttables(SheetNo,'-','mean');




            %
            % try
            %     % doloop=1
            %     % faocountryname=ISOtoFAOName(ISO);
            %     % [g0,iimap,countryname,ISO]=getgeo41_g0(ISO);
            %     %
            %     % ISOList={ISO};
            %     % faocountrynamelist={faocountryname};
            % catch
            %     doloop=0
            % end


            idx=strmatch(gtapiso,gtapgeostruct.gtapbizarrocodes,'exact');
            isolist=gtapgeostruct.actualisocodes(idx);

            c=0;
            clear ISOList
            clear faocountrynamelist

            ISOList={'XXX'};
            faocountrynamelist={'terribleworkaround'};
            % this is horrendous, but need these non-empty to get into one of the
            % loops below, but need it to fail to get doloop=0. because I did this,
            % I have to force doloop=1 in a loop below but not the first time.
            %
            % Really, if anyone ever sees this I'm just so ashamed.

            doloop=0;
            for m=1:numel(isolist);
                iso=isolist{m};  % confusing with the names of isos
                ISO=upper(iso);
                try
                    [g0,iimap,countryname,ISO]=getgeo41_g0(ISO);
                    faocountryname=ISOtoFAOName(ISO);
                    c=c+1;
                    doloop=1;


                    ISOList{c}=ISO;
                    faocountrynamelist{c}=faocountryname;
                catch
                    disp(['prob for ' ISO ' which came from ' gtapiso])

                end
            end

            if numel(ISOList)>1
                'breakpoint opportunity';  % useful for debugging (obviously)
            end



            for jISOList=1:numel(ISOList)
                ISO=ISOList{jISOList};
                faocountryname=faocountrynamelist{jISOList};

                if jISOList>1
                    doloop=1; % this is part of the workaround - but it does all work.
                end


                if doloop==1;

                    %      FBS0=ReturnFBSData;
                    %      FBS0=subsetofstructureofvectors(FBS0,FBS0.Year==YYYY)

                    FBS=subsetofstructureofvectors(FBS0,strmatch(faocountryname,FBS0.Area,'exact'));
                    FBS=subsetofstructureofvectors(FBS,strmatch('Domestic',FBS.Element));
                    FBS=subsetofstructureofvectors(FBS,FBS.Year==YYYY);
                end
                if isempty(FBS.Area)
                    doloop=0;
                end

                if doloop==1;

                    % first let's get the relevant Gatto table.
                    % We have to relate iso to





                    %%ItemsList=unique(FBS.Item) - now define this earlier.

                    clear FLPercentage
                    clear ItemWeight
                    clear wtfflag
                    clear EF

                    ReducedItemsList=intersect(ItemsList,unique(FBS.Item)); % let's remove things that don't appear in this country

                    for j=1:numel(ReducedItemsList);

                        ThisItem=ReducedItemsList{j};

                        FBSItem=subsetofstructureofvectors(FBS,strmatch(ThisItem,FBS.Item,'exact'));
                        if numel(FBSItem.Area)==2
                            % this is usually because there is an Estimated and
                            % Imputed value.   Better to use E ("sending agency")
                            % Algorithm below ignores the presence of 'X' flag
                            % which only occurs 0.05% (i.e. 0.0005 fraction) of the
                            % time.
                            if isequal(FBSItem.Flag{2},'E')
                                FBSItem=subsetofstructureofvectors(FBSItem,2);
                            else
                                FBSItem=subsetofstructureofvectors(FBSItem,1);
                            end
                        end
                        ItemWeight(j)=FBSItem.Value;
                        idx=strmatch(ThisItem,b.FBS_commodity,'exact');
                        if numel(idx)==1

                            GTAP_sector=char(b.GTAP_sector(idx));
                            iiFLTable=GTAPSectorToGattoRow(GTAP_sector);

                            if isempty(iiFLTable)
                                FLPercentage(j)=nan;
                                wtfflag(j)=2;
                                flagtext='no gtap sector';
                            else
                                wtfflag(j)=1;
                                flagtext='everything good';
                                FLPercentage(j)=sum(FLTable(iiFLTable,[iiFLWColumns]));
                            end
                        else
                            wtfflag(j)=3;
                            flagtext='did not find in table S13';
                            disp(['did not find ' ThisItem]);
                            FLPercentage(j)=nan;
                        end

                        %% need to match into Poore table
                        FBSItem.Item
                        EmissionsFactor=GetPooreEmissionFactor(FBSItem.Item_Code,FBSItem.Item);
                        'breakpoint';
                        EF(j)=EmissionsFactor;

                        % % first try with code
                        % FBSCode=FBSItem.Item_Code;
                        % idx=find(SimplefoodwasteGHGcomparisons.FBSIVCode==FBSCode);
                        % jdx=find(SimplefoodwasteGHGcomparisons.FBSIIICode==FBSCode);
                        %
                        % disp('-----')
                        % if numel(idx)==0 & numel(jdx)==0
                        %     disp(['no match into Poore table for ' char(FBSItem.Item)])
                        % else
                        %     if numel(idx)>0
                        %         disp(['FBSIV match between ' char(FBSItem.Item)]);
                        %         disp([SimplefoodwasteGHGcomparisons.FBSName{idx(1)}]);
                        %     end
                        %     if numel(jdx)>0
                        %         disp(['FBSIII match between ' char(FBSItem.Item)]);
                        %         disp([SimplefoodwasteGHGcomparisons.FBSName{jdx(1)}]);
                        %
                        %     end
                        %
                        % end


                        fprintf(1,'%s,%s,%s,%s,%d,%s,%f,%f,%f\n',...
                            faocountryname,gtapiso,ISO,strrep(ThisItem,',','_'),wtfflag(j),flagtext,FLPercentage(j),ItemWeight(j),EF(j));
                        fprintf(fid,'%s,%s,%s,%s,%d,%s,%f,%f,%f\n',...
                            faocountryname,gtapiso,ISO,strrep(ThisItem,',','_'),wtfflag(j),flagtext,FLPercentage(j),ItemWeight(j),EF(j));


                    end

                    % let's average FL
                    ii=wtfflag==1;
                    AvgFLPercentage=sum(FLPercentage(ii).*ItemWeight(ii))/sum(ItemWeight(ii));
                    % here calculation average food loss percentage.  Need to put in methods
                    % that we weight by Item as appears in Food Balance Sheets (constrasts
                    % with, say, weighting by calories.)


                    WeightWithReportedFL=sum(ItemWeight(ii));
                    WeightWithNoReportedFL=sum(ItemWeight(wtfflag>1));

                    WastedFood=sum(ItemWeight(ii).*FLPercentage(ii));

                    GHGEmissions=WeightWithReportedFL.*EF

                    jj=wtfflag==1 & isfinite(EF);

                    TotalGHGEmissionsCountry=sum(EF(jj).*ItemWeight(jj).*FLPercentage(jj))

                    AvgEmissionsFactor = sum(EF(jj).*ItemWeight(jj).*FLPercentage(jj))/sum(ItemWeight(jj).*FLPercentage(jj))


                    fprintf(fid,'country, iso, AvgFLPercentage, WeightWithFL, WeightWithoutReportedFL,TotalGHGEmissionsCountry\n');
                    fprintf(fid,'%s,%s,%f,%f,%f,%f\n',faocountryname,gtapiso,AvgFLPercentage,WeightWithReportedFL,WeightWithNoReportedFL,TotalGHGEmissionsCountry);

                    [g0,iimap,countryname,ISO]=getgeo41_g0(ISO);

                    ff=datablank;
                    ff(iimap)=1;
                    ff=logical(ff);
                    population=sum(pop(ff));

                    WastePercentageMap(iimap)=AvgFLPercentage;
                    PercentageLossMap(iimap)=AvgFLPercentage;
                    PercentageFoodIncludedMap(iimap)=WeightWithNoReportedFL/(WeightWithNoReportedFL+WeightWithReportedFL);
                    EmissionsMap(iimap)=TotalGHGEmissionsCountry;
                    EmissionsPerCapitaMap(iimap)=TotalGHGEmissionsCountry/population;


                    EmissionsFactorMap(iimap)=AvgEmissionsFactor;



                    TonsWastedPerCapitaMap(iimap)=WastedFood/population;
                    TonsWastedMap(iimap)=WastedFood;


                    countrycount=countrycount+1;
                    DiagnosticPercentageFoodIncludedVect(countrycount)=WeightWithNoReportedFL/(WeightWithNoReportedFL+WeightWithReportedFL);
                    AvgFLPercentagevect(countrycount)=AvgFLPercentage;
                    AvgEmissionsFactorvect(countrycount)=AvgEmissionsFactor;
                    TotalGHGEmissionsCountryvect(countrycount)=TotalGHGEmissionsCountry;
                    WeightWithNoReportedFLvect(countrycount)=WeightWithNoReportedFL;
                    WeightWithReportedFLvect(countrycount)=WeightWithReportedFL;
                    populationvect(countrycount)=population;
                    faocountrynamelistvect{countrycount}=faocountryname;
                    iimapdata{countrycount}=iimap;
                    constructedISOList{countrycount}=ISO;
                    constructedgtapisolist{countrycount}=iso;

                end

            end
        end
        fclose(fid)

        save(['intermediatedatafiles/FLWresults/FLWCalculationResults' SaveFileNameText],...
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

    end
end
%avgofall
ii=isfinite(WeightWithReportedFLvect) & isfinite(AvgFLPercentagevect)

avgfoodwastepercent=sum(WeightWithReportedFLvect(ii).*AvgFLPercentagevect(ii))/sum(WeightWithReportedFLvect(ii));


%%
