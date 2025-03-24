a=readgenericcsv('intermediatedatafiles/CementGCCAData.csv')

%% Calculation Section
baselineemissions=datablank*nan;
todayemissions=datablank*nan;
worstcaseemissions=datablank*nan;
lowambitionemissions=datablank*nan;
highambitionemissions=datablank*nan;
ceilingambitionemissions=datablank*nan;

Productionmap=datablank*nan;
TECmap=datablank;
EmissionsPerThermalEnergyGj=0.0847; % tCO2/Gj
EmissionsPerThermalEnergy=0.0847/1000; % tCO2/Mj
worstcaseTEC=3914.7;

for j=1:261;

    ISO=gadmlimitedlist(j);
    [g0,ii]=getgeo41_g0(ISO);

    [TEC,Prod,C2C,AltFuelsRatio,Emissions]=CountrySpecificCementFactors(g0.gadm0codes{1});

    if isempty(Prod);

        Productionmap(ii)=nan;
    else
        Productionmap(ii)=Prod;

    end
    if ~isempty(TEC)
        TECmap(ii)=TEC;


        todayemissionsvalue=Prod*C2C*TEC*EmissionsPerThermalEnergy;
        todayemissions(ii)=todayemissionsvalue;

        worstcaseemissionsvalue=Prod*C2C*worstcaseTEC*EmissionsPerThermalEnergy;
        worstcaseemissions(ii)=worstcaseemissionsvalue;


        baselineemissionsvalue=Prod*C2C*3550*EmissionsPerThermalEnergy;
        baselineemissions(ii)=baselineemissionsvalue;

        lowambitionemissionsvalue=Prod*C2C*3250*EmissionsPerThermalEnergy;
        lowambitionemissions(ii)=lowambitionemissionsvalue;

        highambitionemissionsvalue=Prod*C2C*3150*EmissionsPerThermalEnergy;
        highambitionemissions(ii)=highambitionemissionsvalue;

        ceilingambitionemissionsvalue=Prod*C2C*2300*EmissionsPerThermalEnergy;
        ceilingambitionemissions(ii)=ceilingambitionemissionsvalue;
    end

    DS(j).ISO=ISO;
    DS(j).todayemissionsvalue=todayemissionsvalue;
    DS(j).baselineemissions=baselineemissionsvalue;
    DS(j).worstcaseemissions=worstcaseemissionsvalue;
    DS(j).lowambitionemissionsvalue=lowambitionemissionsvalue;
    DS(j).highambitionemissionsvalue=highambitionemissionsvalue;
    DS(j).ceilingambitionemissionsvalue=ceilingambitionemissionsvalue;
    DS(j).ThermalEfficiencyConstant=TEC;
    DS(j).Production=Prod;
    DS(j).TonsCleanConcrete=Prod*(worstcaseemissionsvalue-todayemissionsvalue)/ ...
        (worstcaseemissionsvalue-highambitionemissionsvalue)/1e3;
    
end

nsgfig=figure;

EmissionsSavingsFromTodayToLowAmbition=todayemissions-lowambitionemissions;
EmissionsSavingsFromTodayToLowAmbition(EmissionsSavingsFromTodayToLowAmbition<0)=0;

EmissionsSavingsFromTodayToHighAmbition=todayemissions-highambitionemissions;
EmissionsSavingsFromTodayToHighAmbition(EmissionsSavingsFromTodayToHighAmbition<0)=0;


TonsCleanConcrete=Productionmap.*...
    (worstcaseemissions-todayemissions)./...
   (worstcaseemissions-highambitionemissions);



%%%%%%%%%%%%%%%%%
% adoption:     %
%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%GJ/t - categorical
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cmap=finemap('seaglass','','');
cmap=[1 1 1; 1 1 1; 1 1 1; 1 1 1; 1 1 1; 1 1 1; 1 1 1; cmap];
NSS=getDrawdownNSS;
NSS.title='Current Adoption: Thermally Efficient Cement Production';
NSS.DisplayNotes='Range from 2020 lowest efficiency relative to high ambition adoption';
NSS.units='MJ/Mt';
NSS.cmap=ExplorerAdoption1;
NSS.figurehandle=nsgfig;
DataToDrawdownFigures(TECmap,NSS,'CurrentAdoption_Cement_ThermalEfficiencyCoefficient','ImprovedCement_ThermalEfficiency');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Tons concrete produced efficiently - non-categorical and categorical
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NSS=getDrawdownNSS;
NSS.title='Current Adoption: Thermally Efficient Cement Production';
NSS.DisplayNotes='Range from 2020 lowest efficiency relative to high ambition adoption';
NSS.units='tonnes';
NSS.cmap=cmap;
NSS.figurehandle=nsgfig;

