a=readgenericcsv('intermediatedatafiles/CementGCCAData.csv')

%% Calculation Section
baselineimpact=datablank*nan;
todayimpact=datablank*nan;
lowambitionimpact=datablank*nan;
highambitionimpact=datablank*nan;
ceilingambitionimpact=datablank*nan;

Productionmap=datablank*nan;
TECmap=datablank;
EmissionsPerThermalEnergyGj=0.0847; % tCO2/Gj
EmissionsPerThermalEnergy=0.0847/1000; % tCO2/Mj
worstcaseTEC=3914.7;


ceilingTEC=2300;
for j=1:261;

    ISO=gadmlimitedlist(j);
    
    [g0,ii]=getgeo41_g0(ISO);

    [TEC,Prod,C2C,AltFuelsRatio,Emissions]=CountrySpecificCementFactors(g0.gadm0codes{1});
    if isempty(AltFuelsRatio)
        AltFuelsRatio=nan;
    end
    if isempty(C2C)
        C2C=nan;
    end
    if isempty(TEC)
        TEC=nan;
    end

    if isempty(Prod);

        Productionmap(ii)=nan;
    else
        Productionmap(ii)=Prod;

    end
    if ~isempty(TEC)
        TECmap(ii)=TEC;

        todayemissionsvalue=Prod*C2C*TEC*EmissionsPerThermalEnergy;
        worstcaseemissionsvalue=Prod*C2C*worstcaseTEC*EmissionsPerThermalEnergy;
        baselineemissionsvalue=Prod*C2C*3550*EmissionsPerThermalEnergy;
        lowambitionemissionsvalue=Prod*C2C*3250*EmissionsPerThermalEnergy;
        highambitionemissionsvalue=Prod*C2C*3150*EmissionsPerThermalEnergy;
        ceilingambitionemissionsvalue=Prod*C2C*2300*EmissionsPerThermalEnergy;

        todayimpact(ii)=max(0,worstcaseemissionsvalue-todayemissionsvalue);
        baselineimpact(ii)=max(0,worstcaseemissionsvalue-baselineemissionsvalue);
        lowambitionimpact(ii)=max(0,worstcaseemissionsvalue-lowambitionemissionsvalue);
        highambitionimpact(ii)=max(0,worstcaseemissionsvalue-highambitionemissionsvalue);
        ceilingambitionimpact(ii)=max(0,worstcaseemissionsvalue-ceilingambitionemissionsvalue);
    else
        todayemissionsvalue=Prod*C2C*nan*EmissionsPerThermalEnergy;
        worstcaseemissionsvalue=Prod*C2C*worstcaseTEC*EmissionsPerThermalEnergy;
        baselineemissionsvalue=Prod*C2C*3550*EmissionsPerThermalEnergy;
        lowambitionemissionsvalue=Prod*C2C*3250*EmissionsPerThermalEnergy;
        highambitionemissionsvalue=Prod*C2C*3150*EmissionsPerThermalEnergy;
        ceilingambitionemissionsvalue=Prod*C2C*2300*EmissionsPerThermalEnergy;
    end

    DS(j).ISO=ISO;
    DS(j).todayimpact=max(0,worstcaseemissionsvalue-todayemissionsvalue);
    DS(j).baselineimpact=max(0,worstcaseemissionsvalue-baselineemissionsvalue);
    DS(j).lowambitionimpact=max(0,worstcaseemissionsvalue-lowambitionemissionsvalue);
    DS(j).highambitionimpact=max(0,worstcaseemissionsvalue-highambitionemissionsvalue);
    DS(j).ceilingambitionimpact=max(0,worstcaseemissionsvalue-ceilingambitionemissionsvalue);
    DS(j).lowambitioncumulativeimpact=max(DS(j).todayimpact,DS(j).lowambitionimpact);
    DS(j).highambitioncumulativeimpact=max(DS(j).todayimpact,DS(j).highambitionimpact);
    DS(j).ceilingambitioncumulativeimpact=max(DS(j).todayimpact,DS(j).ceilingambitionimpact);
    DS(j).ThermalEfficiencyConstant=TEC;
    DS(j).Production=Prod;
end

mkdir('ImprovedCement_ThermalEfficiency');
sov2csv(vos2sov(DS),'ImprovedCement_ThermalEfficiency/ImprovedCement_ThermalEfficiencyMappingData.csv');


nsgfig=figure('Visible','off');

