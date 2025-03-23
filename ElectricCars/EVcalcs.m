% script to carry out EV Calculations
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

% set up the path
ExplorerSolutionPaths('ElectricCars')

DrawdownMatlabPreferences;
cd(SolutionsWorkingDir)
cd('ElectricCars')

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
AdoptionMapCurrent=datablank;
AdoptionMapLow=datablank;
AdoptionMapHigh=datablank;
AdoptionMapPercentageCurrent=datablank;
ImpactMapCurrent=datablank;
ImpactMapLow=datablank;
ImpactMapHigh=datablank;

gpvkmEV=datablank; % these are nice for intermediate checks
gpvkmICE=datablank;  
clear DS;  % data structure
for j=1:263;
    [g0,ii]=getgeo41_g0(j);
    ISO=g0.gadm0codes{1};

    Ncars=ReturnNumCars(ISO);
    Distance=ReturnVkmPerCar(ISO);
    etaEV=EVUptake(ISO);
    W_EV=ReturnCO2PerkmEV(ISO);
    W_ICE=120;% ReturnCO2PerkmICE(ISO) - global average (sum of C5:C10 cars status quo emissions) divided by 1.5 to get vkm
    % 120 is gCO2 per passenger km.

    Distancepkm=Distance*1.5;
    W_EVpkm=W_EV/1.5;
    W_ICEpkm=W_ICE/1.5;


    Effectiveness= (W_ICEpkm-W_EVpkm);

    EffectivenessMap(ii)=Effectiveness;   % divide by 1.5 to get passenger km.
    AdoptionMapCurrent(ii)=etaEV*Ncars*Distancepkm;
    AdoptionMapLow(ii)=0.44*Ncars*Distancepkm;
    AdoptionMapHigh(ii)=0.80*Ncars*Distancepkm;
    ImpactMapCurrent(ii)=Effectiveness*etaEV*Ncars*Distancepkm;
    ImpactMapLow(ii)=Effectiveness*0.44*Ncars*Distancepkm;
    ImpactMapHigh(ii)=Effectiveness*0.80*Ncars*Distancepkm;
    
    AdoptionMapPercentageCurrent(ii)=etaEV*100;

    gpvkmICE(ii)=W_ICE;
    gpvkmEV(ii)=W_EV;

DS(j).ISO=ISO;
DS(j).Ncars=Ncars;
DS(j).CurrentFractionCars=etaEV;
DS(j).Effectiveness=Effectiveness;
DS(j).AdoptionCurrent=etaEV*Ncars*Distancepkm/1e6;
DS(j).AdoptionLow=0.44*Ncars*Distancepkm/1e6;
DS(j).AdoptionHigh=0.80*Ncars*Distancepkm/1e6;
DS(j).ImpactCurrent=Effectiveness*etaEV*Ncars*Distancepkm/1e12;
DS(j).ImpactLow=Effectiveness*0.44*Ncars*Distancepkm/1e12;
DS(j).ImpactHigh=Effectiveness*0.80*Ncars*Distancepkm/1e12;
end

mkdir('ElectricCarsFigsAndData');
sov2csv(vos2sov(DS),'ElectricCarsFigsAndData/ElectricCarsMappingData.csv');
%


%% Effectiveness
nsgfig=figure;
NSS=getDrawdownNSS;
NSS.figurehandle=nsgfig;
NSS.units='g CO_2-eq/pkm';
NSS.title='Current emissions benefit of Electric Cars'
NSS.cmap=ExplorerEffectivenessDiverging1;
NSS.caxis=[-80 80]
DataToDrawdownFigures(EffectivenessMap,NSS,'Effectiveness_ElectricCars','ElectricCarsFigsAndData/','');

%% Adoption
NSS=getDrawdownNSS;
NSS.figurehandle=nsgfig;
NSS.units='Mpkm/yr';
NSS.title='Adoption of Electric Cars'
NSS.cmap=ExplorerAdoption1;%'white_purple_red';
NSS.caxis=[0 4e5]
DataToDrawdownFigures(AdoptionMapCurrent/1e6,NSS,'Adoption_pkm','ElectricCarsFigsAndData/','');

