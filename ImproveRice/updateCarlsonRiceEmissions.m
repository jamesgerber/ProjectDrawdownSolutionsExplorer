% Code to update to CropGrids Area
%
% Note that I'm not storing CropGrids in intermediatedatalayers since I
% shouldn't be sharing that data layer.

% load files from Kim Carlson paper
%load intermediatedatalayers/rice/emissions_current_none_rand_allcrops_mean.mat
load inputdatafiles/emissions_current_none_rand_allcrops_mean.mat


[DS,area,yield]=getcropdata('rice');

area2000=area;

x=load('~/DataProducts/ext/CropGrids/CROPGRIDSv1.08_NC_maps/ncmat/CROPGRIDSv1.08_rice.mat');

a=x.Svector(3).Data;

a(a<0)=0;
a=double(a);

a=disaggregate_quantity(a,3);
a=aggregate_quantity(a,5,'sum');

a=a(:,end:-1:1);

a=a./fma;

max(a(:))

ii=landmasklogical;
sum(a(ii).*fma(ii))
area2020=a;
% note: this area agrees with FAO Area


jj=find(area2000==0 & area2020>0);

Year2000CH4eEmissions=(Data.perharicech4e.*area2000.*fma);
Year2020CH4eEmissions=(Data.perharicech4e.*area2020.*fma);

notes={'I used cropgridsv1.08, re-sampled (disagg 3 agg 5) to'...
    'desired resolution.  then i multipled kims perharicech4e by ' ...
    'that new area'};
notes2={'area2020 is all rice, not just paddy rice'}

save intermediatedata/rice/Year2020RiceCH4eEmissions Year2020CH4eEmissions area2020 notes notes2