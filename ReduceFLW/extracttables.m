function losstable=extracttables(SheetName,dash,rangemethod);
%
% extracttables(SheetName,dash,rangemethod);
%
% extracttables("Table S1 – Western Europe",'≤','mean')
% extracttables(1,'≤','mean')
% extracttables("Table S2 – Eastern Europe",'≤','mean')
% extracttables("Table S3 – Western Europe",'≤','mean')
% extracttables(4,'≤','mean')
% extracttables("Table S1 – Western Europe",'≤','mean')
sheetloc='/Users/jsgerber/sandbox/jsg216_MappingIndividualSolutions/Sol24_ReduceFoodLossAndWaste/flwfromgattotables/rawtablesforextraction/GTAP-FLW_Gatto-2024.xlsx';

Raw = importfile(sheetloc, SheetName, [2, Inf]);
fn=fieldnames(Raw);
fn=fn(2:6);
for j=1:5
    UglyList=Raw.(fn{j});

    for m=1:11
        clean=parseUgly(UglyList{m},dash,rangemethod);
        losstable(m,j)=clean;
    end
end





function clean=parseUgly(ugly,dash,rangemethod)

ii=findstr('.',ugly);
if numel(ii)==1
    % easy case
    clean=str2num(ugly(1:(ii+1)));
    
else
    % it's a range.  damn.
    clean1=str2num(ugly(1:(ii(1)+1)));
    clean2=str2num(ugly((ii(2)-2):(ii(2)+1)));

    switch rangemethod
        case 'mean'
            clean=(clean1+clean2)/2;
        case 'min'
            clean=clean1;
        case 'max'
            clean =clean2;
        case 'debug'
            clean=clean2*1000+clean1;
        otherwise
            error('wtf')
    end

end






