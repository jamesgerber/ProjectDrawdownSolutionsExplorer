
% This one won't work well without Jamie's data infrastructure since I have
% a bunch of particular tools for dealing with FAO data.

% this is a modified version of MapCropBurningSolution, modifingy Dec 8,
% 2025 to produce a map for an Emily Cassidy insights piece.

%% some preliminaries:
%%%pull in 'Emissions From Crops' Data
[EFC0,Verstring]=ReturnEFCData;
EFC0=rmfield(EFC0,'Note');

EFC0=subsetofstructureofvectors(EFC0,find(EFC0.Source_Code==3050));




%%%Set year
YYYY=2022;
%%% Get some geographic names
countrynames=readgenericcsv('/Users/jsgerber/Library/CloudStorage/GoogleDrive-james.gerber@drawdown.org/Shared drives/Geospatial Drive/Source Data/UNStats Country Area Codes/unstats_standard_country_area_codesnq.txt',1,tab,0);
ISOlist=countrynames.iso3_code;
M49list=countrynames.m49_code;;


%EFC=subsetofstructureofvectors(EFC1,strmatch('Rice',EFC1.Item));

% let's make a map of percentage of matter burned.

EFC1=subsetofstructureofvectors(EFC0,find(EFC0.Year==YYYY));
EFC2=subsetofstructureofvectors(EFC1,strmatch('Burning crop residues (Biomass burned, dry matter)',EFC1.Element));
EFC3=subsetofstructureofvectors(EFC1,strmatch('Burning crop residues (Emissions CH4)',EFC1.Element));
EFC4=subsetofstructureofvectors(EFC1,strmatch('Burning crop residues (Emissions N2O)',EFC1.Element));

ricestrawratiomap=datablank;
totaltonsstrawmap=datablank;
totaltonsburnedmap=datablank;
totalgrainproductionmap=datablank;
EDGARBiomassmap=datablank;
CH4map=datablank;
N2Omap=datablank;
% HarvestIndex= grain/(biomass+grain)

% grain is what is harvested + reported

%(biomass+grain)=grain/HI
%biomass=grain*(1/HI-1);
x=load(['~/DataProducts/ext/CropGrids/cropgridareasVer108/Version8_' 'rice' '.mat']);
ricearea=x.area;
x=load(['~/DataProducts/ext/CropGrids/cropgridareasVer108/Version8_' 'maize' '.mat']);
maizearea=x.area;
x=load(['~/DataProducts/ext/CropGrids/cropgridareasVer108/Version8_' 'wheat' '.mat']);
wheatarea=x.area;
x=load(['~/DataProducts/ext/CropGrids/cropgridareasVer108/Version8_' 'sugarcane' '.mat']);
sugarcanearea=x.area;

AggregateMethaneTonsPerHA=datablank;

%ISOlist=setdiff(ISOlist,'HKG')
%ISOlist=setdiff(ISOlist,'MAC')


