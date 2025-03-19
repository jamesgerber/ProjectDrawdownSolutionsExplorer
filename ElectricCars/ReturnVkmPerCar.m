function Distance_vkm=ReturnVkmPerCar(ISO);

persistent pkmperyeartable

if isempty(pkmperyeartable)
    pkmperyeartable=ReturnpkmPerYearPerCountry('inputdatafiles/pkmPerYearPerCountry.xlsx');
end



ISOList=pkmperyeartable.CountryCode;
pkm=pkmperyeartable.DistanceTraveledByCarpkmvehicleyear;

idx=strmatch(ISO,ISOList);

if numel(idx)==1
Distance_pkm=pkm(idx);
else

    Distance_pkm = 18149;

end

if isnan(Distance_pkm)
    Distance_pkm = 18149;

end

Distance_vkm=Distance_pkm/1.5;

return


% how i calculated average distance

tkm=pkmperyeartable.TotalDistanceTraveledByPrivateCarIn2019pkmyear;
pop=pkmperyeartable.Population2020;

ii=isfinite(pkm);

mean(pkm(ii));
% 18865;

median(pkm(ii))
%ans =       18149