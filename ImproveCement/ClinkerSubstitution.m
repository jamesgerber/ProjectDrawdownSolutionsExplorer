a=readgenericcsv('intermediatedatafiles/CementGCCAData.csv')

%% Calculation Section
todayimpact=datablank*nan;
baselineimpact=datablank*nan;
lowambitionimpact=datablank*nan;
highambitionimpact=datablank*nan;
SPcurrentmap=datablank*nan;


SPworst=0;
SPbaseline=18.569;
SPlow=19.05;
SPhigh=43.1;
SPceil=67.15;

clear DS

for j=1:261;

    ISO=gadmlimitedlist(j);
    [g0,ii]=getgeo41_g0(ISO);

    [TEC,Prod,C2C,AltFuelsRatio,~]=CountrySpecificCementFactors(g0.gadm0codes{1});

    if ~isnan(TEC) &  isfinite(Prod) ;
        DataStatus=0; % the best, we have GCCR data and production
    elseif isnan(Prod)
        DataStatus=2; % sad! no GCCR, and no Production
    else
        DataStatus=1; % No GCCR, but there is Production
    end


    if DataStatus==2
        Productionmap(ii)=nan;
    else
        Productionmap(ii)=Prod;
    end

    SubsPercent=95-C2C*100;
    SPcurrent=SubsPercent;

    if DataStatus==1
        AltFuelsRatio=nan;
        C2C=nan;
        SPcurrent=nan;
    end
    if DataStatus==2;
        AltFuelsRatio=nan;
        C2C=nan;
        SPcurrent=nan;
        Prod=nan;
    end

    SPcurrentmap(ii)=SPcurrent;
    todaysavingsvalue=Prod*SPcurrent*240000/1e6/100/1e6;
    worstcasesavingsvalue=Prod*SPworst*240000/1e6/100/1e6;
    baselinesavingsvalue=Prod*240000*SPbaseline/1e6/100/1e6;
    lowambitionsavingsvalue=Prod*240000*SPlow/1e6/100/1e6;
    highambitionsavingsvalue=Prod*240000*SPhigh/1e6/100/1e6;
    ceilingambitionsavingsvalue=Prod*240000*SPceil/1e6/100/1e6;

    if DataStatus==0
        todayimpact(ii)=max(0,todaysavingsvalue-worstcasesavingsvalue);
        baselineimpact(ii)=max(0,baselinesavingsvalue-worstcasesavingsvalue);
        lowambitionimpact(ii)=max(0,lowambitionsavingsvalue-worstcasesavingsvalue);
        highambitionimpact(ii)=max(0,highambitionsavingsvalue-worstcasesavingsvalue);
        ceilingambitionimpact(ii)=max(0,ceilingambitionsavingsvalue-worstcasesavingsvalue);
    end


    DS(j).ISO=ISO;
    DS(j).SubstitionPercent=SPcurrent;
    DS(j).Production=Prod;
    DS(j).DataStatus=DataStatus;

    % need this because max(0,nan)=0 for reasons that elude me.
    if DataStatus>0
        DS(j).todayimpact=NaN;
    else
        DS(j).todayimpact=max(0,todaysavingsvalue-worstcasesavingsvalue);
    end

    DS(j).baselineimpact=max(0,baselinesavingsvalue-worstcasesavingsvalue);
    DS(j).lowambitionimpact=max(0,lowambitionsavingsvalue-worstcasesavingsvalue);
    DS(j).highambitionimpact=max(0,highambitionsavingsvalue-worstcasesavingsvalue);
    DS(j).ceilingambitionimpact=max(0,ceilingambitionsavingsvalue-worstcasesavingsvalue);
    DS(j).lowambitioncumulativeimpact=max(DS(j).todayimpact,DS(j).lowambitionimpact);
    DS(j).highambitioncumulativeimpact=max(DS(j).todayimpact,DS(j).highambitionimpact);
    DS(j).ceilingambitioncumulativeimpact=max(DS(j).todayimpact,DS(j).ceilingambitionimpact);
end

nsgfig=figure('Visible','off');

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
NSS.units='Substitute material %';
NSS.cmap='ExplorerAdoption1';
NSS.caxis=[20 60];
NSS.figurehandle=nsgfig;
DataToDrawdownFigures(SPcurrentmap,NSS,'CurrentAdoption_Cement_ClinkerSubstitution','ImprovedCement_ClinkerSubstitution');


%%%%%%%%%%%%%%%%%
% Current impact%
%%%%%%%%%%%%%%%%%


NSS=getDrawdownNSS;
NSS.title='Emissions savings from current adoption of clinker subsitution';
NSS.units='Mt CO_2-eq/yr';
NSS.cmap=ExplorerImpact1;
NSS.figurehandle=nsgfig;
DataToDrawdownFigures(todayimpact,NSS,'CurrentImpact_Clinker','ImprovedCement_ClinkerSubstitution');



%%%%%%%%%%%%%%%%%%%%%%
% Low ambition impact%
%%%%%%%%%%%%%%%%%%%%%%

NSS=getDrawdownNSS;
NSS.title='Emissions savings from low ambition adoption of clinker subsitution';
NSS.units='Mt CO_2-eq/yr';
NSS.cmap=ExplorerImpact1;
NSS.figurehandle=nsgfig;
DataToDrawdownFigures(lowambitionimpact,NSS,'LowAmbitionAdoptionImpact_Clinker','ImprovedCement_ClinkerSubstitution');



%%%%%%%%%%%%%%%%%%%%%%
% High ambition impact%
%%%%%%%%%%%%%%%%%%%%%%

NSS=getDrawdownNSS;
NSS.title='Emissions savings from high ambition adoption of clinker subsitution';
NSS.units='Mt CO_2-eq/yr';
NSS.cmap=ExplorerImpact1;
NSS.figurehandle=nsgfig;
DataToDrawdownFigures(highambitionimpact,NSS,'HighAmbitionAdoptionImpact_Clinker','ImprovedCement_ClinkerSubstitution');




