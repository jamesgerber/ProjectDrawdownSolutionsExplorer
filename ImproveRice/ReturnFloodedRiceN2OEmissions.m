function [EmissionsPerHA_AWD_CO2eq,EmissionsPerHA_CF_CO2eq,fractionhaperpixel,...
    fractionAWD,fractionCF,EmissionsPerHA_AWD_CO2eq_HighAdoption,...
    EmissionsPerHA_CF_CO2eq_HighAdoption,EmissionsAvoidedPerHA_CF_CO2eq,...
    EmissionsAvoidedPerHA_AWD_CO2eq,EffectivenessNutrMan_tonsCO2_eqPerTonNavoided,...
    CurrentAdoption_TonsperHa,HighAdoption_TonsperHA]=ReturnFloodedRiceN2OEmissions;


% Return CO2eq emissions from N application to Flooded Rice
% EmissionsPerHA_AWD_CO2eq  - N2O emissions per cultivated ha if AWD
% EmissionsPerHA_CF_CO2eq   - N2O emissions per cultivated ha if CF
% fractionhaperpixel  - fraction of pixel that is cultivated (can exceed 1)
% fractionAWD- fraction of cultivated rice where AWD appropriate (per Bo)
% fractionCF - fraction of cultivated rice  where AWD not appropriate (per Bo)
% EmissionsPerHA_AWD_CO2eq_HighAdoption -  N2O emissions per cultivated ha
% if AWD (high adoption of solution)
% EmissionsPerHA_CF_CO2eq_HighAdoption
% EmissionsAvoidedPerHA_CF_CO2eq - emissions avoided from solution uptake
% EmissionsAvoidedPerHA_AWD_CO2eq - emissions avoided from solution uptake
% EffectivenessNutrMan_tonsCO2_eqPerTonNavoided - Effectiveness of decrease of 1 ton N2O emissions
% CurrentAdoption_TonsperHa - Current adoption, tons per ha
% HighAdoption_TonsperHA - High adoption, tons per ha
%
%
% This script will perform the calculation of improved nutrient management
% for continuously flooded rice.  Here's why that is necessary:  The
% Improved N Management solution excluded flooded rice because N2O and
% methane practices are connected in the context of flooded rice.  However,
% there are two situations where you can't implement AWD (alternate wetting
% and drying:) 1 is the paddies are rainfed - can't drain.  The other is
% implementing AWD would adversely impact yields.
%
% The layers for N management for flooded rice have already been
% spatialized and calculated (by Avery Driscoll)
%
% Here, we need to allocate those layers onto AWD-possible and
% AWD-not-possible.
%
% We have the Salmon data for different types of rice.  
%
% Here is what is in IrrigatedRice_avoidable_N_achievable.tif
% 1     Band 01: avoided_n	nan	5.2651569036	9802180.2740512006
% 2	    Band 02: avoided_n_lb	nan	0.0000000000	9309222.2443154994
% 3	    Band 03: avoided_n_ub	nan	0.0000000007	11076738.9675210007
% 4	    Band 04: median_n	nan	0.0000000000	7732454.7614273997
% 5	    Band 05: prop_syn	nan	0.0000000000	0.9803211701
% 6	    Band 06: n_rate	nan	0.5222628962	1182.5040771484
% 7	    Band 07: current_adoption	nan	0.3268937260	8636715.7640346009
% 8	    Band 08: original_n_kg	nan	0.2502823304	19830738.1418819986
% 9	    Band 09: original_syn_kg	nan	0.0000000000	18535024.6221950017
% 10	Band 10: original_org_kg	nan	0.2376419584	5522738.0074651996
% 11	Band 11: syn_avoided	nan	0.0000000000	8581050.6421264000
% 12	Band 12: org_avoided	nan	1.1271081688	4047370.8019893002
% 13	Band 13: syn_avoided_lb	nan	0.0000000000	8089796.5532818995
% 14	Band 14: org_avoided_lb	nan	0.0000000000	3976201.8612914002
% 15	Band 15: syn_avoided_ub	nan	0.0000000000	9851203.7421278004
% 16	Band 16: org_avoided_ub	nan	0.0000000004	4231380.3658870999
% 17	Band 17: org_emiss	nan	5.6017273625	20115432.0367150009
% 18	Band 18: org_emiss_lb	nan	0.0000000000	1709766.8287953001
% 19	Band 19: org_emiss_ub	nan	0.0000000058	56023475.0758590028
% 20	Band 20: syn_emiss	nan	0.0000000000	72526287.9974129945
% 21	Band 21: syn_emiss_lb	nan	0.0000000000	49949131.0351419970
% 22	Band 22: syn_emiss_ub	nan	0.0000000000	159181570.5395199955


