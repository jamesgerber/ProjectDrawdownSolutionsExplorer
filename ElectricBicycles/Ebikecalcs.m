% script to carry out EBike Calculations
%
%

% EmissionsFromCars=  (% vehicle km calculation)
%     Ncars.* ...  % number cars
%     D.* ...      % distance per car per year 
%     (etaEV).*W_EV.*...  % fraction EV * kWh/vkm.*CO2-eq/kWh
%     (1-etaEV).*W_ICE;   % (1-etaEV)* (1/mpg)*(m/km)*(CO2-eq/km)
% 
% Emissions=Ncars*D*[(etaEV).*W_EV +(1-etaEV).*W_ICE ];
% % however, this doesn't map to the adoption unit.
% 
% Emissions=Ncars*D*1.5*[(etaEV).*W_EV/1.5 +(1-etaEV).*W_ICE/1.5 ];
% 

% add path
ExplorerSolutionPaths('ElectricCars')
ExplorerSolutionPaths('ElectricBicycles')

% Delta Emissions:
% Ncars.*DisplacedDistance.*[W_ICE - W_Ebike];
%
%  DisplacedDistance=688km;
%  Ncars

% W is proportional to gallonspermile (gCO2perkm)

% Tier 1:
% country specific:
% Ncars
% D
% etaEV
% CO2-eq/kWh
%
%  Effectiveness = (W_ICE-W_EV)/1.5, units are gCO2-eq per passenger km.
%  Adoption   = number cars * passenger distance per car per year * etaEV
%  AdoptionLow= number cars * passenger distance per car per year * 0.44
%  AdoptionHigh=number cars * passenger distance per car per year * 0.80
%  Impact    = Effectiveness*Adoption
%  ImpactLow = Effectiveness*AdoptionLow
%  ImpactHigh= Effectiveness*AdoptionHigh

EffectivenessMap=datablank;
%AdoptionMapCurrent=datablank;
%AdoptionMapPercentageCurrent=datablank;
%ImpactMapCurrent=datablank;
ImpactMapLow=datablank;
ImpactMapHigh=datablank;

clear DS

for j=1:numel(gadmlimitedlist);
    ISO=gadmlimitedlist(j);
    [g0,ii]=getgeo41_g0(ISO);

    %ISO=g0.gadm0codes{1};

    Ncars=ReturnNumCars(ISO);
    Distance=688;  % pkm
    
    [~,EmissionsIntensity]=ReturnCO2PerkmEV(ISO);
    
    if isempty(EmissionsIntensity)
        EmissionsIntensity=nan;
    end
    W_EBike=0.00932*EmissionsIntensity;
    
    W_ICE=120;% ReturnCO2PerkmICE(ISO) - global average (sum of C5:C10 cars status quo emissions) divided by 1.5 to get vkm
    % 120 is gCO2 per vehicle km.

    W_ICEpkm=W_ICE/1.5;   


    Effectiveness= (W_ICEpkm-W_EBike)*688;

    EffectivenessMap(ii)=Effectiveness;   % divide by 1.5 to get passenger km.
    
    ImpactMapLow(ii)=Effectiveness*Ncars*.07;
    ImpactMapHigh(ii)=Effectiveness*Ncars*.5;


    DS(j).ISO=ISO;
    DS(j).Ncars=Ncars;
    DS(j).Effectiveness=Effectiveness/1e3;
    DS(j).ImpactLow=Effectiveness*Ncars*.07/1e12;
    DS(j).ImpactHigh=Effectiveness*Ncars*.5/1e12;


end


mkdir('ElectricBicycleFigsAndData');
sov2csv(vos2sov(DS),'ElectricBicycleFigsAndData/ElectricBicyclesMappingData.csv');


%% Effectiveness
nsgfig=figure;
NSS=getDrawdownNSS;
NSS.figurehandle=nsgfig;
NSS.units='kg CO_2-eq/yr';
NSS.title='Current emissions benefit of a single Electric Bicycle'
NSS.cmap=ExplorerEffectiveness1;
NSS.caxis=[0 60]
DataToDrawdownFigures(EffectivenessMap/1e3,NSS,'Effectiveness_ElectricBicycles','ElectricBicycleFigsAndData/','');

% %% Adoption
% NSS=getDrawdownNSS;
% NSS.figurehandle=nsgfig;
% NSS.units='Million passenger km per year';
% NSS.title='Passenger km in Electric Cars'
% NSS.cmap='white_purple_red';
% NSS.caxis=[0 4e5]
% DataToDrawdownFigures(AdoptionMapCurrent,NSS,'Adoption_pkm','ElectricCarsFigsAndData/','');

% %% Adoption
% NSS=getDrawdownNSS;
% NSS.figurehandle=nsgfig;
% NSS.units='%';
% NSS.title='Percent of personal automotive fleet Electric in 2020'
% NSS.cmap='white_purple_red';
% NSS.caxis=[0 40]
% DataToDrawdownFigures(AdoptionMapPercentageCurrent,NSS,'Adoption_percent','ElectricCarsFigsAndData/','');

% %% Impact
% NSS=getDrawdownNSS;
% NSS.figurehandle=nsgfig;
% NSS.units='Mt CO_2eq/year';
% NSS.userinterppreference='tex'
% NSS.title='CO_2eq saved per year by use of Electric Cars'
% NSS.cmap='white_blue_green';
% NSS.caxis=[.99]
% DataToDrawdownFigures(ImpactMapCurrent/1e12,NSS,'Impact_Current','ElectricCarsFigsAndData/','');

%% Impact
NSS=getDrawdownNSS;
NSS.figurehandle=nsgfig;
NSS.userinterppreference='tex'
NSS.units='Mt CO_2-eq/yr';
NSS.title='CO_2eq saved per year by use of Electric Bicycles Low Adoption';
NSS.cmap=ExplorerImpact1;
NSS.caxis=[.99]
DataToDrawdownFigures(ImpactMapLow/1e12,NSS,'Impact_Low','ElectricBicycleFigsAndData/','');

%% Impact
NSS=getDrawdownNSS;
NSS.figurehandle=nsgfig;
NSS.userinterppreference='tex'
NSS.units='Mt CO_2-eq/yr';
NSS.title='CO_2-eq saved per year by use of Electric Bicycles High Adoption';
NSS.cmap=ExplorerImpact1;
NSS.caxis=[.99]
DataToDrawdownFigures(ImpactMapHigh/1e12,NSS,'Impact_High','ElectricBicycleFigsAndData/','');


