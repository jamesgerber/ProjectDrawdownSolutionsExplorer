% 

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

% get map of all areas.

cn=cropnames;

asum=datablank;
for j=1:numel(cn);
    cropname=cn{j};
    a=pgt(['~/DataProducts/ext/CropGrids/cropgridareasVer108tifs/CROPGRID_Areas_Version8_' cropname '.mat.tif']);
    asum=asum+a;
end

apersum=datablank;


for j=1:numel(cn);
    cropname=cn{j};

    idx=strmatch(cropname,cc.CROPNAME,'exact')
    if numel(idx)~=1
        error
    end
      
    if isequal(cc.Ann_Per{idx},'perennial')
        a=pgt(['~/DataProducts/ext/CropGrids/cropgridareasVer108tifs/CROPGRID_Areas_Version8_' cropname '.mat.tif']);
        apersum=apersum+a;
    end
end


atreeshrubsum=datablank;


for j=1:numel(cn);
    cropname=cn{j};

    idx=strmatch(cropname,cc.CROPNAME,'exact')
    if numel(idx)~=1
        error
    end
      
    if isequal(cc.Ann_Per{idx},'perennial') ...
            & (isequal(cc.Form{idx},'shrub') | isequal(cc.Form{idx},'tree') )
        a=pgt(['~/DataProducts/ext/CropGrids/cropgridareasVer108tifs/CROPGRID_Areas_Version8_' cropname '.mat.tif']);
        atreeshrubsum=atreeshrubsum+a;
    end
end


%% fraction of cropland area that's currently perennial:


BaseNSS=getDrawdownNSS; 
BaseNSS.PlotFlag='off';




% Some maps for Drawdown Explorer

ExplorerMapsAndDataFilename='PerennialCrops_MapsAndData'

% fraction perennial

fracperennial=apersum./asum;
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

fracannuals=croplandraster.*(asum-apersum)./(asum);
ii=AreaFilter(croplandraster,croplandraster,.95); % remove small gridcells
fracannuals(~ii)=nan;

NSS=BaseNSS;
NSS.cmap='white_purple_blue';
NSS.caxis=[0 1];
NSS.title='Fraction of cropland which is currently annuals';
NSS.cbarvisible='on';
NSS.units='fraction';
DataToDrawdownFigures(fracannuals,NSS,'fractionannual',ExplorerMapsAndDataFilename);

% that will be cropland area (croplandraster*fma) * (allcrops-perennials)/allcrops

fracannuals=croplandraster.*(asum-apersum)./(asum);
ii=AreaFilter(croplandraster,croplandraster,.95); % remove small gridcells
fracannuals(~ii)=nan;

fracannualstropics=fracannuals;
fracannualstropics(~tropicsmap)=nan;


NSS=BaseNSS;
NSS.cmap='white_purple_blue';
NSS.caxis=[0 1];
NSS.title='Fraction of tropical landscape devoted to annual crops';
NSS.cbarvisible='on';
NSS.units='fraction';
DataToDrawdownFigures(fracannualstropics,NSS,'fractionannualtropics',ExplorerMapsAndDataFilename);







