function gtapgeostruct=getgtapgeostruct;
% gtapgeostruct.actualisocodes;
% need to return these
%gtapgeostruct.gtapfuckedupcodes;
%gtapgeostruct.actualisocodes;
 g=readgenericcsv('inputdatafiles/GTAPtoISO.csv');
 gg.gtapbizarrocodes=g.REG_V81;
 gg.actualisocodes=g.ISO;


gtapgeostruct=gg;


for j=1:numel(gg.actualisocodes)

gtapgeostruct.actualisocodes{j}=char(gg.actualisocodes(j));
gtapgeostruct.gtapbizarrocodes{j}=char(gg.gtapbizarrocodes(j));
end
% 
% 

