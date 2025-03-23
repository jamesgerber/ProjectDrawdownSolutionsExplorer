function importGCCAData(inputfilename,outputfilename)
% importGCCAData - process data from the GCCA spreadsheet
%
% % basedir= ['/Users/jsgerber/sandbox/jsg216_MappingIndividua' ...
%    'lSolutions/Sol42_ImproveCementProduction/']

%DradwdownNGOGNR2022S9 = importGCCA([basedir '/Dradwdown_NGO_GNR_2022.xlsx'], "Canada", [12, Inf]);


c=0;
for jsheet=3:24
    D = importGCCA(inputfilename, jsheet, [14, Inf]);


    Region=char(D.Region(1))

    x=cellstr(D.Region);
    y=D.Year;
    z=D.Value;
    zz=D.VarName4;
    zzz=D.VarName5;

%%
    c=c+1;

    ii=strmatch('92AGW ',x);

    % now grab next 23 rows
    jj=ii+(1:27);
    Reg=x(jj);
    Year=y(jj);
    Value=z(jj);
    VarName4=zz(jj);
    VarName5=zzz(jj);

    maxyear=max(Year);
    kk=find(maxyear==Year);
    if isempty(kk)
        keyboard
    end

    DS(c).Region=Region;
    DS(c).Year=Year(kk);
    DS(c).Value=Value(kk);
    DS(c).Value2=VarName4(kk);
    DS(c).Value3=VarName5(kk);
    DS(c).TableKey=x(ii);
%%


    % % c=c+1
    % % ii=strmatch('92AGWce',x)
    % % % now grab next 23 rows
    % % jj=ii+(1:27);
    % % 
    % % 
    % % % make sure jj doesn't exceed number of rows
    % % mm=find(jj<=size(D,1));
    % % jj=jj(mm)
    % % 
    % % Reg=x(jj);
    % % Year=y(jj);
    % % Value=z(jj);
    % % 
    % % maxyear=max(Year)
    % % kk=find(maxyear==Year)
    % % if isempty(kk)
    % %     keyboard
    % % end
    % % 
    % % DS(c).Region=Region;
    % % DS(c).Year=Year(kk);
    % % DS(c).Value=Value(kk);
    % % DS(c).Value2=VarName4(kk)
    % % DS(c).Value3=VarName5(kk)
    % % DS(c).TableKey=x(ii);

%%
    c=c+1;

    ii=strmatch('21TGWcm ',x);

     % now grab next 23 rows
    jj=ii+(1:27);
    Reg=x(jj);
    Year=y(jj);
    Value=z(jj);
    VarName4=zz(jj);
    VarName5=zzz(jj);

    maxyear=max(Year);
    kk=find(maxyear==Year);
    if isempty(kk)
        keyboard
    end

    DS(c).Region=Region;
    DS(c).Year=Year(kk);
    DS(c).Value=Value(kk);
    DS(c).Value2=VarName4(kk);
    DS(c).Value3=VarName5(kk);
    DS(c).TableKey=x(ii);

%%
    c=c+1;

    ii=strmatch('59cTGW ',x);

     % now grab next 23 rows
    jj=ii+(1:27);
    Reg=x(jj);
    Year=y(jj);
    Value=z(jj);
    VarName4=zz(jj);
    VarName5=zzz(jj);


    maxyear=max(Year);
    kk=find(maxyear==Year);
    if isempty(kk)
        keyboard
    end

    DS(c).Region=Region;
    DS(c).Year=Year(kk);
    DS(c).Value=Value(kk);
    DS(c).Value2=VarName4(kk);
    DS(c).Value3=VarName5(kk);
    DS(c).TableKey=x(ii);

    %%
    c=c+1;

    ii=strmatch('25aTGW ',x);

    % now grab next 23 rows
    jj=ii+(1:27);
    Reg=x(jj);
    Year=y(jj);
    Value=z(jj);
    VarName4=zz(jj);
    VarName5=zzz(jj);


    maxyear=max(Year);
    kk=find(maxyear==Year);
    if isempty(kk)
        keyboard
    end

    DS(c).Region=Region;
    DS(c).Year=Year(kk);
    DS(c).Value=Value(kk);
    DS(c).Value2=VarName4(kk);
    DS(c).Value3=VarName5(kk);
    DS(c).TableKey=x(ii);
   %%
    c=c+1;

    ii=strmatch('25aAG ',x);

    % now grab next 23 rows
    jj=ii+(1:27);
    Reg=x(jj);
    Year=y(jj);
    Value=z(jj);
    VarName4=zz(jj);
    VarName5=zzz(jj);


    maxyear=max(Year);
    kk=find(maxyear==Year);
    if isempty(kk)
        keyboard
    end

    DS(c).Region=Region;
    DS(c).Year=Year(kk);
    DS(c).Value=Value(kk);
    DS(c).Value2=VarName4(kk);
    DS(c).Value3=VarName5(kk);
    DS(c).TableKey=x(ii);


end

sov2csv(vos2sov(DS),outputfilename);