for j=1:numel(ISOlist);
    ISO=ISOlist{j};
    %   M49=[ '''' num2str(M49list(j)) ];
    M49=M49list(j);

    try
        [g0,ii]=getgeo41_g0(ISO);
        %% rice
        cropname='rice';  % do rice again

        faocropname=getFAOCropName2024(cropname);
        %        [ay,aa]=GetAverageFAOData(ISO,cropname,0,YYYY,0);
        %        production=ay*aa;
        %        cc=getcropcharacteristics(cropname);
        %        strawmass=production.*(1/cc.Harvest_Index-1);;
        %        ResiduesBurned=pullfromsov(EFC2,'Value','AreaM49Num',M49,'Item',faocropname);

        %       riceproductionvect(j)=production;
        riceCH4Emissions(j)=pullfromsov(EFC3,'Value','AreaM49Num',M49,'Item',faocropname);
        %       riceN2OEmissions(j)=pullfromsov(EFC4,'Value','AreaM49Num',M49,'Item',faocropname);


        %       ricestrawmassvect(j)=strawmass;
        %       riceResiduesBurnedvect(j)=ResiduesBurned;

        % let's allocate by area from cropgrids



        %% wheat
        cropname='wheat';  % do rice again

        faocropname=getFAOCropName2024(cropname);
        % [ay,aa]=GetAverageFAOData(ISO,cropname,0,YYYY,0);
        % production=ay*aa;
        % cc=getcropcharacteristics(cropname);
        % strawmass=production.*(1/cc.Harvest_Index-1);;
        % ResiduesBurned=pullfromsov(EFC2,'Value','AreaM49Num',M49,'Item',faocropname);
        wheatCH4Emissions(j)=pullfromsov(EFC3,'Value','AreaM49Num',M49,'Item',faocropname);
        % wheatN2OEmissions(j)=pullfromsov(EFC4,'Value','AreaM49Num',M49,'Item',faocropname);
        %
        % wheatproductionvect(j)=production;
        % wheatstrawmassvect(j)=strawmass;
        % wheatResiduesBurnedvect(j)=ResiduesBurned;
        x=load(['~/DataProducts/ext/CropGrids/cropgridareasVer108/Version8_' cropname '.mat']);
        wheatarea=x.area;
        %% maize
        cropname='maize';  % do rice again

        faocropname=getFAOCropName2024(cropname);
        % [ay,aa]=GetAverageFAOData(ISO,cropname,0,YYYY,0);
        % production=ay*aa;
        % cc=getcropcharacteristics(cropname);
        % strawmass=production.*(1/cc.Harvest_Index-1);;
        % ResiduesBurned=pullfromsov(EFC2,'Value','AreaM49Num',M49,'Item',faocropname);
        maizeCH4Emissions(j)=pullfromsov(EFC3,'Value','AreaM49Num',M49,'Item',faocropname);
        % maizeN2OEmissions(j)=pullfromsov(EFC4,'Value','AreaM49Num',M49,'Item',faocropname);
        %
        %         maizeproductionvect(j)=production;
        %
        % maizestrawmassvect(j)=strawmass;
        % maizeResiduesBurnedvect(j)=ResiduesBurned;

        %% sugarcane
        cropname='sugarcane';  % do rice again

         faocropname=getFAOCropName2024(cropname);
        % [ay,aa]=GetAverageFAOData(ISO,cropname,0,YYYY,0);
        % production=ay*aa;
        % cc=getcropcharacteristics(cropname);
        % strawmass=production.*(1/cc.Harvest_Index-1);;
        % ResiduesBurned=pullfromsov(EFC2,'Value','AreaM49Num',M49,'Item',faocropname);
        sugarcaneCH4Emissions(j)=pullfromsov(EFC3,'Value','AreaM49Num',M49,'Item',faocropname);
      %  sugarcaneN2OEmissions(j)=pullfromsov(EFC4,'Value','AreaM49Num',M49,'Item',faocropname);

        % sugarcaneproductionvect(j)=production;
        % sugarcanestrawmassvect(j)=strawmass;
        % sugarcaneResiduesBurnedvect(j)=ResiduesBurned;
        %
        %
        % % total tons straw
        % totaltonsstraw(j)=...
        %     nansum([ricestrawmassvect(j)  ...
        %     maizestrawmassvect(j)  ...
        %     wheatstrawmassvect(j)  ...
        %     sugarcanestrawmassvect(j)]);
        %
        % % total tons burned
        % totaltonsburned(j)=...
        %     nansum([riceResiduesBurnedvect(j) ...
        %     maizeResiduesBurnedvect(j) ...
        %     wheatResiduesBurnedvect(j) ...
        %     sugarcaneResiduesBurnedvect(j)]);
        %
        %
        % totalgrainproduction(j)=...
        %     nansum([riceproductionvect(j)  ...
        %     maizeproductionvect(j)  ...
        %     wheatproductionvect(j)  ...
        %     sugarcaneproductionvect(j)]);
        %
        % % N2O
        % totaltonsstrawmap(ii)=totaltonsstraw(j);
        % totaltonsburnedmap(ii)=totaltonsburned(j);
        % totalgrainproductionmap(ii)=totalgrainproduction(j);
        %
        % N2Omap(ii)=273*nansum([riceN2OEmissions(j) maizeN2OEmissions(j) wheatN2OEmissions(j) sugarcaneN2OEmissions(j)]);
        % CH4map(ii)=27.9*nansum([riceCH4Emissions(j) maizeCH4Emissions(j) wheatCH4Emissions(j) sugarcaneCH4Emissions(j)]);



% let's allocate the area

% Rice
temp=datablank;
temp(ii)=riceCH4Emissions(j)*ricearea(ii)./sum(ricearea(ii).*fma(ii))*1000;
%note that this is tons of CH4 emission per ha with following properties
% sum(x*fma)= riceCH4Emissions(j)
% proportional to ricearea over country boundaries ii
temp(isnan(temp))=0;

AggregateMethaneTonsPerHA(ii)=AggregateMethaneTonsPerHA(ii)+temp(ii);

% Maize
temp=datablank;
temp(ii)=maizeCH4Emissions(j)*maizearea(ii)./sum(maizearea(ii).*fma(ii))*1000;
temp(isnan(temp))=0;
AggregateMethaneTonsPerHA(ii)=AggregateMethaneTonsPerHA(ii)+temp(ii);


% Wheat
temp=datablank;
temp(ii)=wheatCH4Emissions(j)*wheatarea(ii)./sum(wheatarea(ii).*fma(ii))*1000;
temp(isnan(temp))=0;
AggregateMethaneTonsPerHA(ii)=AggregateMethaneTonsPerHA(ii)+temp(ii);

% Soybean
temp=datablank;
temp(ii)=sugarcaneCH4Emissions(j)*sugarcanearea(ii)./sum(sugarcanearea(ii).*fma(ii))*1000;
temp(isnan(temp))=0;
AggregateMethaneTonsPerHA(ii)=AggregateMethaneTonsPerHA(ii)+temp(ii);
    catch
        disp(['some measure of unhappiness for ' ISO])
        %           keyboard

    end
end

% keyboard

clear NSS
NSS.caxis=[.99];
NSS.title=['tons methane per ha from cropburning'];
NSS.filename='on';
NSS.cmap='eggplant'
nsg(AggregateMethaneTonsPerHA,NSS);
globalarray2geotiff(AggregateMethaneTonsPerHA,'tonsmethaneperhafromcropburning.tif','')
% clear NSS
% NSS.caxis=[0 100];
% NSS.title=['Percentage of straw burned (FAO) ' int2str(YYYY)];
% NSS.filename='on'
% nsg(ratioburnedmap*100,NSS);
% 
% 
% 
% 
% clear NSS
% NSS.caxis=[0.99];
% NSS.title=['Tons of straw burned  (FAO) ' int2str(YYYY)];
% NSS.filename='on'
% nsg(totaltonsburnedmap*100,NSS);
% 
% clear NSS
% NSS.caxis=[0.99];
% NSS.title=['EDGAR biomass burning emissions (EDGAR) ' int2str(2019)];
% NSS.filename='on'
% nsg(EDGARBiomassmap,NSS);
% 
% clear NSS
% NSS.caxis=[0.99];
% NSS.title=['FAO reported residue burning emissions  (FAO) ' int2str(YYYY)];
% NSS.units='Mt CO2-eq (100 yr)'
% NSS.filename='on'
% nsg((N2Omap+CH4map)/1000,NSS);
% 
% 
% 

