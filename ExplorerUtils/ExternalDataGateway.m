function [DataOut,VersionInfo,MetadataNotes]=ExternalDataGateway(Dataset,Version,varargin);
% ExternalDataGateway - gateway to public data we don't redistribute
%
% [Dataset,VersionInfo,MetadataNotes]=ExternalDataGateway(Dataset,Version,varargin);


switch Dataset
    case 'BoYanRiceEmissions_Fig5a_UFR';
        [long,lat,BoUFR]=processgeotiff('~/DataProducts/ext/Bo_Yan_RiceEmissions/Yan Bo_GCB/Fig. 5a_SGWP_UFR_spatial_weighted.tif');
        DataOut=BoUFR;
        VersionInfo='n/a';
        MetadataNotes='This data shared with Project Drawdown by Yan Bo, see Bo et al, GCB 2022'

    case 'BoYanRiceEmissions_Fig5b_GWPDecrease';
        [long,lat,raster]=processgeotiff('~/DataProducts/ext/Bo_Yan_RiceEmissions/Yan Bo_GCB/Fig. 5b_SGWP_gwp_RC_spatial_weighted.tif');
        BoGWPDecrease=raster;
        DataOut=BoUFR;
        VersionInfo='n/a';
        MetadataNotes='This data shared with Project Drawdown by Yan Bo, see Bo et al, GCB 2022'

    case 'CropGrids'

        crop=varargin{1};

        switch Version

            case '1.08';


                        VersionInfo='1.08';

        end


    case 'mirca2000'
        %D=ExternalDataGateway('mirca2000',~,'rice');
        %        D.MaxMonthlyIRR
        %        D.MaxMonthlyRF
        %    MaxMonthlyIRR=max(Svector(6).Data,[],3)./fma;
        %    MaxMonthlyRF=max(Svector(5).Data,[],3)./fma;
        
        crop=varargin{1};
        switch crop

            case 'rice'

                x=load([iddstring 'Irrigation/MIRCA2000_processed/ncmat/mirca2000_crop3.mat'])

                MaxMonthlyIRR=max(x.Svector(6).Data,[],3)./fma;
                MaxMonthlyRF=max(x.Svector(5).Data,[],3)./fma;
                DataOut.MaxMonthlyIRR=MaxMonthlyIRR;
                DataOut.MaxMonthlyRF=MaxMonthlyRF;

                % case

            otherwise
                error
        end
        VersionInfo='n/a'

    case 'TerraClimatePEToverP'

        % Here's the code I used to get PET/P, TerraClimate datasets from the Nutrient
        % Management work that was done in early 2025 led by Avery Driscoll, Project Drawdown.
        % s=opengeneralnetcdf('TerraClimate19912020_pet.nc');
        % s2=opengeneralnetcdf('TerraClimate19912020_ppt.nc');
        %
        % pptoverpet=sum(double(s2(5).Data(:,:,:)),3)./sum(double(s(5).Data(:,:,:)),3);
        % pptoverpet=aggregate_rate(pptoverpet,2);
        % save intermediatedatalayers/rice/pptoverpet pptoverpet

        
        x=load('~/DataProducts/ext/TerraClimate/pptoverpet.mat');
        DataOut=x.pptoverpet;
    otherwise
        error
end
