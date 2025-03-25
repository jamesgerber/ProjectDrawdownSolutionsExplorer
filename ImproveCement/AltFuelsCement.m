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


for j=1:261;

    ISO=gadmlimitedlist(j);
  %  ISO='AUT';
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
        todayemissionsvalue=Prod*AltFuelsRatio*Effectiveness; % in mt (metric tons) CO2-eq
        worstcaseemissionsvalue=Prod*AFRWorst*Effectiveness;
        baselineemissionsvalue=Prod*AFRbaseline*Effectiveness;
        lowambitionemissionsvalue=Prod*AFRlow*Effectiveness;
        highambitionemissionsvalue=Prod*AFRhigh*Effectiveness;
        ceilambitionemissionsvalue=Prod*AFRceil*Effectiveness;
        
        todayemissionssavings(ii)=max(0,todayemissionsvalue-worstcaseemissionsvalue)/1e6;
        lowambitionemissionssavings(ii)=max(0,lowambitionemissionsvalue-todayemissionsvalue)/1e6;
        highambitionemissionssavings(ii)=max(0,highambitionemissionsvalue-todayemissionsvalue)/1e6;

    end


    DS(j).ISO=ISO;
    DS(j).AltFuelsRatio=AltFuelsRatio;
    DS(j).Production=Prod;
    DS(j).todayimpact=max(0,todayemissionsvalue-worstcaseemissionsvalue)/1e6;
    DS(j).lowambitionemissionssavingsvalue=max(0,lowambitionemissionsvalue-todayemissionsvalue)/1e6;
    DS(j).highambitionemissionssavingsvalue=max(0,highambitionemissionsvalue-todayemissionsvalue)/1e6;
    DS(j).ceilambitionemissionssavingsvalue=max(0,ceilambitionemissionsvalue-todayemissionsvalue)/1e6;
end

nsgfig=figure;

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
DataToDrawdownFigures(AltFuelsRatioCurrentMap,NSS,'CurrentAdoption_Cement_AltFuels','ImprovedCement_AltFuels');


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




