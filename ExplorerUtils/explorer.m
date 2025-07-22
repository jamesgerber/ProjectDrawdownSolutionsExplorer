function explorer(solutiontext)
% orient me in solution explorer workspace, help with paths, etc

% explorer - simple script to print some help, cd, and remind me 
% of of what is going on
   oldwd=pwd;

    switch getenv('USER')
        case 'jsgerber'
            cd('~/DrawdownSolutions/');
        case 'alexsweeney'
            cd('/Users/alexsweeney/Documents/MATLAB/ProjectDrawdownSolutionsExplorer');

        otherwise
            %  cd('~/DrawdownSolutions/');


    end



if nargin==0

 
    disp(['changing dir to ' pwd ', stored old dir in oldwd']);

    % let's propose changing directories to latest

    disp(' ')
    disp(' here are the files in working directory')
    ls

    files = dir();
    files=files(~startsWith({files.name}, '.'));
    [~,idx]=max([files.datenum]);
    disp(['try something like this:'])
    disp(['ExplorerSolutionPaths ' char(files(idx).name)])

else

    a=dir;

    % do any of these solutions work
    for j=1:numel(a)
        idx=findstr(lower(solutiontext),lower(a(j).name));
    
        if numel(idx)>0
            disp(['ExplorerSolutionPaths ' char(a(j).name)]);
            eval(['ExplorerSolutionPaths ' char(a(j).name)]);
            cd(a(j).name);
            pwd
            break
        end

    
    end



end


