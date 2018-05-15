
% clc
% clear
% reorganize_prediction_new
% load reorganize_data.mat

clear task_variation
fmridir = '/DATA/236/dywu/HCP1200/dti_predict_fmri_surf/fmri';
subdir='/DATA/236/dywu/HCP1200/data';
scriptroot='/DATA/235/dywu/HCP1200/script';
roi210dir=fullfile(subdir,'100307','MNINonLinear','ROI_surf210');
roi380dir=fullfile(subdir,'100307','MNINonLinear','ROI_surf380');
roidir=roi210dir;%roi380dir;%

num.chars    = 2;                               % # of characters to consider
roilist      = struct2cell(dir(fullfile(roidir,'*.txt')))';       % list folder content
roilist      = char(roilist(:,1));              % convert to string
roilist(roilist(:,1)=='.',:) = [];              % find hidden folders/files (starting with '.') and delete
num.roilist = size(roilist,1);                 % # of roilists
roilist      = cellstr(roilist);                % make cell array (for convenience)   

sublist      = struct2cell(dir(subdir))';  % list folder content
sublist      = char(sublist(:,1));              % convert to string
sublist(sublist(:,1)=='.',:) = [];              % find hidden folders/files (starting with '.') and delete
num.sublist = size(sublist,1);                 % # of sublists
sublist      = cellstr(sublist);                % make cell array (for convenience)   
load subperm
sublist = sublist(subperm);


TaskList={ 'EMOTION';'GAMBLING';'LANGUAGE';'MOTOR' ;'RELATIONAL'; 'SOCIAL'; 'WM'} ;
%TaskList={'MOTOR'} ;
num.task=length(TaskList);

num.train = 80;
num.test = num.sublist - num.train;

%%
for i=1:num.task
    
     copedir=fullfile(fmridir,TaskList{i}); 
     copelist      = struct2cell(dir(copedir))';  % list folder content
     copelist      = char(copelist(:,1));              % convert to string
     copelist(copelist(:,1)=='.',:) = [];              % find hidden folders/files (starting with '.') and delete
     num.copelist = size(copelist,1);                 % # of sublists
     copelist      = cellstr(copelist);                % make cell array (for convenience)   
    
    for m=1:num.copelist
        
     
        for j=1:num.roilist  
            fprintf('Prediction of %s %s %s\n',TaskList{i},copelist{m},roilist{j})
            
            Y = yt210{i}{m}{j};
            Y = Y(subperm(1:num.train));
            
            Yall = cat(1,Y{:});

            Yall = reshape(Yall,[],num.train);        
            
            corrt=corr(Yall); corrt=triu(corrt,1);
            task_variation{i}{m}(j) = 1-mean(corrt(corrt~=0)); 
            
        end
%        
    end
end

save result_task_variation210.mat task_variation