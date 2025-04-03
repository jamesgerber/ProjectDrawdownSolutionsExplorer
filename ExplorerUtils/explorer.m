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


