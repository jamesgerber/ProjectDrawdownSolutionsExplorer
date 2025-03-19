function ExplorerSolutionPaths(solution,cleanup);
% ExplorerSolutionPaths add paths for specific solutions + utilities
%
%  example
%      ExplorerSolutionPaths('ElectricCars');
%      ExplorerSolutionPaths('ElectricCars','cleanup');
% 


[a,b,c]=fileparts(which(mfilename));

basepath=strrep(a,'ExplorerUtils','');
% add Explorer Colorramps

addpath([basepath 'ExplorerColorramps/'],'-end');

if nargin==1
    cleanup='';
end

if nargin==0
    ls(basepath)
    return
end



switch solution
    case 'ElectricCars'
        dirname='ElectricCars';
    otherwise
        dirname=solution;
end



if isequal(cleanup,'cleanup');
    rmpath([basepath dirname]);
else
    disp(['adding path for ' solution '.  Here are the codes:'])
    addpath([basepath dirname],'-end');
    ls([basepath dirname]);
end


