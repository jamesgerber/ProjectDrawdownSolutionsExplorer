
% This one won't work well without Jamie's data infrastructure since I have
% a bunch of particular tools for dealing with FAO data.


%% some preliminaries:  
%%%pull in 'Emissions From Crops' Data
[EFC0,Verstring]=ReturnEFCData;
EFC0=rmfield(EFC0,'Note');

EFC0=subsetofstructureofvectors(EFC0,find(EFC0.Source_Code==3050));




%%%Set year
YYYY=2019;
%%% Get some geographic names
countrynames=readgenericcsv('inputdatafiles/countrynames.txt',1,tab,1);
ISOlist=countrynames.ISO_alpha3_code;
M49list=countrynames.M49_code;


%EFC=subsetofstructureofvectors(EFC1,strmatch('Rice',EFC1.Item));

% let's make a map of percentage of matter burned.

EFC1=subsetofstructureofvectors(EFC0,find(EFC0.Year==YYYY));
EFC2=subsetofstructureofvectors(EFC1,strmatch('Burning crop residues (Biomass burned, dry matter)',EFC1.Element));
EFC3=subsetofstructureofvectors(EFC1,strmatch('Burning crop residues (Emissions CH4)',EFC1.Element));
EFC4=subsetofstructureofvectors(EFC1,strmatch('Burning crop residues (Emissions N2O)',EFC1.Element));
   
ricestrawratiomap=datablank;
totaltonsstrawmap=datablank;
totaltonsburnedmap=datablank;
EDGARBiomassmap=datablank;
CH4map=datablank;
N2Omap=datablank;
% HarvestIndex= grain/(biomass+grain)

% grain is what is harvested + reported

%(biomass+grain)=grain/HI
%biomass=grain*(1/HI-1);


