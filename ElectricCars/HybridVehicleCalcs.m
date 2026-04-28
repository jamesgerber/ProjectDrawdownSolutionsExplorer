% script to carry out Hybrid Cars Calculations
%
%

% EmissionsFromCars=  (% vehicle km calculation)
%     Ncars.* ...  % number cars
%     D.* ...      % distance per car per year 
%     (etaHV).*W_EV.*...  % fraction EV * kWh/vkm.*CO2-eq/kWh
%     (1-etaHV).*W_ICE;   % (1-etaHV)* (1/mpg)*(m/km)*(CO2-eq/km)
% 
% Emissions=Ncars*D*[(etaHV).*W_EV +(1-etaHV).*W_ICE ];
% % however, this doesn't map to the adoption unit.
% 
% Emissions=Ncars*D*1.5*[(etaHV).*W_EV/1.5 +(1-etaHV).*W_ICE/1.5 ];
% 
% Savings of 28.6 tCO2-eq/Mpkm
% set up the path
ExplorerSolutionPaths('ElectricCars')

DrawdownMatlabPreferences;

% Tier 1:
% country specific:
% Ncars
% D
% etaHV
% CO2-eq/kWh
%
%  Effectiveness = 28.6 tCO2-eq per million passenger km.
%  Adoption   = number cars * passenger distance per car per year * etaHV
%  AdoptionLow= number cars * passenger distance per car per year * 0.20
%  AdoptionHigh=number cars * passenger distance per car per year * 0.50
%  Impact    = Effectiveness*Adoption
%  ImpactLow = Effectiveness*AdoptionLow
%  ImpactHigh= Effectiveness*AdoptionHigh




%EffectivenessMap=datablank;   not meaningful for hybrid (global avgs)
% AdoptionMapCurrent=datablank;  can't do this for hybrid (don't have data)
AdoptionMapLow=datablank;
AdoptionMapHigh=datablank;
%AdoptionMapPercentageCurrent=datablank;   can't do this for hybrid (data)
% ImpactMapCurrent=datablank;
ImpactMapLow=datablank;
ImpactMapHigh=datablank;

%gpvkmEV=datablank; % these are nice for intermediate checks

gpvkmICE=datablank;  

clear DS;  % data structure

for j=1:263;
    [g0,ii]=getgeo41_g0(j);
    ISO=g0.gadm0codes{1};
    %ISO='USA';

    Ncars=ReturnNumCars(ISO);
    Distance=ReturnVkmPerCar(ISO);
 
    delW_Hypkm=0.00002713*1e6; % from B22 on results tab of Mobile Hybrid Cars asessment spreadsheet, Fri Dec 12
% units here are metric tons CO2/1e6 pkm switched.



    Distancepkm=Distance*1.5;
    
    Effectiveness= (delW_Hypkm);

    %EffectivenessMap(ii)=Effectiveness;   % divide by 1.5 to get passenger km.
    AdoptionMapLow(ii)=0.20*Ncars*Distancepkm;
    AdoptionMapHigh(ii)=0.50*Ncars*Distancepkm;
    ImpactMapLow(ii)=Effectiveness*0.20*Ncars*Distancepkm;
    ImpactMapHigh(ii)=Effectiveness*0.50*Ncars*Distancepkm;
    

DS(j).ISO=ISO;
DS(j).Ncars=Ncars;
DS(j).AdoptionLow=0.20*Ncars*Distancepkm/1e6;
DS(j).AdoptionHigh=0.50*Ncars*Distancepkm/1e6;
DS(j).ImpactLow=Effectiveness*0.20*Ncars*Distancepkm/1e12;
DS(j).ImpactHigh=Effectiveness*0.50*Ncars*Distancepkm/1e12;
end

mkdir('HybridCarsFigsAndData');
sov2csv(vos2sov(DS),'HybridCarsFigsAndData/HybridCarsMappingData.csv');
%


nsgfig=figure;

%% Adoption
NSS=getDrawdownNSS;
NSS.figurehandle=nsgfig;
NSS.units='Mpkm/yr';
NSS.title='Hybrid Cars Adoption - Low'
NSS.cmap=ExplorerAdoption1;%'white_purple_red';
NSS.caxis=[0.99]
DataToDrawdownFigures(AdoptionMapLow/1e6,NSS,'Adoption_pkm_low','HybridCarsFigsAndData/','');

%% Adoption
NSS=getDrawdownNSS;
NSS.figurehandle=nsgfig;
NSS.title='Hybrid Cars Adoption - High'
NSS.units='Mpkm/yr';
NSS.cmap=ExplorerAdoption1;%'white_purple_red';
NSS.caxis=[0.99]
DataToDrawdownFigures(AdoptionMapHigh/1e6,NSS,'Adoption_pkm_high','HybridCarsFigsAndData/','');







%% Impact
NSS=getDrawdownNSS;
NSS.figurehandle=nsgfig;
NSS.userinterppreference='tex'
NSS.units='Mt CO_2-eq/yr';
NSS.title='CO_2eq saved per year by use of Hybrid Cars Low Ambition Uptake'
NSS.cmap=ExplorerImpact1;%'white_blue_green';
NSS.caxis=[0.99]
DataToDrawdownFigures(ImpactMapLow/1e12,NSS,'Impact_Low','HybridCarsFigsAndData/','');

%% Impact
NSS=getDrawdownNSS;
NSS.figurehandle=nsgfig;
NSS.userinterppreference='tex'
NSS.units='Mt CO_2-eq/yr';
NSS.title='CO_2-eq saved per year by use of Hybrid Cars High Ambition Uptake'
NSS.cmap=ExplorerImpact1;%'white_blue_green';
NSS.caxis=[0.99]
DataToDrawdownFigures(ImpactMapHigh/1e12,NSS,'Impact_High','HybridCarsFigsAndData/','');

