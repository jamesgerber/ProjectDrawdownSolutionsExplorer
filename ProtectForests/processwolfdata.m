%% This is a script I wrote to process the data from Wolf et al
% A forest loss report card for the world’s protected areas
% https://doi.org/10.1038/s41559-021-01389-0
%
%  Some notes:
% This script reads in the datafile that I downloaded (Mar, 2025) from the
% supplemental materials.   I used chatGPT to format something because the
% delimiters were unusual (I think an irregular number of spaces, not tabs)
%
% That is commented out, and I provide the output of the chatGPT code
%
% Wolf doesn't provide complete coverage.  For disputed areas (by which I
% mean gadm.org definitions) I generalized from the main country protection
% rates.
%
% For a few missing countries I averaged over neighboring countries, it's
% there in the code below.

% % % 
% % % 
% % % % This was written by chatGPT
% % % 
% % % % Read the file (assuming it's a text file named 'data.txt')
% % % fid = fopen('wolfdata.txt', 'r');
% % % lines = textscan(fid, '%s', 'Delimiter', '\n');
% % % fclose(fid);
% % % 
% % % % Open a new file for output
% % % fid_out = fopen('output.csv', 'w');
% % % 
% % % % Process each line
% % % for i = 1:length(lines{1})
% % %     line = lines{1}{i};
% % % 
% % %     % Find the first numeric character in the line
% % %     match = regexp(line, '\d', 'once'); 
% % % 
% % %     % Insert a comma after the country name
% % %     if ~isempty(match)
% % %         country_name = strtrim(line(1:match-1)); % Extract country name
% % %         numbers = line(match:end); % Extract numerical part
% % %         numbers = regexprep(numbers, '\s+', ', '); % Replace spaces with commas
% % % 
% % %         formatted_line = [country_name ', ' numbers]; % Reconstruct the line
% % %     else
% % %         formatted_line = line; % Keep unchanged if no numbers found
% % %     end
% % % 
% % %     % Write to the output file
% % %     fprintf(fid_out, '%s\n', formatted_line);
% % % end
% % % 
% % % % Close the output file
% % % fclose(fid_out);
% % % 
% % % %% end of chatGPT-assisted
% % % warning(' now put this in top of file and rename to wolfoutput.csv')
% % % disp('% Country, Species, Prot, Score, ProtxScore, Loss, Carbon, Ispecies, Iloss, Icarbon');
% % % 

a=readgenericcsv('inputdatafiles/wolfoutput.csv');


effectiveness=(1-1./a.Score)*100;

for j=1:numel(effectiveness);

    countryname=a.Country{j};
    switch countryname
        case 'Czechia'
            ISOlist{j}='CZE';
        otherwise
            S=getcountrycode(countryname);;
    
            if isempty(S.GADM_ISO)
                keyboard
            else
                ISOlist{j}=S.GADM_ISO;
            end
    
    end
end

% let's calculate average value for SEAsia

for j=1:11
    ISO=SEAsia11(j);

    idx=strmatch(ISO,ISOlist);
    effectiveness(idx)
end
% 

b=readgenericcsv([iddstring '/WorldBankData/Class2020_EconomiesListnq.txt'],1,tab,1);

for j=1:numel(b.Code);

    ISO=b.Code{j}
    idx=strmatch(ISO,ISOlist);

    if ~isempty(idx)
        longeffectiveness(j)=effectiveness(idx);
    else
        % ok - no effectiveness, replace with regional average.

        region=b.Region{j};

        iiregion=strmatch(region,b.Region);
        regionalISOlist=b.Code(iiregion);

        clear tempvect
        for m=1:numel(regionalISOlist);
            regionalISO=regionalISOlist{m};
            idx=strmatch(regionalISO,ISOlist);
            if isempty(idx)
                tempvect(m)=nan;
            else
                tempvect(m)=effectiveness(idx);
            end
        end

        longeffectiveness(j)=nanmean(tempvect);
    end
end
%% quick CSV

clear NS
NS.code=b.Code;
NS.effectiveness=longeffectiveness;
NS.isSEAsia=double(ismember(b.Code,SEAsia11))
sov2csv(NS,'intermediatedatafiles/WolfProtectionTable.csv');

%% now map
PAeffectivenessmap=datablank;

for j=1:numel(longeffectiveness);
    try
    [g0,ii]=getgeo41_g0(b.Code{j});

    PAeffectivenessmap(ii)=longeffectiveness(j);
    catch
    disp(['prob for ' b.Code{j}])
    end
end

[g0,jj]=getgeo41_g0('IND');

% let's add something for Arunachal Pradesh
[g0,ii]=getgeo41_g0('Z07');
if ~ismember(3195773,ii)
    error(' this doesn''t correspond to Arunachal Pradesh');
end
PAeffectivenessmap(ii)=mean(PAeffectivenessmap(jj));

% let's add something for Jammu and Kashmir
[g0,ii]=getgeo41_g0(108);
if ~ismember(2970948,ii)
    error(' this doesn''t correspond to Jammu and Kashmir');
end


PAeffectivenessmap(ii)=mean(PAeffectivenessmap(jj));


[g0,jj]=getgeo41_g0('PAK');

% let's add something for disputed region; Pakistan
[g0,ii]=getgeo41_g0('Z06');
if ~ismember(2819693,ii)
    error(' something wrong');
end
PAeffectivenessmap(ii)=mean(PAeffectivenessmap(jj));

[g0,jj]=getgeo41_g0('CHN');

% let's add something for disputed regions; China
[g0,ii]=getgeo41_g0('Z02');
PAeffectivenessmap(ii)=mean(PAeffectivenessmap(jj));
[g0,ii]=getgeo41_g0('Z03');
PAeffectivenessmap(ii)=mean(PAeffectivenessmap(jj));
[g0,ii]=getgeo41_g0('Z08');
PAeffectivenessmap(ii)=mean(PAeffectivenessmap(jj));

% ESH - no data in Wolf, average rates for MRT, DZA, MAR
[g0,ii]=getgeo41_g0('ESH');
[g0,ii1]=getgeo41_g0('DZA');
[g0,ii2]=getgeo41_g0('MAR');
[g0,ii3]=getgeo41_g0('MRT');
PAeffectivenessmap(ii)=mean([PAeffectivenessmap(ii1(1)) PAeffectivenessmap(ii1(2)) ]);

% GUF - no data in Wolf, average rates for SUR GUY
[g0,ii]=getgeo41_g0('GUF');
[g0,ii1]=getgeo41_g0('SUR');
[g0,ii2]=getgeo41_g0('GUY');


PAeffectivenessmap(ii)=mean([PAeffectivenessmap(ii1(1)) PAeffectivenessmap(ii1(2)) ]);




notes=[' calculated in ' mfilename ' on ' datestr(now) ' working dir ' pwd]
mkdir intermediatedatafiles/
save intermediatedatafiles/WolfProtectedAreaEffectivenessMap PAeffectivenessmap notes








