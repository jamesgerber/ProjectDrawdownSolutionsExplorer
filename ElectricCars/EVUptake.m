function etaEV=EVUptake(ISO);
% EVUptake - what percentage of fleet is EV?


persistent a ISOlist stockshare
if isempty(a)
    a=readgenericcsv('IEA-EV-dataEV_salesHistoricalCarsnq.txt',1,tab,1);



    counter=0;

    regionlist=unique(a.region);
    for j=1:numel(regionlist);

        region=regionlist{j};
        S=standardcountrynames(region,'NAME_FAO');

        switch region
            case 'USA'
                S=struct;
                S.GADM_ISO='USA';
            case 'Turkiye'
                S=struct;
                S.GADM_ISO='TUR';
        end

        if ~isempty(S.GADM_ISO)
            counter=counter+1;
            ISOlist{counter}=S.GADM_ISO;
            ii=strmatch(region,a.region);
            c=subsetofstructureofvectors(a,ii);
            c=subsetofstructureofvectors(c,c.year==2023);
            stockshare(counter)=pullfromsov(c,'value','parameter','EV stock share');
        end
    end

end

idx=strmatch(ISO,ISOlist);
if numel(idx)==1
    etaEV=stockshare(idx)/100;
else
    etaEV=0;
end

if isnan(etaEV)
    etaEV=0;
end


