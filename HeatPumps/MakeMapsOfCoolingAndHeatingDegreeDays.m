

load '/Users/jsgerber/Public/ionedata/Climate/WorldClim21/processeddata/wc21_HDD18'
load '/Users/jsgerber/Public/ionedata/Climate/WorldClim21/processeddata/wc21_CDD24'

MapAndDataFolder='HeatPumpsMapsAndData'

NSS=getDrawdownNSS;

NSS.title='Heating Degree Days (Base temp 18C)';
NSS.cmap='white_purple_red';
%fromQGIS2
NSS.units='^o C - day'
NSS.caxis=[0 15e3]
DataToDrawdownFigures(HDD,NSS,'HeatingDegreeDays',MapAndDataFolder,'');




NSS.title='Cooling Degree Days (Base temp 24C)';
NSS.cmap='dark_blues_deep';
%fromQGIS2
NSS.units='^o C - day'
NSS.caxis=[0 5e3]
    NSS.userinterppreference='tex'

DataToDrawdownFigures(CDD,NSS,'CoolingDegreeDays',MapAndDataFolder,'');



