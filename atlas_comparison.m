
roidir='/DATA/236/dywu/HCP1200/prediction_fmri/dti210';

num.chars    = 2;                               % # of characters to consider
roilist      = struct2cell(dir(fullfile(roidir,'*.txt')))';       % list folder content
roilist      = char(roilist(:,1));              % convert to string
roilist(roilist(:,1)=='.',:) = [];              % find hidden folders/files (starting with '.') and delete
num.roilist = size(roilist,1);                 % # of roilists
roilist      = cellstr(roilist);                % make cell array (for convenience)

for i=1:num.roilist
    p210{i}=load(fullfile(roidir,roilist{i}));
end
%%
roidir='/DATA/236/dywu/HCP1200/prediction_fmri/dti380';

num.chars    = 2;                               % # of characters to consider
roilist      = struct2cell(dir(fullfile(roidir,'*.txt')))';       % list folder content
roilist      = char(roilist(:,1));              % convert to string
roilist(roilist(:,1)=='.',:) = [];              % find hidden folders/files (starting with '.') and delete
num.roilist = size(roilist,1);                 % # of roilists
roilist      = cellstr(roilist);                % make cell array (for convenience)

for i=1:num.roilist
    p380{i}=load(fullfile(roidir,roilist{i}));
end

%%
for i=1:num.roilist
    sim(i) = mean(diag(corr(p210{i},p380{i})));
end