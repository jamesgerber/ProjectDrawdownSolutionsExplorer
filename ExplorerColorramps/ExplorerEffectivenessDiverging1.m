function cmap=ExplorerEffectivenessDiverging1;

a={'#5f3514',...
'#733d12',...
'#946542',...
'#b48f74',...
'#d3baaa',...
'#ffffff',...
'#c4d8d8',...
'#9dbfbe',...
'#76a6a5',...
'#4d8c8c',...
'#375c5c'};


tmp=a;
for j=1:numel(tmp);

    hh=tmp{j};
    cmap(j,1)= hex2dec(hh(2:3))/256;
    cmap(j,2)= hex2dec(hh(4:5))/256;
    cmap(j,3)= hex2dec(hh(6:7))/256;

end


cmap=finemap(cmap,'','');