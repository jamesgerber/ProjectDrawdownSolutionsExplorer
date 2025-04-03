%%%%
% Context maps:  Soil carbon debt


[long,lat,raster]=processgeotiff('inputdatafiles/SOCS_0_200cm_year_2010AD_10km.tif');
[long,lat,raster0]=processgeotiff('inputdatafiles/SOCS_0_200cm_year_NoLU_10km.tif');


raster(raster==-32767)=nan;
raster0(raster0==-32767)=nan;


NSS=getDrawdownNSS
NSS.units='tons CO_2-eq/ha';
NSS.title='Soil Carbon Debt';
NSS.DisplayNotes={'Sanderman et al, PNAS 2017'}
NSS.caxis=[0 400];

DataToDrawdownFigures((raster0-raster)*3.67,NSS,'Context_SoilCarbonDebt','ImproveAnnualCropping');

%% land in conservation agriculture - first version (Prestele):
[croplandraster,pastureraster]=get2015croppasturearea;


b=dlmread('inputdatafiles/CA_data_package/alloc_CA_base_ha.asc',' ',6,0);
whos b
b(b<0)=nan;
BaselineCAEstimate(1:4320,:)=b(:,1:4320)'./fma;;


NSS=getDrawdownNSS;
NSS.Title=['Land in Improved Annual Cropping'];
NSS.Units=['fraction of landscape'];
NSS.cmap=ExplorerAdoption1;
NSS.caxis=[0 1];
NSS.logicalinclude=croplandraster>0.2;
NSS.DisplayNotes={'Data from Prestele et al'};
DataToDrawdownFigures(BaselineCAEstimate,NSS,'CurrentAdoptionPrestele','ImproveAnnualCropping');

DataToDrawdownFigures(croplandraster,'','CroplandRaster_AuxiliaryData','ImproveAnnualCropping');

%% land in conservation agriculture - second version (Kassam)
a=readgenericcsv('inputdatafiles/KassamData.csv');
clear DS
CAarea=datablank;
CAareafraction=datablank;
totalareamap=datablank;
for j=1:numel(a.Num);
    %CA(j)
    tmp=str2num(strrep(strrep(strrep(a.CAArea2018{j},'+',''),'#',''),'"',''));


    x8=str2num(strrep(strrep(strrep(a.CAArea2008{j},'+',''),'#',''),'"',''));
    x13=str2num(strrep(strrep(strrep(strrep(a.CAArea2013{j},'+',''),'#',''),'"',''),'*',''));
    x15=str2num(strrep(strrep(strrep(a.CAArea2015{j},'+',''),'#',''),'"',''));
    x18=str2num(strrep(strrep(strrep(a.CAArea2018{j},'+',''),'#',''),'"',''));

if isequal(a.CAArea2008{j},'-')
    x8=nan;
end
if isequal(a.CAArea2013{j},'-')
    x13=nan;
end
if isequal(a.CAArea2015{j},'-')
    x15=nan;
end
if isempty(x8)
    x8=nan;
end
if isempty(x13)
    x13=nan;
end
if isempty(x15)
    x15=nan;
end

% linear extrapolation
y=ones(1,11)*nan;
y(1)=x8;
y(6)=x13;
y(8)=x15;
y(11)=x18;
[x0,x1,Rsq,p,sig,SSE,linfit]=VectorizedLinearRegressionnan(y.');

CA2025=x0+x1*17;

% now catch the cases where only last data column non-empty
if isnan(CA2025) & isfinite(x18)
    CA2025=x18;
end
CA2025=max(CA2025,0);



    if numel(tmp)==0;
        a.Name{j}
        a.CAArea2018{j}
        CA(j)=0;
        keyboard
    else
        CA(j)=CA2025;
    end
    switch a.Name{j}
        case 'USA'
            output=standardcountrynames('United States')
        case 'Slovakia'
            output.GADM_ISO='SVK';
        case 'Korea DPR '
            output.GADM_ISO='PRK';
        case 'Luxemburg'
            output.GADM_ISO='LUX';
        case 'Timor Leste'
            output.GADM_ISO='TLS';
        case 'DR Congo'
            output.GADM_ISO='COD';
        otherwise
            output=standardcountrynames(a.Name{j})
    end
    if isempty(output.GADM_ISO)
        a.Name{j}
        keyboard
    else
        [~,~,ii]=MinxCountriesList(output.GADM_ISO);
    end


totalarea=nansum(croplandraster(ii).*fma(ii));

    CAarea(ii)=CA(j)*1000;
    CAareafraction(ii)=CA(j)*1000/totalarea;
    totalareamap(ii)=totalarea;


    DS(j).GADM=output.GADM_ISO;
    DS(j).ConservationAgricultureArea=CA(j)*1000;
    DS(j).TotalCroplandArea=totalarea;

end
%%
NSS=getDrawdownNSS;
NSS.Title=['Land in Improved Annual Cropping'];
NSS.Units=['Mha'];
NSS.cmap=ExplorerAdoption1;
NSS.DisplayNotes={'Data from Kassam et al, 2022'};
DataToDrawdownFigures(CAarea,NSS,'CurrentAdoptionKassam','ImproveAnnualCropping');


%%
NSS=getDrawdownNSS;
NSS.Title=['Percent Land in Improved Annual Cropping'];
NSS.Units=['%'];
NSS.cmap=ExplorerAdoption1;
NSS.caxis=[0 100]
NSS.DisplayNotes={'Data from Kassam et al, 2022'};
DataToDrawdownFigures(CAareafraction*100,NSS,'CurrentAdoptionKassamFraction','ImproveAnnualCropping');



%% impact
% 1.80 t CO2-eq/ha/yr
currentimpact=CAarea.*1.80/1000;

%%
NSS=getDrawdownNSS;
NSS.Title=['Impact of adoption of Improved Annual Cropping'];
NSS.Units=['Mt CO_2-eq/yr'];
NSS.cmap=ExplorerImpact1;
NSS.DisplayNotes={'Data from Kassam et al, 2022'};
DataToDrawdownFigures(currentimpact,NSS,'CurrentImpact','ImproveAnnualCropping');


%lowambitionimpact=min(CAarea,totaareamap*.*1.80;
