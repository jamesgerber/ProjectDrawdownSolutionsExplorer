% Version where I use fractions of perennials from MIRCA
% much better than previous version.
basedir=[getenv('GEOSPATIAL_AGRICULTURE') '/MIRCA2000CroplandUseIntensity/'];

annarea=pgt([basedir 'fractiongridcellarea_2000_annualcrops_lessIrrRice.tif']);
perarea=pgt([basedir 'fractiongridcellarea_2000_perennialcrops_PlusIrrRice.tif']);


% what is cropland area:
[croplandraster,pastureraster]=get2015croppasturearea;

[~,~,lon2,lat2]=inferlonglat;
%jj=abs(lat2) < 23.4 & jj;

cc=getcropcharacteristics;

tropicsmap=datablank;

for j=1:263;

    %ISO=MinxCountriesList(j);

    [g0,idx,~,ISO]=getgeo41_g0(j);
    ii=datablank;
    ii(idx)=1;
    ii=logical(ii);
    MeanLat=sum(croplandraster(ii).*fma(ii).*lat2(ii))/sum(croplandraster(ii).*fma(ii));

    if abs(MeanLat)<=23.4;

        tropicsmap=tropicsmap | ii;

    end

end



%% fraction of cropland area that's currently perennial:


BaseNSS=getDrawdownNSS;
BaseNSS.PlotFlag='off';




% Some maps for Drawdown Explorer

ExplorerMapsAndDataFilename='PerennialCropsMIRCAFractions_MapsAndData'

% fraction perennial

fracperennial=perarea./(annarea+perarea);
ii=AreaFilter(croplandraster,croplandraster,.95); % remove small gridcells
fracperennial(~ii)=nan;


NSS=BaseNSS;
NSS.cmap='white_purple_red';
NSS.caxis=[0 1];
NSS.title='Fraction of cropland which is currently perennial';
NSS.cbarvisible='on';
NSS.units='fraction';
DataToDrawdownFigures(fracperennial,NSS,'fractionperennial',ExplorerMapsAndDataFilename);


% land area that is growing annuals.

% that will be cropland area (croplandraster*fma) * annuals/allcrops
% that will be cropland area (croplandraster*fma) * (allcrops-perennials)/allcrops

fracannuals=1-perarea./(annarea+perarea);
ii=AreaFilter(croplandraster,croplandraster,.95); % remove small gridcells
fracannuals(~ii)=nan;

NSS=BaseNSS;
NSS.cmap='white_purple_blue';
NSS.caxis=[0 1];
NSS.title='Fraction of cropland which is currently annuals (-irr rice)';
NSS.cbarvisible='on';
NSS.units='fraction';
DataToDrawdownFigures(fracannuals,NSS,'fractionannual',ExplorerMapsAndDataFilename);

% that will be cropland area (croplandraster*fma) * (allcrops-perennials)/allcrops

fracannuals=(1-perarea./(annarea+perarea)).*croplandraster;
ii=AreaFilter(croplandraster,croplandraster,.95); % remove small gridcells
fracannuals(~ii)=nan;

fracannualstropics=fracannuals;
fracannualstropics(~tropicsmap)=nan;


NSS=BaseNSS;
NSS.cmap='white_purple_blue';
NSS.caxis=[0 1];
NSS.title='Fraction of tropical landscape devoted to annual crops (-irr rice)';
NSS.cbarvisible='on';
NSS.units='fraction';
DataToDrawdownFigures(fracannualstropics,NSS,'fractionannualtropics',ExplorerMapsAndDataFilename);

SumNonIrrRiceAnnualCroplandAreaInTropics=sum(nansum(fracannualstropics.*fma))/1e6







