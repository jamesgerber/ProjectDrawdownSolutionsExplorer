function cmap=ExplorerImpact1;

a={'#ffffff','#efe9ef','#ddcade','#cbb6cc','#b9a2bb','#a78ea9','#957a98',...
'#836686','#715274','#5f3e63'};

tmp=a;
for j=1:numel(tmp);

    hh=tmp{j};
    cmap(j,1)= hex2dec(hh(2:3))/256;
    cmap(j,2)= hex2dec(hh(4:5))/256;
    cmap(j,3)= hex2dec(hh(6:7))/256;

end


cmap=finemap(cmap,'','');