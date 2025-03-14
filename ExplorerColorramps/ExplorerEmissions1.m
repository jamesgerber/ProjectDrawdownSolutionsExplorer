function cmap=ExplorerEmissions1;

a={'#ffffff','#ffeae2','#ffd5c5','#ffc1ab','#ffac92',...
    '#ff9677','#ff7e56','#ff623e','#ff4323',...
    '#ff0000'};

tmp=a;
for j=1:numel(tmp);

    hh=tmp{j};
    cmap(j,1)= hex2dec(hh(2:3))/256;
    cmap(j,2)= hex2dec(hh(4:5))/256;
    cmap(j,3)= hex2dec(hh(6:7))/256;

end


cmap=finemap(cmap,'','');