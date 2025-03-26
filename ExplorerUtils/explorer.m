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

disp(['try something like this:'])
disp(['ExplorerSolutionPaths ImproveCement'])
disp(' ')
disp(' here are the files in working directory')
ls



