
addpath /home/dywu/spm12
roibase ='/DATA/236/dywu/HCP1200/data/100307/MNINonLinear/ROI_surf380';
roidir ='/DATA/236/dywu/HCP1200/data/100307/MNINonLinear/ROI_surf380/*.txt';
roidir2 ='/DATA/236/dywu/HCP1200/data/100307/MNINonLinear/ROI_surf380/*.func.gii';


num.chars    = 2;                               % # of characters to consider
roilist      = struct2cell(dir(roidir))';       % list folder content
roilist      = char(roilist(:,1));              % convert to string
roilist(roilist(:,1)=='.',:) = [];              % find hidden folders/files (starting with '.') and delete
num.roilist = size(roilist,1);                 % # of roilists
roilist      = cellstr(roilist);                % make cell array (for convenience)    

num.chars    = 2;                               % # of characters to consider
roilist2      = struct2cell(dir(roidir2))';       % list folder content
roilist2      = char(roilist2(:,1));              % convert to string
roilist2(roilist2(:,1)=='.',:) = [];              % find hidden folders/files (starting with '.') and delete
num.roilist2 = size(roilist2,1);                 % # of roilists
roilist2      = cellstr(roilist2);                % make cell array (for convenience)  

for i=1:num.roilist
    t=load(fullfile(roibase,roilist{i}));
    roi1(:,i)=t;
    
    t=gifti(fullfile(roibase,roilist2{i}));
    roi2(:,i)=t.cdata;
    
end

sum(roi1)==sum(roi2)

sum(sum(roi1))
sum(sum(roi2))