%%%%%%%%%%%%%%%%%
% adoption:     %
%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%GJ/t - categorical
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NSS=getDrawdownNSS;
NSS.title='Current Adoption: Efficiency of Clinker Production';
%NSS.DisplayNotes='Range from 2020 lowest efficiency relative to high ambition adoption';
NSS.units='MJ/Mt clinker';
NSS.cmap='revExplorerAdoption1';
NSS.caxis=[3000 4000];
NSS.figurehandle=nsgfig;
DataToDrawdownFigures(TECmap,NSS,'CurrentAdoption_Cement_ThermalEfficiencyCoefficient','ImprovedCement_ThermalEfficiency');

% % 
% % 
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % %Tons concrete produced efficiently - non-categorical and categorical
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % NSS=getDrawdownNSS;
% % NSS.title='Current Adoption: Thermally Efficient Cement Production';
% % NSS.DisplayNotes='Range from 2020 lowest efficiency relative to high ambition adoption';
% % NSS.units='tonnes';
% % NSS.cmap=cmap;
% % NSS.figurehandle=nsgfig;
% % 
% % DataToDrawdownFigures(TonsCleanConcrete,NSS,'CurrentAdoption_Cement_TonsProducedCleanly','ImprovedCement_ThermalEfficiency');
% % 
% % 
% % 
% % 
% % % Adoption = % of high Ambition TEC relative to current lowest TEC
% % % high ambition = 3150;
% % % current worst = 3914.7;
% % 
% % % let's do a linear mapping.   
% % 
% % tmp=(TECmap-ceilingTEC)/(3914.7-ceilingTEC);
% % ii=TECmap==0;
% % tmp(ii)=nan;
% % tmp=(1-tmp)*100;
% % tmp(tmp<0)=0;
% % 
% % PercentAdoptionThermalEfficiency=tmp;
% % 
% % NSS=getDrawdownNSS;
% % NSS.title='Current Adoption: Thermally Efficient Concrete Production';
% % NSS.DisplayNotes='Range from 2020 lowest efficiency relative to high ambition adoption';
% % NSS.units='%';
% % NSS.cmap=ExplorerAdoption1;
% % NSS.figurehandle=nsgfig;
% % DataToDrawdownFigures(TonsCleanConcrete,NSS,'CurrentAdoption_Cement_PercentProducedCleanly','ImprovedCement_ThermalEfficiency');
% % 
% % 
% % % here again, code in JSG's notes

%%%%%%%%%%%%%%%%%
% Current impact%
%%%%%%%%%%%%%%%%%
% this is the difference between worst case emissions map and todays map
todayimpactMt=todayimpact/1000;

NSS=getDrawdownNSS;
NSS.title='Emissions savings from current levels of adoption of thermal efficiency';
NSS.units='Mt CO_2-eq/yr';
NSS.cmap=ExplorerImpact1;
NSS.figurehandle=nsgfig;
DataToDrawdownFigures(todayimpactMt,NSS,'CurrentImpact_Cement_Mt','ImprovedCement_ThermalEfficiency');



%%%%%%%%%%%%%%%%%%%%%%
% Low ambition impact%
%%%%%%%%%%%%%%%%%%%%%%
% this is the difference between worst case emissions map and todays map

LowAmbitionImpactMt=lowambitionimpact/1000;

NSS=getDrawdownNSS;
NSS.title='Emissions savings, adoption of low-ambition thermal efficiency';
NSS.units='Mt CO_2-eq/yr';
NSS.cmap=ExplorerImpact1;
NSS.figurehandle=nsgfig;
DataToDrawdownFigures(max(LowAmbitionImpactMt,todayimpactMt),NSS,'LowAmbitionImpact_Cement_Mt','ImprovedCement_ThermalEfficiency');


%%%%%%%%%%%%%%%%%%%%%%
% High ambition impact%
%%%%%%%%%%%%%%%%%%%%%%
% this is the difference between worst case emissions map and todays map


HighAmbitionImpactMt=highambitionimpact/1000;

NSS=getDrawdownNSS;
NSS.title='Emissions savings, adoption of high-ambition thermal efficiency';
NSS.units='Mt CO_2-eq/yr';
NSS.figurehandle=nsgfig;
NSS.cmap=ExplorerImpact1;
DataToDrawdownFigures(max(HighAmbitionImpactMt,todayimpactMt),NSS,'HighAmbitionImpact_Cement_Mt','ImprovedCement_ThermalEfficiency');





