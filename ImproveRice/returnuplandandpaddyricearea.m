function [paddyricearea,uplandricearea,area2020]=returnuplandandpaddyricearea;
% get paddy and upland rice areas
% based on Cropgrids v1.08 and Caiyu et al (in prep)

x=load('~/DataProducts/ext/CropGrids/CROPGRIDSv1.08_NC_maps/ncmat/CROPGRIDSv1.08_rice.mat');

a=x.Svector(3).Data;

a(a<0)=0;
a=double(a);

a=disaggregate_quantity(a,3);
a=aggregate_quantity(a,5,'sum');

a=a(:,end:-1:1);

a=a./fma;
max(a(:))

%ii=landmasklogical;
%sum(a(ii).*fma(ii))
area2020=a;



irrCF =processgeotiff('~/SEAsiaProject/CaoPreprint/Input_data/Rice/global_irrigated_CF_rice_area_ha.tif');
irrMD =processgeotiff('~/SEAsiaProject/CaoPreprint/Input_data/Rice/global_irrigated_MD_rice_area_ha.tif');
irrSD =processgeotiff('~/SEAsiaProject/CaoPreprint/Input_data/Rice/global_irrigated_SD_rice_area_ha.tif');
rfDP =processgeotiff('~/SEAsiaProject/CaoPreprint/Input_data/Rice/global_rainfed_DP_rice_area_ha.tif');
rfDW =processgeotiff('~/SEAsiaProject/CaoPreprint/Input_data/Rice/global_rainfed_DW_rice_area_ha.tif');
rfRR =processgeotiff('~/SEAsiaProject/CaoPreprint/Input_data/Rice/global_rainfed_RR_rice_area_ha.tif');
rfUP =processgeotiff('~/SEAsiaProject/CaoPreprint/Input_data/Rice/global_rainfed_UP_rice_area_ha.tif');



% allocated this way following Carlson et al (not directly, but using that
% approach to allocating according to the Methane Emissions factors)
% since IPCC has Drought Prone wiht a low scaling factor (See Table 2 of
% "CH4 from Rice Agriculture" 
 FloodedRice=(irrSD+irrMD+irrCF+rfDW+rfRR);
 UplandRice=(rfUP+rfDP);


fr=FloodedRice;
up=UplandRice;
paddyricearea=area2020.*fr./(fr+up);
uplandricearea=area2020.*up./(fr+up);
paddyricearea(isnan(paddyricearea))=0;
uplandricearea(isnan(uplandricearea))=0;
