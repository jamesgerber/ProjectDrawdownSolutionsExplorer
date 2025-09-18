function [CurrentEmissions,CurrentAWDUptake,BoUptake,EmissionsIntensityImprovementWithAWDUptake,WetRiceArea,DryRiceArea]=calculatepotentialuptakerice;
% CurrentEmissions - methane emissions from flooded rice
% CurrentAWDUptake - estimates of current uptake of AWD (national level data)
% BoUptake         - Bo et al uptake of AWD (5 minute pixel level data)
% EmissionsIntensityImprovementWithAWDUptake - province level avg emissions intensity improvement
% WetRiceArea  - area of rice (fraction of grid cell) that is irrigated or flooded paddy
% DryRiceArea - upland rice
%
% sum(nansum(CurrentEmissions.*WetRiceArea.*fma)) = 0.696 Gt, with another 0.2 Gt from DryRiceArea
%
%


alreadydone=0;

if alreadydone==0
    %% Advanced management uptake

    load intermediatedata/rice/Year2020RiceCH4eEmissions
    %Year2020CH4eEmissions=perharicech4e.*area2020.*fma;
    perharicech4e=Year2020CH4eEmissions./area2020./fma;
    perharicech4e(area2020<0.001)=0;

    % load layersfromimprovednutrientmanagement/rice_irr75_5min.mat
    % RiceIRR75=DS.Data(:,:,1);
    % RiceIRR75(RiceIRR75>100)=0;
    %
    % load layersfromimprovednutrientmanagement/rice_rf75_5min.mat
    % RiceRF75=DS.Data(:,:,1);
    % RiceRF75(RiceRF75>100)=0;
    DSDir=['~/DrawdownSolutions/'];

  [paddyricearea,uplandricearea,area2020]=returnuplandandpaddyricearea;

  
    [long,lat,BoUFR]=processgeotiff('~/DataProducts/ext/Bo_Yan_RiceEmissions/Yan Bo_GCB/Fig. 5a_SGWP_UFR_spatial_weighted.tif');
    %nsg(BoUFR)
    BoBinary=isfinite(BoUFR) & BoUFR>0;


    [long,lat,raster]=processgeotiff('~/DataProducts/ext/Bo_Yan_RiceEmissions/Yan Bo_GCB/Fig. 5b_SGWP_gwp_RC_spatial_weighted.tif');
    BoGWPDecrease=raster;

    WetRiceArea=paddyricearea;
    DryRiceArea=uplandricearea;

    uptake=datablank;
    percentricearea=datablank;
    BoWeightedPossibleUptake=datablank;
    AvgEmissionsIntensity=datablank;
    WorstCaseEmissionsIntensity=datablank;
    BestCaseEmissionsIntensity=datablank;


    % sketch of methods
    % start with:
    %  current uptake
    %  potential (full) uptake
    %  current emissions
    %  discount (in %) from BO of emissions if full uptake.  Call that BD.
    %
    %  So our current "discount" BDc is (current uptake)/(full uptake)*BD
    %
    %  So zero-mitigation emissions would be Current Emissions / (1-BDc)
    %
    %  So full-adoption emissions would be Current Emissions *(1-BD)/ (1-BDc)
    % Note that an earlier version had BD instead of 1-BD
    %
    %  So change in emissions with full-adoption =
    %  CurrentEmission*( 1 -  (1-BD)/(1-BDc) )

    GADM0=shaperead('~/DataProducts/ext/GADM/GADM41/GADM41_0/GADM41_0.shp');

    BDmap=datablank;
    BDcmap=datablank;
    clear tmpvect tmpvect2
    for j=1:3686;
        [g1,ii]=getgeo41_g1(j);
        percentricearea(ii)=sum(WetRiceArea(ii).*fma(ii))/sum(fma(ii));

        BoWeightedPossibleUptakeScalar=sum(WetRiceArea(ii).*fma(ii).*BoBinary(ii))/...
            sum(WetRiceArea(ii).*fma(ii));

        %GADM0(j).PaddyRiceArea=sum(WetRiceArea(ii).*fma(ii));
        %GADM0(j).UplandRiceArea=sum(DryRiceArea(ii).*fma(ii));

        %  BO_Uptake=BoWeightedPossibleUptakeScalar;
        %  NationalPotentialUptake(j)=BO_Uptake;
        BoWeightedPossibleUptake(ii)=BoWeightedPossibleUptakeScalar;


        BoWeightedGWPDecreaseScalar=nansum(WetRiceArea(ii).*fma(ii).*BoGWPDecrease(ii))/...
            sum(WetRiceArea(ii).*fma(ii));

        BD=-BoWeightedGWPDecreaseScalar/100;

        BDmap(ii)=BD;
        %    GADM0(j).NationalPotentialUptake=BO_Uptake;


        [cf,sd,awd]=RiceAdvancedManagementUptakeCao(g1.gadm0codes{1});
        uptake(ii)=sum(sd+awd);

        BDc=BD*sum(sd+awd)/100;
        BDcmap(ii)=BDc;

        tmpvect(j) = nansum(perharicech4e(ii).*WetRiceArea(ii).*fma(ii));


        % harvested area per geo unit
        HarvestedAreaWet(j)=nansum(WetRiceArea(ii).*fma(ii));
        HarvestedAreaDry(j)=nansum(DryRiceArea(ii).*fma(ii));

        % Emissions Intensity per cultivated HA
        tmpvect2(j)=nansum(perharicech4e(ii).*WetRiceArea(ii).*fma(ii))/nansum(WetRiceArea(ii).*fma(ii));
        tmpvect3(j)=nansum(perharicech4e(ii).*DryRiceArea(ii).*fma(ii))/nansum(DryRiceArea(ii).*fma(ii));
        AvgEmissionsIntensity(ii)=tmpvect2(j);

        TotalEmissionsWet(j)=tmpvect2(j);
        TotalEmissionsDry(j)=tmpvect3(j);

        % Emissions Intensity with adoption of AWD
        WorstCaseEmissionsIntensity(ii)=tmpvect2(j)./(1-BDc);

        BestCaseEmissionsIntensity(ii)=tmpvect2(j)./(1-BDc)*(1-BD);
    end

    % BestCase not allowed to be worse than today
    jj=(BestCaseEmissionsIntensity>AvgEmissionsIntensity);
    BestCaseEmissionsIntensity(jj)=AvgEmissionsIntensity(jj);

    % Worst case not allowed to be better than today
    jj=(WorstCaseEmissionsIntensity<AvgEmissionsIntensity);
    WorstCaseEmissionsIntensity(jj)=AvgEmissionsIntensity(jj);


    EmissionsIntensityImprovementWithAWDUptake=AvgEmissionsIntensity-BestCaseEmissionsIntensity;

    sum(nansum(AvgEmissionsIntensity.*WetRiceArea.*fma))


    save intermediatedata/RiceSolutionsEmissionsIntensitiesRevB AvgEmissionsIntensity WorstCaseEmissionsIntensity ...
        BestCaseEmissionsIntensity perharicech4e paddyricearea EmissionsIntensityImprovementWithAWDUptake WetRiceArea ...
        DryRiceArea uptake BoWeightedPossibleUptake
end

load intermediatedata/RiceSolutionsEmissionsIntensitiesRevB


CurrentEmissions=AvgEmissionsIntensity;
CurrentAWDUptake=uptake/100;
BoUptake=BoWeightedPossibleUptake;
