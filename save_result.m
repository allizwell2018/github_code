%%
% addpath /home/dywu/loadnii
% template = load_nii('/DATA/239/dywu/HCP_DTI/dti_predict_fmri/fmri/EMOTION/cope1/100307/tstat1.nii');

fmridir = '/DATA/236/dywu/HCP1200/dti_predict_fmri_surf/fmri';
subdir='/DATA/236/dywu/HCP1200/data';
result_path = '/DATA/236/dywu/HCP1200/prediction_fmri/dti-distance210_5k';
mkdir(result_path)

sublist      = struct2cell(dir(subdir))';  % list folder content
sublist      = char(sublist(:,1));              % convert to string
sublist(sublist(:,1)=='.',:) = [];              % find hidden folders/files (starting with '.') and delete
num.sublist = size(sublist,1);                 % # of sublists
sublist      = cellstr(sublist);                % make cell array (for convenience)   
load subperm
sublist = sublist(subperm);

TaskList={ 'EMOTION';'GAMBLING';'LANGUAGE';'MOTOR' ;'RELATIONAL'; 'SOCIAL'; 'WM'} ;
%cope=[1 2 3 6 1 2 9];
%TaskList={'MOTOR'} ;
num.task=length(TaskList);

num.trainall = 80;
num.train = 60;
num.val = num.trainall-num.train;
num.test = num.sublist-num.trainall;
dimension=91282;

for i=1:num.task
    
     copedir=fullfile(fmridir,TaskList{i}); 
     copelist      = struct2cell(dir(copedir))';  % list folder content
     copelist      = char(copelist(:,1));              % convert to string
     copelist(copelist(:,1)=='.',:) = [];              % find hidden folders/files (starting with '.') and delete
     num.copelist = size(copelist,1);                 % # of sublists
     copelist      = cellstr(copelist);                % make cell array (for convenience)   
    
    for m=1:num.copelist
               
%         for k=1:num.test
%             
% %             example = template;
% %             example.img = single(reshape(Ypredicte_all{i}{m}(:,k),91,109,91));
% %             mkdir(fullfile(result_path,TaskList{i},copelist{m},sublist{k+20}))
% %             save_nii(example, fullfile(result_path,TaskList{i},copelist{m},sublist{k+20},'tstat1.nii'));
%               dlmwrite(fullfile(result_path,TaskList{i},copelist{m},sublist{k+num.trainall},'tstat1.txt'),Ypredicte_all{i}{m}(:,k),'delimiter',' ','newline', 'pc','-append')
% 
%         end
          %dlmwrite(fullfile(result_path,[TaskList{i} copelist{m} '_tstat1.txt']),Ytest_all{i}{m},'delimiter',' ','newline', 'pc','-append')
          dlmwrite(fullfile(result_path,[TaskList{i} copelist{m} '_tstat1.txt']),Ypredicte_all{i}{m},'delimiter',' ','newline', 'pc','-append')
    end
end







