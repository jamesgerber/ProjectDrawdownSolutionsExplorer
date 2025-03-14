function cmap=ExplorerEffectiveness1;

a={'#ffffff','#f8faf6','#e3f1d2','#d7e9c2','#cbe0b2',...
'#b2d2b4','#99c5b6','#80b7b8','#6fa9aa',...
'#4d8c8c'};

tmp=a;
for j=1:numel(tmp);

    hh=tmp{j};
    cmap(j,1)= hex2dec(hh(2:3))/256;
    cmap(j,2)= hex2dec(hh(4:5))/256;
    cmap(j,3)= hex2dec(hh(6:7))/256;

end


cmap=finemap(cmap,'','');