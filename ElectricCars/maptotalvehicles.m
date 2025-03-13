a=readgenericcsv('OICAExcerpt_PassengerVehicles.csv');


numcarsmap=datablank*nan;
carsperperson=datablank*nan;

for j=1:63;
    [g0,jj]=getgeo41_g0(a.ISO{j});
    numcarsmap(jj)=a.Number_Registered_Vehicles(j);
    carsperperson(jj)=a.Number_Registered_Vehicles(j)/a.Population(j);
    OICAnumcars(j)=a.Number_Registered_Vehicles(j);
end


WHOmap=datablank;
%%
b=readgenericcsv('data-verbose.csv');


for j=1:numel(b.GHO_CODE)

    ISO=b.COUNTRY_CODE{j};
    ISO=strrep(ISO,'"','');
    ISOlist{j}=ISO;
    try
        [g0,jj]=getgeo41_g0(ISO);

        numcars=str2double(strrep(b.Numeric{j},'"',''));
    catch
        disp(['prob for ' ISO ' ' b.COUNTRY_DISPLAY{j}])
    end
    WHOmap(jj)=numcars;

    WHOlist(j)=numcars;

end

%% let's get a scatter plot

ISOboth=intersect(ISOlist,a.ISO);

for j=1:60;

    ISO=ISOboth{j};

    idx=strmatch(ISO,a.ISO);

    OICAvect(j)=OICAnumcars(idx);


    jdx=strmatch(ISO,ISOlist);
    WHOvect(j)=WHOlist(jdx);
end