% from Avery Driscoll (slack, May 2, 2025, with james, Eric T, Avery)
% "current_adoption" is the current adoption in kg N
% "avoided_n_lb" is the achievable high in kg N
% "median_n" is (misleadingly named) the achievable low in kg N
% 
% James Gerber
%  10:03 AM
%  Hi Avery-
% to make sure I'm tracking, is avoided_n_ub the ceiling high in kg N?
% and what is the "avoided_n" field?
% thanks!!
% 

% Avery Driscoll
%   10:11 AM
% Hi! We did the calcs with a few different NUE quantiles. I unfortunately
% don't have the code with me right now (can double check in a few hours),
% but I am nearly certain that median_n is the avoidable N assuming the
% median NUE, avoided_n_lb assumes the 70th percentile, avoided_n assumes
% the 80th percentile, and avoided_n_ub assumes the 90th percentile. We
% went back and forth about which percentile to use for the
% ceiling/achievable range, but ended up with avoided_n (80th percentile)
% as the ceiling and did not use avoided_n_ub (90th percentile).       

ricemegatif=processgeotiff('~/DrawdownSolutions/ImproveRice/inputdatafiles/IrrigatedRice_avoidable_N_achievable.tif');

avoided_n=ricemegatif(:,:,1);
median_n=ricemegatif(:,:,4);
original_n_kg=ricemegatif(:,:,8);
original_n_syn_kg=ricemegatif(:,:,9);
original_n_org_kg=ricemegatif(:,:,10);
current_adoption=ricemegatif(:,:,7);
nrate=ricemegatif(:,:,6);
syn_emiss=ricemegatif(:,:,20);
prop_syn=ricemegatif(:,:,5);
nratehigh=ricemegatif(:,:,1);

area=original_n_kg./nrate;

clear DS

for j=1:263;
    [g0,ii]=getgeo41_g0(j);
    DS(j).ISO=g0.gadm0codes{1};
    DS(j).name=g0.namelist0{1};
    DS(j).OrigN=nansum(original_n_kg(ii));

    DS(j).avoidedn=nansum(avoided_n(ii));
    DS(j).currentadoption=nansum(current_adoption(ii));
end
%sov2csv(vos2sov(DS),'testing.csv');

% %This leads to broad agreement
% (OrigN - current kgN application)
% (current adoption - current adoption)
% (avoidedN - Avoidable kg N)
% 


% Where is AWD?

%% Use some data from Salmon et al:
load  '~/DataProducts/int/CarlsonCropEmissionsData/2020update/Year2020RiceCH4eEmissions'; % Year2020CH4eEmissions area2020
%Year2020CH4eEmissions=perharicech4e.*area2020.*fma;
perharicech4e=Year2020CH4eEmissions./area2020./fma;
perharicech4e(area2020<0.001)=0;

[paddyricearea,uplandricearea,area2020]=returnuplandandpaddyricearea;
fractionhaperpixel=paddyricearea;

%% Raw MIRCA

%load 'intermediatedatalayers/rice/mirca2000_crop3.mat'
%MaxMonthlyIRR=max(Svector(6).Data,[],3)./fma;
%MaxMonthlyRF=max(Svector(5).Data,[],3)./fma;
D=ExternalDataGateway('mirca2000',0,'rice');
MaxMonthlyIRR=     D.MaxMonthlyIRR;
MaxMonthlyRF= D.MaxMonthlyRF;


firr=MaxMonthlyIRR./(MaxMonthlyRF+MaxMonthlyIRR);
frf=MaxMonthlyRF./(MaxMonthlyRF+MaxMonthlyIRR);


% also want fraction awd, fraction cf (where cf includes upland)
% in places where Bo reports awd not suitable, we flip firr over to frf
[long,lat,BoUFR]=processgeotiff('~/DataProducts/ext/Bo_Yan_RiceEmissions/Yan Bo_GCB/Fig. 5a_SGWP_UFR_spatial_weighted.tif');
BoBinary=isfinite(BoUFR) & BoUFR>0;

