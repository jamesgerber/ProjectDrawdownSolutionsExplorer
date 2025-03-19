function Ncars=ReturnNumCars(ISO);
% get Number or cars
%
%  Data source:  OICA
%    International Organization of Motor Vehicle Manufacturers
%  Data downloaded 2024, for year 2020
% Data from solution spreadsheet

persistent a
if isempty(a)
    a=readgenericcsv('OICAExcerpt_PassengerVehicles.csv');
end

idx=strmatch(ISO,a.ISO);

if numel(idx)==0
    Ncars=0;
else
    Ncars=a.Number_Registered_Vehicles(idx);
end

