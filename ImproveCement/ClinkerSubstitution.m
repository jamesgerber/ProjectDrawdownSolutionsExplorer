a=readgenericcsv('intermediatedatafiles/CementGCCAData.csv')

%% Calculation Section
todayemissionssavings=datablank*nan;
lowambitionemissionssavings=datablank*nan;
highambitionemissionssavings=datablank*nan;
SPcurrentmap=datablank*nan;

SPworst=0;
SPbaseline=18.569;
SPlow=19.05;
SPhigh=43.1;
SPceil=67.15;

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


    SubsPercent=95-C2C*100;
    SPcurrent=SubsPercent;

    if isempty(Prod);
        Productionmap(ii)=nan;
    else
        Productionmap(ii)=Prod;
    end
    if ~isempty(SPcurrent)
        SPcurrentmap(ii)=SPcurrent;
        todayemissionsvalue=Prod*SPcurrent*240000/1e6/100/1e6;
        worstcaseemissionsvalue=Prod*SPworst*240000/1e6/100/1e6;
        baselineemissionsvalue=Prod*240000*SPbaseline/1e6/100/1e6;
        lowambitionemissionsvalue=Prod*240000*SPlow/1e6/100/1e6;
        highambitionemissionsvalue=Prod*240000*SPhigh/1e6/100/1e6;
        
        todayemissionssavings(ii)=max(0,todayemissionsvalue-worstcaseemissionsvalue);
        lowambitionemissionssavings(ii)=max(0,lowambitionemissionsvalue-todayemissionsvalue);
        highambitionemissionssavings(ii)=max(0,highambitionemissionsvalue-todayemissionsvalue);
    end


    DS(j).ISO=ISO;
    DS(j).SubstitionPercent=SPcurrent;
    DS(j).Production=Prod;
    DS(j).todayimpact=max(0,todayemissionsvalue-worstcaseemissionsvalue);
    DS(j).lowambitionemissionssavingsvalue=max(0,lowambitionemissionsvalue-todayemissionsvalue);
    DS(j).highambitionemissionssavingsvalue=max(0,highambitionemissionsvalue-todayemissionsvalue);
end

nsgfig=figure;

mkdir('ImprovedCement_ClinkerSubstitution');
sov2csv(vos2sov(DS),'ImprovedCement_ClinkerSubstitution/ImprovedCement_ClinkerSubstitutionMappingData.csv');

%%%%%%%%%%%%%%%%%
% adoption:     %
%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%GJ/t - categorical
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NSS=getDrawdownNSS;
NSS.title='Current Adoption: Clinker Substitution';
%NSS.DisplayNotes='Range from 2020 lowest efficiency relative to high ambition adoption';
NSS.units='%';
NSS.cmap='ExplorerAdoption1';
NSS.caxis=[20 60];
NSS.figurehandle=nsgfig;
DataToDrawdownFigures(SPcurrentmap,NSS,'CurrentAdoption_Cement_ClinkerSubstitution','ImprovedCement_ClinkerSubstitution');


%%%%%%%%%%%%%%%%%
% Current impact%
%%%%%%%%%%%%%%%%%


NSS=getDrawdownNSS;
NSS.title='Emissions savings from current levels of clinker subsitution';
NSS.units='Mt CO_2-eq/yr';
NSS.cmap=ExplorerImpact1;
NSS.figurehandle=nsgfig;
DataToDrawdownFigures(todayemissionssavings,NSS,'CurrentImpact_Clinker','ImprovedCement_ClinkerSubstitution');



%%%%%%%%%%%%%%%%%%%%%%
% Low ambition impact%
%%%%%%%%%%%%%%%%%%%%%%

NSS=getDrawdownNSS;
NSS.title='Emissions savings from current levels of clinker subsitution';
NSS.units='Mt CO_2-eq/yr';
NSS.cmap=ExplorerImpact1;
NSS.figurehandle=nsgfig;
DataToDrawdownFigures(lowambitionemissionssavings,NSS,'LowAmbitionAdoptionImpact_Clinker','ImprovedCement_ClinkerSubstitution');



%%%%%%%%%%%%%%%%%%%%%%
% High ambition impact%
%%%%%%%%%%%%%%%%%%%%%%

NSS=getDrawdownNSS;
NSS.title='Emissions savings from current levels of clinker subsitution';
NSS.units='Mt CO_2-eq/yr';
NSS.cmap=ExplorerImpact1;
NSS.figurehandle=nsgfig;
DataToDrawdownFigures(highambitionemissionssavings,NSS,'HighAmbitionAdoptionImpact_Clinker','ImprovedCement_ClinkerSubstitution');




