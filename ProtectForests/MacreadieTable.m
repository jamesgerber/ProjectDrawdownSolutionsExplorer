function [ISOList,CountryNameList,AreaLB,BiomassLB,FiveMinuteIndices,SoilCO2map,MeanRatio]=MacreadieTable;
% MacreadieTable - return table from Macreadie et al
%
%  Also construct a map at 5 minutes of soil carbon under mangroves.

%Potential of blue carbon as a natural climate solution Peter I.
%Macreadie1*, Micheli D. P. Costa1, Trisha B. Atwood3, Daniel A. Friess4,5,
%Jeffrey J. Kelleway6, Hilary Kennedy7, Catherine E. Lovelock2, Oscar
%Serrano8,9 & Carlos M. Duarte10

x=['Andaman and Nicobar    46,839 9.0 Angola 34,496 5.5  26,779 3.7 Anguilla    2 0.0001 Antigua and Barbuda    897 0.02 Aruba    97 0.002 Australia 629,531 115.6  940,941 112.8 Bahamas, The 87,421 16.6  76,367 1.01 Bahrain    73 0.0003 Bangladesh 494,677 91.9  430,607 73.9 Barbados    36 0.002 Belize 90,022 20.8  55,634 1.4 Benin 8,532 1.5  4,729 0.05 Brazil 1,279,860 312.9  1,051,244 97.8 British Virgin Islands    77 0.001 Brunei 16,906 7.5  10,885 2.6 12  Cambodia 59,773 15.8  47,066 5.04 Cameroon 196,179 42.3  199,303 41.6 Cayman Islands 6,216 1.4  7,544 0.2 China 19,271 2.5  15,518 1.3 Colombia 407,479 148.2  205,179 26.6 Comoros    109 0.03 Congo 1,674 3.2  353 0.0004 Costa Rica 49,170 12.9  38,752 4.5 Cuba 493,617 94.4  423,316 12.8 Democratic Rep. of Congo    20,304 1.4 Djibouti    545 0.05 Dominican Republic 22,580 5.4  17,687 0.8 Ecuador 157,841 30.5  131,671 11.6 Egypt    214 0.01 El Salvador 44,394 6.4  33,578 2.5 Equatorial Guinea 25,286 5.9  12,613 2.6 Eritrea 10,188 2.1  5,797 0.3 Europa Island    579 0.1 Fiji 51,515 13.5  100,058 8.3 13  French Guiana 69,244 39.2  79,640 10.3 French Polynesia    1 0.0002 Gabon 159,955 32.5  137,597 33.6 Gambia 57,948 11.5  69,842 2.9 Ghana 13,984 3.1  11,523 0.7 Grenada    208 0.01 Guadeloupe 5,259 1.2  2,979 0.1 Guatemala 22,961 6.8  34,503 4.1 Guinea 202,544 54.6  243,227 14.7 Guinea-Bissau 298,784 67.2  346,015 24.8 Guyana 50,082 12.3  21,976 2.8 Haiti 13,550 2.9  14,504 0.3 Hawaii    706 0.02 Honduras 110,398 15.7  66,502 4.5 Hong Kong    576 0.05 India 401,980 79.7  324,135 13.3 Indonesia 2,969,330 1,039  2,667,356 574.3 Iran 74,797 10.3  12,332 0.3 Ivory Coast 9,583 2.4  1,911 0.2 Jamaica 9,748 2.2  9,143 0.3 14  Japan    785 0.1 Kenya 60,946 12.6  32,373 1.8 Kiribati    17 0.001 Liberia 10,911 3.1  7,465 0.7 Macau    5 0.0005 Madagascar 298,932 58.8  268,686 39.6 Malaysia 702,175 255.8  552,741 95.6 Marshall Islands    1 0.0001 Martinique    1,073 0.06 Mauritania    28 0.001 Mayotte    514 0.08 Mexico 925,421 182.8  689,596 26.4 Micronesia, Federated States of 8,344 3.9  9,733 1.8 Mozambique 521,055 90.9  319,023 23.6 Myanmar 508,225 122.8  472,156 62 New Caledonia 22,150 4.3  23,874 2.2 New Zealand 26,028 2.7  30,968 3.7 Nicaragua 64,908 17.5  72,985 4 Nigeria 732,346 211.8  691,986 66.8 15  Northern Mariana Islands    1 0.0001 Oman    230 0.008 Pakistan 97,626 14.5  53,700 1 Palau 6,987 2  4,025 0.6 Panama 174,370 41.3  152,189 23.7 Papua New Guinea 387,453 140.3  469,983 113.9 Peru 4,891 0.8  4,055 0.2 Philippines 256,214 75.4  252,763 27.9 Puerto Rico 7,328 1.7  7,840 0.2 Qatar    382 0.007 Reunion and Mauritius    32 0.002 Saint Kitts and Nevis    52 0.002 Saint Lucia    138 0.01 Saint Vincent and the Grenadines    40 0.002 Samoa    289 0.04 Saudi Arabia 32,430 5.2  6,599 0.11 Senegal 128,213 25.6  161,316 4.6 Seychelles    1,087 0.1 Sierra Leone 104,805 24.5  156,682 11.7 16  Singapore    567 0.09 Solomon Islands 56,105 23.6  31,396 4.3 Somalia    2,559 0.08 Soudan    323 0.004 South Africa    1,411 0.23 Sri Lanka 8,888 2.1  22,805 0.99 Suriname 50,732 14.1  86,001 6.9 Taiwan    135 0.013 Tanzania 127,179 27.4  94,628 17.2 Thailand 248,309 65.2  243,495 30.7 Timor Leste    36 0.006 Togo    125 0.005 Tonga    771 0.07 Trinidad and Tobago 6,572 1.5  6,313 0.5 Turks And Caicos Islands 11,094 2.2  17,017 0.3 Tuvalu    8 0.001 United Arab Emirates 6,769 0.7  11,805 0.1 United States of America 317,054 49.7  230,140 7.7 Vanuatu    1,358 0.2 Venezuela 341,944 87.2  247,252 45.5 17  Vietnam 101,058 21.5  200,548 17.5 Virgin Islands, US    181 0.009 Wallis and Futuna    14 0.002 Yemen       1,043 0.04 '];