for j=1:numel(ISOlist);
    ISO=ISOlist{j};
    %   M49=[ '''' num2str(M49list(j)) ];
    M49=M49list(j);

   try
        [g0,ii]=getgeo41_g0(ISO);
        %% rice
        cropname='rice';  % do rice again
        
        faocropname=getFAOCropName2024(cropname);
        [ay,aa]=GetAverageFAOData(ISO,cropname,0,YYYY,0);
        production=ay*aa;
        cc=getcropcharacteristics(cropname);
        strawmass=production.*(1/cc.Harvest_Index-1);;
        ResiduesBurned=pullfromsov(EFC2,'Value','AreaM49Num',M49,'Item',faocropname);

        riceCH4Emissions(j)=pullfromsov(EFC3,'Value','AreaM49Num',M49,'Item',faocropname);
        riceN2OEmissions(j)=pullfromsov(EFC4,'Value','AreaM49Num',M49,'Item',faocropname);


        ricestrawmassvect(j)=strawmass;
        riceResiduesBurnedvect(j)=ResiduesBurned;

        %% wheat
        cropname='wheat';  % do rice again
        
        faocropname=getFAOCropName2024(cropname);
        [ay,aa]=GetAverageFAOData(ISO,cropname,0,YYYY,0);
        production=ay*aa;
        cc=getcropcharacteristics(cropname);
        strawmass=production.*(1/cc.Harvest_Index-1);;
        ResiduesBurned=pullfromsov(EFC2,'Value','AreaM49Num',M49,'Item',faocropname);
        wheatCH4Emissions(j)=pullfromsov(EFC3,'Value','AreaM49Num',M49,'Item',faocropname);
        wheatN2OEmissions(j)=pullfromsov(EFC4,'Value','AreaM49Num',M49,'Item',faocropname);

        wheatstrawmassvect(j)=strawmass;
        wheatResiduesBurnedvect(j)=ResiduesBurned;

            %% maize
        cropname='maize';  % do rice again
        
        faocropname=getFAOCropName2024(cropname);
        [ay,aa]=GetAverageFAOData(ISO,cropname,0,YYYY,0);
        production=ay*aa;
        cc=getcropcharacteristics(cropname);
        strawmass=production.*(1/cc.Harvest_Index-1);;
        ResiduesBurned=pullfromsov(EFC2,'Value','AreaM49Num',M49,'Item',faocropname);
        maizeCH4Emissions(j)=pullfromsov(EFC3,'Value','AreaM49Num',M49,'Item',faocropname);
        maizeN2OEmissions(j)=pullfromsov(EFC4,'Value','AreaM49Num',M49,'Item',faocropname);

        maizestrawmassvect(j)=strawmass;
        maizeResiduesBurnedvect(j)=ResiduesBurned;

        %% sugarcane
        cropname='sugarcane';  % do rice again
        
        faocropname=getFAOCropName2024(cropname);
        [ay,aa]=GetAverageFAOData(ISO,cropname,0,YYYY,0);
        production=ay*aa;
        cc=getcropcharacteristics(cropname);
        strawmass=production.*(1/cc.Harvest_Index-1);;
        ResiduesBurned=pullfromsov(EFC2,'Value','AreaM49Num',M49,'Item',faocropname);
        sugarcaneCH4Emissions(j)=pullfromsov(EFC3,'Value','AreaM49Num',M49,'Item',faocropname);
        sugarcaneN2OEmissions(j)=pullfromsov(EFC4,'Value','AreaM49Num',M49,'Item',faocropname);

        sugarcanestrawmassvect(j)=strawmass;
        sugarcaneResiduesBurnedvect(j)=ResiduesBurned;


        % total tons straw
        totaltonsstraw(j)=...
            nansum([ricestrawmassvect(j)  ...
            maizestrawmassvect(j)  ...
            wheatstrawmassvect(j)  ...
            sugarcanestrawmassvect(j)]);

        % total tons burned
        totaltonsburned(j)=...
            nansum([riceResiduesBurnedvect(j) ...
            maizeResiduesBurnedvect(j) ...
            wheatResiduesBurnedvect(j) ...
            sugarcaneResiduesBurnedvect(j)]);

        % N2O
        totaltonsstrawmap(ii)=totaltonsstraw(j);
        totaltonsburnedmap(ii)=totaltonsburned(j);

        N2Omap(ii)=273*nansum([riceN2OEmissions(j) maizeN2OEmissions(j) wheatN2OEmissions(j) sugarcaneN2OEmissions(j)]);
        CH4map(ii)=27.9*nansum([riceCH4Emissions(j) maizeCH4Emissions(j) wheatCH4Emissions(j) sugarcaneCH4Emissions(j)]);

    catch
        disp(['some measure of unhappiness for ' ISO])
     %           keyboard

    end

[M,rows,cols,A,B,OE,IND,T,E]=AllocateEmissionsNFIRevG(ISO,2019);

EDGARBiomassBurning(j)=sum(M(1,:));
EDGARBiomassmap(ii)=EDGARBiomassBurning(j);

end

% now some diagnostics
ratioburned=totaltonsburned./totaltonsstraw;

ratioburnedmap=totaltonsburnedmap./totaltonsstrawmap;


keyboard

clear NSS
NSS.caxis=[0 100];
NSS.title=['Percentage of straw burned ' int2str(YYYY)];
NSS.filename='on'
nsg(ratioburnedmap*100,NSS);




clear NSS
NSS.caxis=[0.99];
NSS.title=['Tons of straw burned ' int2str(YYYY)];
NSS.filename='on'
nsg(totaltonsburnedmap*100,NSS);

clear NSS
NSS.caxis=[0.99];
NSS.title=['EDGAR biomass burning emissions ' int2str(2019)];
NSS.filename='on'
nsg(EDGARBiomassmap,NSS);

clear NSS
NSS.caxis=[0.99];
NSS.title=['FAO reported residue burning emissions ' int2str(YYYY)];
NSS.units='Mt CO2-eq (100 yr)'
NSS.filename='on'
nsg((N2Omap+CH4map)/1000,NSS);