DataToDrawdownFigures(TonsCleanConcrete,NSS,'CurrentAdoption_Cement_TonsProducedCleanly','ImprovedCement_ThermalEfficiency');




% Adoption = % of high Ambition TEC relative to current lowest TEC
% high ambition = 3150;
% current worst = 3914.7;

% let's do a linear mapping.   

tmp=(TECmap-3150)/(3914.7-3150);
ii=TECmap==0;
tmp(ii)=nan;
tmp=(1-tmp)*100;
tmp(tmp<0)=0;

PercentAdoptionThermalEfficiency=tmp;

NSS=getDrawdownNSS;
NSS.title='Current Adoption: Thermally Efficient Concrete Production';
NSS.DisplayNotes='Range from 2020 lowest efficiency relative to high ambition adoption';
NSS.units='%';
NSS.cmap=ExplorerAdoption1;
NSS.figurehandle=nsgfig;
DataToDrawdownFigures(TonsCleanConcrete,NSS,'CurrentAdoption_Cement_PercentProducedCleanly','ImprovedCement_ThermalEfficiency');


% here again, code in JSG's notes

%%%%%%%%%%%%%%%%%
% Current impact%
%%%%%%%%%%%%%%%%%
% this is the difference between worst case emissions map and todays map

tmp=worstcaseemissions-todayemissions;
tmp(tmp<0)=0;
CurrentImpactMt=tmp/1000;

NSS=getDrawdownNSS;
NSS.title='Emissions savings from current levels of adoption of thermal efficiency';
NSS.DisplayNotes='Relative to 2022 lowest efficiencies';
NSS.units='Mt CO_2-eq/yr';
NSS.cmap='dark_purple_blue_green';
NSS.figurehandle=nsgfig;
nsg(CurrentImpactMt,NSS)
maketransparentoceans_noant_nogridlinesnostates_removeislands('temp.png','CurrentImpact_ThermalEfficiency.png',[1 1 1],1);
DataToDrawdownFigures(CurrentImpactMt,NSS,'CurrentImpact_Cement_Mt','ImprovedCement_ThermalEfficiency');



%%%%%%%%%%%%%%%%%%%%%%
% Low ambition impact%
%%%%%%%%%%%%%%%%%%%%%%
% this is the difference between worst case emissions map and todays map

tmp=todayemissions-lowambitionemissions;
tmp(tmp<0)=0;
LowAmbitionImpactMt=tmp/1000;

NSS=getDrawdownNSS;
NSS.title='Emissions savings moving from current to low-ambition thermal efficiency';
NSS.DisplayNotes='Relative to 2022 lowest efficiencies';
NSS.units='Mt CO_2-eq/yr';
NSS.cmap='dark_purple_blue_green';
NSS.figurehandle=nsgfig;
nsg(LowAmbitionImpactMt,NSS)
maketransparentoceans_noant_nogridlinesnostates_removeislands('temp.png','ImpactLowAmbition_ThermalEfficiency.png',[1 1 1],1);



%%%%%%%%%%%%%%%%%%%%%%
% High ambition impact%
%%%%%%%%%%%%%%%%%%%%%%
% this is the difference between worst case emissions map and todays map

tmp=todayemissions-highambitionemissions;
tmp(tmp<0)=0;
HighAmbitionImpactMt=tmp/1000;

NSS=getDrawdownNSS;
NSS.title='Emissions savings moving from current to high-ambition thermal efficiency';
NSS.DisplayNotes='Relative to 2022 lowest efficiencies';
NSS.units='Mt CO_2-eq/yr';
NSS.figurehandle=nsgfig;
%NSS.cmap=finemap('dark_purple_blue_green','','');
nsg(HighAmbitionImpactMt,NSS)
maketransparentoceans_noant_nogridlinesnostates_removeislands('temp.png','ImpactHighAmbition_ThermalEfficiency.png',[1 1 1],1);