% make a few edits.
%Remove lowerbound for Congo ... crazy large ratio

x=[' Andaman and Nicobar    46,839 9.0 Angola 34,496 5.5  26,779 3.7 Anguilla    2 0.0001 Antigua and Barbuda    897 0.02 Aruba    97 0.002 Australia 629,531 115.6  940,941 112.8 Bahamas, The 87,421 16.6  76,367 1.01 Bahrain    73 0.0003 Bangladesh 494,677 91.9  430,607 73.9 Barbados    36 0.002 Belize 90,022 20.8  55,634 1.4 Benin 8,532 1.5  4,729 0.05 Brazil 1,279,860 312.9  1,051,244 97.8 British Virgin Islands    77 0.001 Brunei 16,906 7.5  10,885 2.6   Cambodia 59,773 15.8  47,066 5.04 Cameroon 196,179 42.3  199,303 41.6 Cayman Islands 6,216 1.4  7,544 0.2 China 19,271 2.5  15,518 1.3 Colombia 407,479 148.2  205,179 26.6 Comoros    109 0.03 Congo 1,674 3.2   Costa Rica 49,170 12.9  38,752 4.5 Cuba 493,617 94.4  423,316 12.8 Democratic Rep of Congo    20,304 1.4 Djibouti    545 0.05 Dominican Republic 22,580 5.4  17,687 0.8 Ecuador 157,841 30.5  131,671 11.6 Egypt    214 0.01 El Salvador 44,394 6.4  33,578 2.5 Equatorial Guinea 25,286 5.9  12,613 2.6 Eritrea 10,188 2.1  5,797 0.3 Europa Island    579 0.1 Fiji 51,515 13.5  100,058 8.3   French Guiana 69,244 39.2  79,640 10.3 French Polynesia    1 0.0002 Gabon 159,955 32.5  137,597 33.6 Gambia 57,948 11.5  69,842 2.9 Ghana 13,984 3.1  11,523 0.7 Grenada    208 0.01 Guadeloupe 5,259 1.2  2,979 0.1 Guatemala 22,961 6.8  34,503 4.1 Guinea 202,544 54.6  243,227 14.7 Guinea-Bissau 298,784 67.2  346,015 24.8 Guyana 50,082 12.3  21,976 2.8 Haiti 13,550 2.9  14,504 0.3 Hawaii    706 0.02 Honduras 110,398 15.7  66,502 4.5 Hong Kong    576 0.05 India 401,980 79.7  324,135 13.3 Indonesia 2,969,330 1,039  2,667,356 574.3 Iran 74,797 10.3  12,332 0.3 Ivory Coast 9,583 2.4  1,911 0.2 Jamaica 9,748 2.2  9,143 0.3  Japan    785 0.1 Kenya 60,946 12.6  32,373 1.8 Kiribati    17 0.001 Liberia 10,911 3.1  7,465 0.7 Macau    5 0.0005 Madagascar 298,932 58.8  268,686 39.6 Malaysia 702,175 255.8  552,741 95.6 Marshall Islands    1 0.0001 Martinique    1,073 0.06 Mauritania    28 0.001 Mayotte    514 0.08 Mexico 925,421 182.8  689,596 26.4 Micronesia, Federated States of 8,344 3.9  9,733 1.8 Mozambique 521,055 90.9  319,023 23.6 Myanmar 508,225 122.8  472,156 62 New Caledonia 22,150 4.3  23,874 2.2 New Zealand 26,028 2.7  30,968 3.7 Nicaragua 64,908 17.5  72,985 4 Nigeria 732,346 211.8  691,986 66.8  Northern Mariana Islands    1 0.0001 Oman    230 0.008 Pakistan 97,626 14.5  53,700 1 Palau 6,987 2  4,025 0.6 Panama 174,370 41.3  152,189 23.7 Papua New Guinea 387,453 140.3  469,983 113.9 Peru 4,891 0.8  4,055 0.2 Philippines 256,214 75.4  252,763 27.9 Puerto Rico 7,328 1.7  7,840 0.2 Qatar    382 0.007 Reunion and Mauritius    32 0.002 Saint Kitts and Nevis    52 0.002 Saint Lucia    138 0.01 Saint Vincent and the Grenadines    40 0.002 Samoa    289 0.04 Saudi Arabia 32,430 5.2  6,599 0.11 Senegal 128,213 25.6  161,316 4.6 Seychelles    1,087 0.1 Sierra Leone 104,805 24.5  156,682 11.7 Singapore    567 0.09 Solomon Islands 56,105 23.6  31,396 4.3 Somalia    2,559 0.08 Soudan    323 0.004 South Africa    1,411 0.23 Sri Lanka 8,888 2.1  22,805 0.99 Suriname 50,732 14.1  86,001 6.9 Taiwan    135 0.013 Tanzania 127,179 27.4  94,628 17.2 Thailand 248,309 65.2  243,495 30.7 Timor Leste    36 0.006 Togo    125 0.005 Tonga    771 0.07 Trinidad and Tobago 6,572 1.5  6,313 0.5 Turks And Caicos Islands 11,094 2.2  17,017 0.3 Tuvalu    8 0.001 United Arab Emirates 6,769 0.7  11,805 0.1 United States of America 317,054 49.7  230,140 7.7 Vanuatu    1,358 0.2 Venezuela 341,944 87.2  247,252 45.5  Vietnam 101,058 21.5  200,548 17.5 Virgin Islands, US    181 0.009 Wallis and Futuna    14 0.002 Yemen 1,043 0.04  Yemen 1,043 0.04 '];


