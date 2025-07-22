[Dataset,VersionInfo,MetadataNotes]=ExternalDataGateway(Dataset,Version,varargin);
% ExternalDataGateway - gateway to public data we don't redistribute
% 
% [Dataset,VersionInfo,MetadataNotes]=ExternalDataGateway(Dataset,Version,varargin);


switch Dataset
    case 'BoYanRiceEmissions_Fig5a_UFR';
        [long,lat,BoUFR]=processgeotiff('~/DataProducts/ext/Bo_Yan_RiceEmissions/Yan Bo_GCB/Fig. 5a_SGWP_UFR_spatial_weighted.tif');
        Dataset=BoUFR;
        'VersionInfo'='n/a';
        MetadataNotes='This data shared with Project Drawdown by Yan Bo, see Bo et al, GCB 2022'

    case 'BoYanRiceEmissions_Fig5b_GWPDecrease';
        [long,lat,raster]=processgeotiff('~/DataProducts/ext/Bo_Yan_RiceEmissions/Yan Bo_GCB/Fig. 5b_SGWP_gwp_RC_spatial_weighted.tif');
        BoGWPDecrease=raster;
        Dataset=BoUFR;
        'VersionInfo'='n/a';
        MetadataNotes='This data shared with Project Drawdown by Yan Bo, see Bo et al, GCB 2022'

    case 'CropGrids'

        crop=varargin{1};

        switch Version

            



    case 

    otherwise
        error
end