fawd=datablank;
fawd(BoBinary==1)=firr(BoBinary==1);
fcf=frf;
fcf(BoBinary==0)= (frf(BoBinary==0)+firr(BoBinary==0));

fractionAWD=fawd;
fractionCF=fcf;

% Avery's summary:
% the standard guidance is just to use the "wet" climate indirect EFs for flooded rice. For AWD, you'd want the "wet" indirect EFs if it's either irrigated or meets the P/PET threshold (0.65), and the "dry" EFs if it's upland rice with P/PET < 0.65. In terms of N2O-N:
% Direct emissions for flooded rice: (N*0.003)
% Direct emissions from AWD: (N*0.005)
% Leaching emissions for wet climates and/or irrigated rice, for both organic and synthetic N inputs: (N*0.00264)
% Leaching emissions for AWD in dry climates: none
% Volatilization emissions from organic N, wet climates and/or irrigated rice: (N*0.00294)
% Volatilization emissions from synthetic N, wet climates and/or irrigated rice: (N*0.00154)
% Volatilization emissions from organic N for AWD in dry climates: (N*0.00105)
% Volatilization emissions from synthetic N for AWD in dry climates: (N*0.00055)
% 

%load intermediatedatalayers/rice/pptoverpet pptoverpet  % see notes at bottom with source of this data layer
pptoverpet=ExternalDataGateway('TerraClimatePEToverP');


iidry=pptoverpet<0.65;
iiwet=pptoverpet>=0.65;
eta=prop_syn;

%       direct  + leaching          + vol
EF_CF=(0.003     + 0.00264            +  eta*0.00154 + (1-eta)*0.00294 );
EF_AWD=(0.005    +  iiwet*0.00264   +  eta*0.00055 + (1-eta)*0.00105);

% so to get N2O emissions per hectare, we must multiply nrate by EF 

EmissionsPerHA_CF_CO2eq=nrate.*EF_CF.*44/28*273/1e3;
EmissionsPerHA_AWD_CO2eq=nrate.*EF_AWD.*44/28*273/1e3;

% factors at end 44/28 goes from N to N2O
% 273 goes from N2O to CO2-eq
% 1e3 goes from kg/ha to tons/ha

% let's zero this out where there are nans

fractionCF(isnan(fractionCF))=0;
fractionAWD(isnan(fractionAWD))=0;

% Effectiveness
EffectivenessNutrMan_tonsCO2_eqPerTonNavoided=...
    (EF_CF.*44/28*273).*fractionCF + ...
(EF_AWD.*44/28*273).*fractionAWD;


% Now that nrate calculation not with nrate but high adoption rate

nrateHighAdoption= nrate.*(original_n_kg-avoided_n)./original_n_kg;

EmissionsPerHA_CF_CO2eq_HighAdoption=nrateHighAdoption.*EF_CF.*44/28*273/1e3;
EmissionsPerHA_AWD_CO2eq_HighAdoption=nrateHighAdoption.*EF_AWD.*44/28*273/1e3;


current_adoption_rate=current_adoption./area;

EmissionsAvoidedPerHA_CF_CO2eq=current_adoption_rate.*EF_CF.*44/28*273/1e3;
EmissionsAvoidedPerHA_AWD_CO2eq=current_adoption_rate.*EF_AWD.*44/28*273/1e3;

CurrentAdoption_TonsperHa=current_adoption./(area.*fma);
HighAdoption_TonsperHA=nrateHighAdoption./(area.*fma);

% Here's the code I used to get PET/P, TerraClimate datasets from the Nutrient
% Management work that was done in early 2025 led by Avery Driscoll, Project Drawdown.
% s=opengeneralnetcdf('TerraClimate19912020_pet.nc');
% s2=opengeneralnetcdf('TerraClimate19912020_ppt.nc');
% 
% pptoverpet=sum(double(s2(5).Data(:,:,:)),3)./sum(double(s(5).Data(:,:,:)),3);
% pptoverpet=aggregate_rate(pptoverpet,2);
% save intermediatedatalayers/rice/pptoverpet pptoverpet




