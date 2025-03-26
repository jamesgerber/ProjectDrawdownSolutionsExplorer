a=readgenericcsv('intermediatedatafiles/CementGCCAData.csv')

%% Calculation Section
todayemissionssavings=datablank*nan;
lowambitionemissionssavings=datablank*nan;
highambitionemissionssavings=datablank*nan;
AltFuelsRatioCurrentMap=datablank*nan;

AFRWorst=0;
AFRbaseline=300/4158;
AFRlow=610/4158;
AFRhigh=2000/4158;
AFRceil=4000/4158;

Effectiveness=0.096;  % t CO2-eq/t cement

clear DS

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

    if isempty(Prod);
        Productionmap(ii)=nan;
    else
        Productionmap(ii)=Prod;
    end

    if ~isempty(AltFuelsRatio)
        AltFuelsRatioCurrentMap(ii)=AltFuelsRatio;
        todayemissionsspared=Prod*AltFuelsRatio*Effectiveness; % in mt (metric tons) CO2-eq
        worstcaseemissionsspared=Prod*AFRWorst*Effectiveness;
        baselineemissionsspared=Prod*AFRbaseline*Effectiveness;
        lowambitionemissionsspared=Prod*AFRlow*Effectiveness;
        highambitionemissionsspared=Prod*AFRhigh*Effectiveness;
        ceilambitionemissionsspared=Prod*AFRceil*Effectiveness;
        
        todayemissionssavings(ii)=max(0,todayemissionsspared-worstcaseemissionsspared)/1e6;
        lowambitionemissionssavings(ii)=max(0,lowambitionemissionsspared-worstcaseemissionsspared)/1e6;
        highambitionemissionssavings(ii)=max(0,highambitionemissionsspared-worstcaseemissionsspared)/1e6;
        ceilambitionemissionssavings(ii)=max(0,ceilambitionemissionsspared-worstcaseemissionsspared)/1e6;
    else
        todayemissionsspared=Prod*AltFuelsRatio*Effectiveness; % in mt (metric tons) CO2-eq
        worstcaseemissionsspared=Prod*AFRWorst*Effectiveness;
        baselineemissionsspared=Prod*AFRbaseline*Effectiveness;
        lowambitionemissionsspared=Prod*AFRlow*Effectiveness;
        highambitionemissionsspared=Prod*AFRhigh*Effectiveness;
        ceilambitionemissionsspared=Prod*AFRceil*Effectiveness;
    end


    DS(j).ISO=ISO;
    DS(j).AltFuelsRatio=AltFuelsRatio;
    DS(j).Production=Prod;
    DS(j).todayimpact=max(0,todayemissionsspared-worstcaseemissionsspared)/1e6;
    DS(j).lowambitionimpact=max(0,lowambitionemissionsspared-worstcaseemissionsspared)/1e6;
    DS(j).highambitionimpact=max(0,highambitionemissionsspared-worstcaseemissionsspared)/1e6;
    DS(j).ceilingambitionimpact=max(0,ceilambitionemissionsspared-worstcaseemissionsspared)/1e6;
    DS(j).lowambitioncumulativeimpact=max(DS(j).todayimpact,DS(j).lowambitionimpact);
    DS(j).highambitioncumulativeimpact=max(DS(j).todayimpact,DS(j).highambitionimpact);
    DS(j).ceilingambitioncumulativeimpact=max(DS(j).todayimpact,DS(j).ceilingambitionimpact);
end

nsgfig=figure('Visible','off');

mkdir('ImprovedCement_AltFuels');
sov2csv(vos2sov(DS),'ImprovedCement_AltFuels/ImprovedCement_AltFuelsMappingData.csv');

%%%%%%%%%%%%%%%%%
% adoption:     %
%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%GJ/t - categorical
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NSS=getDrawdownNSS;
NSS.title='Current Adoption: AltFuels';
%NSS.DisplayNotes='Range from 2020 lowest efficiency relative to high ambition adoption';
NSS.units='%';
NSS.cmap='ExplorerAdoption1';
NSS.caxis=[0 100];
NSS.figurehandle=nsgfig;
DataToDrawdownFigures(AltFuelsRatioCurrentMap*100,NSS,'CurrentAdoption_Cement_AltFuels','ImprovedCement_AltFuels');


%%%%%%%%%%%%%%%%%
% Current impact%
%%%%%%%%%%%%%%%%%


NSS=getDrawdownNSS;
NSS.title='Emissions savings from current levels of alternate fuels usage';
NSS.units='Mt CO_2-eq/yr';
NSS.cmap=ExplorerImpact1;
NSS.figurehandle=nsgfig;
DataToDrawdownFigures(todayemissionssavings,NSS,'CurrentImpact_AltFuels','ImprovedCement_AltFuels');



%%%%%%%%%%%%%%%%%%%%%%
% Low ambition impact%
%%%%%%%%%%%%%%%%%%%%%%

NSS=getDrawdownNSS;
NSS.title='Emissions savings from low ambition levels of alternate fuels usage';
NSS.units='Mt CO_2-eq/yr';
NSS.cmap=ExplorerImpact1;
NSS.figurehandle=nsgfig;
DataToDrawdownFigures(lowambitionemissionssavings,NSS,'LowAmbitionAdoptionImpact_AltFuels','ImprovedCement_AltFuels');



%%%%%%%%%%%%%%%%%%%%%%
% High ambition impact%
%%%%%%%%%%%%%%%%%%%%%%

NSS=getDrawdownNSS;
NSS.title='Emissions savings from high ambition levels of alternate fuels usage';
NSS.units='Mt CO_2-eq/yr';
NSS.cmap=ExplorerImpact1;
NSS.figurehandle=nsgfig;
DataToDrawdownFigures(highambitionemissionssavings,NSS,'HighAmbitionAdoptionImpact_AltFuels','ImprovedCement_AltFuels');