%% Adoption
NSS=getDrawdownNSS;
NSS.figurehandle=nsgfig;
NSS.units='Mpkm/yr';
NSS.title='Electric Cars Adoption - Low'
NSS.cmap=ExplorerAdoption1;%'white_purple_red';
NSS.caxis=[0 2.6e6]
DataToDrawdownFigures(AdoptionMapLow/1e6,NSS,'Adoption_pkm_low','ElectricCarsFigsAndData/','');

%% Adoption
NSS=getDrawdownNSS;
NSS.figurehandle=nsgfig;
NSS.title='Electric Cars Adoption - High'
NSS.title='Passenger km in Electric Cars'
NSS.cmap=ExplorerAdoption1;%'white_purple_red';
NSS.caxis=[0 5e6]
DataToDrawdownFigures(AdoptionMapHigh/1e6,NSS,'Adoption_pkm_high','ElectricCarsFigsAndData/','');



%% Adoption
NSS=getDrawdownNSS;
NSS.figurehandle=nsgfig;
NSS.units='%';
NSS.title='Percent of personal automotive fleet Electric in 2023'
NSS.cmap=ExplorerAdoption1;%'white_purple_red';
NSS.caxis=[0 30]
DataToDrawdownFigures(AdoptionMapPercentageCurrent,NSS,'Adoption_percent','ElectricCarsFigsAndData/','');

%% Impact
NSS=getDrawdownNSS;
NSS.figurehandle=nsgfig;
NSS.units='Mt CO_2-eq/yr';
NSS.userinterppreference='tex'
NSS.title='CO_2eq saved per year by use of Electric Cars'
NSS.cmap=ExplorerImpact1;%'white_blue_green';
NSS.caxis=[0 5]
DataToDrawdownFigures(ImpactMapCurrent/1e12,NSS,'Impact_Current_limitedcaxes','ElectricCarsFigsAndData/','');

%% Impact
NSS=getDrawdownNSS;
NSS.figurehandle=nsgfig;
NSS.userinterppreference='tex'
NSS.units='Mt CO_2-eq/yr';
NSS.title='CO_2-eq saved per year by use of Electric Cars Low Ambition Uptake'
NSS.cmap=ExplorerImpact1;%'white_blue_green';
NSS.caxis=[0 40]
DataToDrawdownFigures(ImpactMapLow/1e12,NSS,'Impact_Low_limitedcaxes','ElectricCarsFigsAndData/','');


%% Impact
NSS=getDrawdownNSS;
NSS.figurehandle=nsgfig;
NSS.units='Mt CO_2-eq/yr';
NSS.userinterppreference='tex'
NSS.title='CO_2-eq saved per year by use of Electric Cars'
NSS.cmap=ExplorerImpact1;%'white_blue_green';
NSS.caxis=[0 160]
DataToDrawdownFigures(ImpactMapCurrent/1e12,NSS,'Impact_Current','ElectricCarsFigsAndData/','');

%% Impact
NSS=getDrawdownNSS;
NSS.figurehandle=nsgfig;
NSS.userinterppreference='tex'
NSS.units='Mt CO_2-eq/yr';
NSS.title='CO_2eq saved per year by use of Electric Cars Low Ambition Uptake'
NSS.cmap=ExplorerImpact1;%'white_blue_green';
NSS.caxis=[0 160]
DataToDrawdownFigures(ImpactMapLow/1e12,NSS,'Impact_Low','ElectricCarsFigsAndData/','');

%% Impact
NSS=getDrawdownNSS;
NSS.figurehandle=nsgfig;
NSS.userinterppreference='tex'
NSS.units='Mt CO_2-eq/yr';
NSS.title='CO_2-eq saved per year by use of Electric Cars High Ambition Uptake'
NSS.cmap=ExplorerImpact1;%'white_blue_green';
NSS.caxis=[0 160]
DataToDrawdownFigures(ImpactMapHigh/1e12,NSS,'Impact_High','ElectricCarsFigsAndData/','');