ii=regexp(x,' [A-Z]');
jj=regexp(x,'[0-9]');

c=0;
done=0;
idx=1;

while done==0

    idx;

    c=c+1;

    % find next letter after a number
    iinumber= jj(min(find(jj>idx)));
    iiletter= ii(min(find(ii>iinumber)));

    tableline=x(idx:(iiletter-1));


    tableline=strrep(tableline,',','');

    % are there two or 4 numbers in here?

    iinum=regexp(tableline,'[0-9.]');
    switch length(find(diff(iinum)>1))
        case 1
            NumNums=2;
            ww=str2num(tableline(iinum(1):iinum(end)));

            AreaLB(c)=ww(1);
            BiomassLB(c)=ww(2);

        case 3
            ww=str2num(tableline(iinum(1):iinum(end)));
            NumNums=4;
            AreaUB(c)=ww(1);
            BiomassUB(c)=ww(2);
            AreaLB(c)=ww(3);
            BiomassLB(c)=ww(4);

            MeanRatio(c)=(BiomassUB(c)/AreaUB(c))/(BiomassLB(c)/AreaLB(c) );
    if MeanRatio(c)>1e3
        keyboard
    end
        otherwise
            error
    end

    CountryName{c}=tableline(2:(iinum-1));

    % get ready for next one
    idx=iiletter;



    if c==116
        done=1
    end

