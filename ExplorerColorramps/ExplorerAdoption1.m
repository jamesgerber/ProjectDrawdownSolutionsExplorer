function cmap=ExplorerAdoption1;

a={'#ffffff','#eef4e7','#dde9cf','#cddeb8','#bcd3a0','#abc889','#9abd73','#89b35c',...
    '#77a844','#659d2a'};

tmp=a;
for j=1:numel(tmp);

    hh=tmp{j};
    cmap(j,1)= hex2dec(hh(2:3))/256;
    cmap(j,2)= hex2dec(hh(4:5))/256;
    cmap(j,3)= hex2dec(hh(6:7))/256;

end


cmap=finemap(cmap,'','');