
[long,lat,croplandraster]=processgeotiff('~/shareddrives/GeospatialDrive/ProcessedData/Landcover/MehrabiCropPastureArea2015/cropland2015.tif');
[long,lat,pastureraster]=processgeotiff('~/shareddrives/GeospatialDrive/ProcessedData/Landcover/MehrabiCropPastureArea2015/pasture2015.tif');


croplandraster(croplandraster>250)=0;
pastureraster(pastureraster>250)=0;
croplandraster(isnan(croplandraster))=0;
pastureraster(isnan(pastureraster))=0;

wd=pwd;
cd('~/temp')


% NSS=getDrawdownNSS;
% NSS.cmap=neoncolorbar;
% NSS.uppermap=[.1 .1 .1]*2;
% nsg(croplandraster,NSS);
% 
% maketransparentoceans_noant_nogridlinesnostates_removeislands...
%     ('temp.png','DrawdownStyle2_croplandmap.png',[1 1 1],1);
% 
% 
% % now make alpha channel of gray:
% 
% NSS.cmap='revgray';
% nsg(croplandraster*100,NSS);
% maketransparentoceans_noant_nogridlinesnostates_removeislands...
%     ('temp.png','DrawdownStyle2_croplandgray.png',[1 1 1],1);
% 
% 
% graytoscaledalpha('DrawdownStyle2_croplandmap.png','Drawdowncropland_alpha.png','DrawdownStyle2_croplandgray.png')
% 
% 
% 
% 
% %P=OpenNetCDF([iddstring '/Crops2000/Pasture2000_5min.nc']);
% 
% NSS=getDrawdownNSS;
% NSS.cmap=orangecolorbar;
% 
% nsg(pastureraster,NSS);
% maketransparentoceans_noant_nogridlinesnostates_removeislands...
%     ('temp.png','DrawdownStyle2_pasturemap.png',[1 1 1],1);
% 
% 
% % now make alpha channel of gray:
% 
% NSS.cmap='revgray';
% nsg(pastureraster*100,NSS);
% maketransparentoceans_noant_nogridlinesnostates_removeislands...
%     ('temp.png','DrawdownStyle2_pasturegray.png',[1 1 1],1);
% 
% 
% graytoscaledalpha('DrawdownStyle2_pasturemap.png','Drawdownpasture_alpha.png','DrawdownStyle2_pasturegray.png')
% 
% NSS=getDrawdownNSS;
% NSS.TitleString='Cropland and Pasture Extent in 2000';
% NSS.cmap=[.8 .8 .8;.8 .8 .8;.8 .8 .8;.8 .8 .8;];
% nsg(landmasklogical,NSS);
% maketransparentoceans_noant_nogridlinesnostates_removeislands...
%     ('temp.png','croppasturelegendbackground.png',[1 1 1],1);
% 
% NSS=getDrawdownNSS;
% NSS.TitleString='';
% NSS.cmap=[.8 .8 .8;.8 .8 .8;.8 .8 .8;.8 .8 .8;]*.3/.8;
% nsg(landmasklogical,NSS);
% maketransparentoceans_noant_nogridlinesnostates_removeislands...
%     ('temp.png','croppasturelegendbackground_notitle.png',[1 1 1],1);
% 
% 
% % unix command suggested by Claude for combining these externally to keynote 
% !magick Drawdownpasture_alpha.png Drawdowncropland_alpha.png -compose over -composite combined.png

% now attempt using Alex's code:

% first code block:  this is making the cropland area raster, then it makes
% a gray version.  We'll then use that gray version to define how much
% transparency to go in the alpha channel.
NSS=getDrawdownNSS;
NSS.cmap=neoncolorbar;
NSS.uppermap=[.1 .1 .1]*2;
%nsg(croplandraster,NSS);

DataToDrawdownFigures(croplandraster,NSS,'croplandraster','tempmaps/')


% this now irrelevant - we have a transparent version
%maketransparentoceans_noant_nogridlinesnostates_removeislands...
%    ('temp.png','DrawdownStyle2_croplandmap.png',[1 1 1],1);


% now make alpha channel of gray:

NSS.cmap='revgray';
%nsg(croplandraster*100,NSS);
%maketransparentoceans_noant_nogridlinesnostates_removeislands...
%    ('temp.png','DrawdownStyle2_croplandgray.png',[1 1 1],1);
DataToDrawdownFigures(croplandraster,NSS,'croplandrastergray','tempmaps/')


graytoscaledalpha('tempmaps/FigsStyledFor2026/croplandraster_transparent.png','Drawdowncropland_alpha.png',...
    'tempmaps/FigsStyledFor2026/croplandrastergray_transparent.png')

% now generalize to pasture
NSS=getDrawdownNSS;
NSS.cmap=orangecolorbar;
NSS.uppermap=[.1 .1 .1]*2;
DataToDrawdownFigures(pastureraster,NSS,'pastureraster','tempmaps/')

NSS.cmap='revgray';
DataToDrawdownFigures(pastureraster,NSS,'pasturerastergray','tempmaps/')

graytoscaledalpha('tempmaps/FigsStyledFor2026/pastureraster_transparent.png','Drawdownpasture_alpha.png',...
    'tempmaps/FigsStyledFor2026/pasturerastergray_transparent.png')

% now background
NSS=getDrawdownNSS;
NSS.TitleString='';
NSS.cmap=[.8 .8 .8;.8 .8 .8;.8 .8 .8;.8 .8 .8;]*.3/.8;
DataToDrawdownFigures(landmasklogical,NSS,'landmask','tempmaps/')

NSS.cmap=[.8 .8 .8;.8 .8 .8;.8 .8 .8;.8 .8 .8;]*0;
DataToDrawdownFigures(croplandraster,NSS,'landmaskblack','tempmaps/')


!cp tempmaps/FigsStyledFor2026/landmask_transparent.png landmask_transparent.png

%% now apply techniques for the light ones:
graytoscaledalpha('tempmaps/FigsStyledFor2026/croplandraster_light_transparent.png','Drawdowncropland_light_alpha.png',...
    'tempmaps/FigsStyledFor2026/croplandrastergray_light_transparent.png')

graytoscaledalpha('tempmaps/FigsStyledFor2026/pastureraster_light_transparent.png','Drawdownpasture_light_alpha.png',...
    'tempmaps/FigsStyledFor2026/pasturerastergray_light_transparent.png')

!cp tempmaps/FigsStyledFor2026/landmask_light_transparent.png landmask_light_transparent.png

% now take all three of these and make them fully transparent outside of
% where tempmaps/FigsStyledFor2026

a=imread('Drawdowncropland_light_alpha.png');
[A,mask,transp]=imread('tempmaps/FigsStyledFor2026/landmaskblack_overlay_transparent.png');





% at very end move things to here:
% ls ../shareddrives/GeospatialDrive/StaticMaps/ProductionMaps/PresentationMaps/CroplandAndPasture/