end


for j=1:116

    switch deblank(CountryName{j})
        case 'Timor Leste'
            ISOList{j}='TLS';
            [~,FiveMinuteIndices{j}]=getgeo41_g0('TLS');
        case 'Macau'
            ISOList{j}='MAC';
          %  [~,FiveMinuteIndices{j}]=getgeo41_g0('TLS')
                FiveMinuteIndices{j}='';
        case 'Bahamas The'
            ISOList{j}='BHS';
            [~,FiveMinuteIndices{j}]=getgeo41_g0('BHS');
       case 'British Virgin Islands'
            ISOList{j}='VIR';
            [~,FiveMinuteIndices{j}]=getgeo41_g0(ISOList{j});
       case 'Congo'
            ISOList{j}='COG'; % COD = DCR
            [~,FiveMinuteIndices{j}]=getgeo41_g0(ISOList{j});
       case 'Democratic Rep of Congo'
            ISOList{j}='COD'; % COD = DCR
            [~,FiveMinuteIndices{j}]=getgeo41_g0(ISOList{j});
       case 'Ivory Coast'
            ISOList{j}='CIV'; % COD = DCR
            [~,FiveMinuteIndices{j}]=getgeo41_g0(ISOList{j});
       case 'Micronesia Federated States of '
            ISOList{j}='FSM'; % COD = DCR
            [~,FiveMinuteIndices{j}]=getgeo41_g0(ISOList{j});
       case 'Reunion and Mauritius'
            ISOList{j}='MUS'; % COD = DCR
            [~,FiveMinuteIndices{j}]=getgeo41_g0(ISOList{j});

            MauritiusIndices=FiveMinuteIndices{j};
       case 'Soudan'
            ISOList{j}='SDN'; % COD = DCR
            [~,FiveMinuteIndices{j}]=getgeo41_g0(ISOList{j});
       case 'Tanzania'
            ISOList{j}='TZA'; % COD = DCR
            [~,FiveMinuteIndices{j}]=getgeo41_g0(ISOList{j});

        case 'United States of America'
            ISOList{j}='USA'; % COD = DCR
            [~,FiveMinuteIndices{j}]=getgeo41_g0(ISOList{j});


        otherwise

            s=standardcountrynames(CountryName{j});
            if isempty(s.GADM_ISO)
                disp(['prob for ' CountryName{j}])
                FiveMinuteIndices{j}='';
            else
                [~,FiveMinuteIndices{j}]=getgeo41_g0(s.GADM_ISO);
            end
            ISOList{j}=s.GADM_ISO;
    end
end

CountryNameList=CountryName;
SoilCO2map=datablank;
for j=1:116
    ii=FiveMinuteIndices{j};
    SoilCO2map(ii)=(1e6*BiomassLB(j))/AreaLB(j)*3.67;
end

% add some special cases to SoilCO2map

% Hawaii
g1=getgeo41_g1('USA')
iiHI=g1.raster1==3421;
SoilCO2map(iiHI)=1e6*0.02/706*3.67; 

% Reunion
[g0,ii]=getgeo41_g0('REU');
SoilCO2map(ii)=unique(SoilCO2map(MauritiusIndices));

if nargout==0
    ISOList='';
end