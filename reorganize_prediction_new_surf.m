
fmridir = '/DATA/236/dywu/HCP1200/dti_predict_fmri_surf/fmri';
subdir='/DATA/236/dywu/HCP1200/data';
scriptroot='/DATA/235/dywu/HCP1200/script';
roi210dir=fullfile(subdir,'100307','MNINonLinear','ROI_surf210');
roi380dir=fullfile(subdir,'100307','MNINonLinear','ROI_surf380');

load roimask.mat
addpath /DATA/235/dywu/gifti

sublist      = struct2cell(dir(subdir))';  % list folder content
sublist      = char(sublist(:,1));              % convert to string
sublist(sublist(:,1)=='.',:) = [];              % find hidden folders/files (starting with '.') and delete
num.sublist = size(sublist,1);                 % # of sublists
sublist      = cellstr(sublist);                % make cell array (for convenience) 

roi210list      = struct2cell(dir(fullfile(roi210dir,'*.func.gii')))';  % list folder content
roi210list      = char(roi210list(:,1));              % convert to string
roi210list(roi210list(:,1)=='.',:) = [];              % find hidden folders/files (starting with '.') and delete
num.roi210list = size(roi210list,1);                 % # of sublists
roi210list      = cellstr(roi210list);                % make cell array (for convenience) 

roi380list      = struct2cell(dir(fullfile(roi380dir,'*.func.gii')))';  % list folder content
roi380list      = char(roi380list(:,1));              % convert to string
roi380list(roi380list(:,1)=='.',:) = [];              % find hidden folders/files (starting with '.') and delete
num.roi380list = size(roi380list,1);                 % # of sublists
roi380list      = cellstr(roi380list);                % make cell array (for convenience) 



TaskList={ 'EMOTION';'GAMBLING';'LANGUAGE';'MOTOR' ;'RELATIONAL'; 'SOCIAL'; 'WM'} ;
%TaskList={ 'EMOTION';'GAMBLING';'LANGUAGE';'RELATIONAL'; 'SOCIAL'; 'WM'} ;
%TaskList={'MOTOR'} ;
num.task=length(TaskList);

%% reorganize dti

fprintf('reorganize dti\n')
 
for k=1:num.sublist   
    
    fprintf('reorganize dti of %s\n',sublist{k})
    txe_left=load(fullfile(subdir,sublist{k},'T1w/Diffusion.result.surf2.5k.gpu/left/matrix_seeds_to_all_targets'));
    txl_left=load(fullfile(subdir,sublist{k},'T1w/Diffusion.result.surf2.5k.gpu/left/matrix_seeds_to_all_targets_lengths'));
    
    txe_right=load(fullfile(subdir,sublist{k},'T1w/Diffusion.result.surf2.5k.gpu/right/matrix_seeds_to_all_targets'));
    txl_right=load(fullfile(subdir,sublist{k},'T1w/Diffusion.result.surf2.5k.gpu/right/matrix_seeds_to_all_targets_lengths'));
    
    if sum(sum(txe_left))==0 | sum(sum(txe_right))==0
        fprintf('error dti of %s\n',sublist{k})
    end
    
    for j=1:num.roi210list
        t=gifti(fullfile(roi210dir,roi210list{j}));
        roi=logical(t.cdata);
        if mod(j,2)==1
            xe210{j}{k}=txe_left(roi,1:210);
            xl210{j}{k}=txl_left(roi,1:210);
        else
            xe210{j}{k}=txe_right(roi,1:210);
            xl210{j}{k}=txl_right(roi,1:210);
        end
    end
    
    for j=1:num.roi380list
        t=gifti(fullfile(roi380dir,roi380list{j}));
        roi=logical(t.cdata);
        if mod(j,2)==1
            xe380{j}{k}=txe_left(roi,211:end);
            xl380{j}{k}=txl_left(roi,211:end);
        else
            xe380{j}{k}=txe_right(roi,211:end);
            xl380{j}{k}=txl_right(roi,211:end);
        end
        
    end
    
end
save('reorganize_dti_data_surf5k.mat','xe210','xl210','xe380','xl380','-v7.3')

%% reorganize fmri
% 
% for i=1:num.task
%     
%      copedir=fullfile(fmridir,TaskList{i}); 
%      copelist      = struct2cell(dir(copedir))';  % list folder content
%      copelist      = char(copelist(:,1));              % convert to string
%      copelist(copelist(:,1)=='.',:) = [];              % find hidden folders/files (starting with '.') and delete
%      num.copelist = size(copelist,1);                 % # of sublists
%      copelist      = cellstr(copelist);                % make cell array (for convenience)   
%     
%      for m=1:num.copelist
%                        
%         for k=1:num.sublist 
%             fprintf('reorganize fmri of %s %s %s\n',TaskList{i},copelist{m},sublist{k})
%             
%             y1=load(fullfile(fmridir,TaskList{i},copelist{m},sublist{k},'tstat1.txt'));
%             
%             y2=load(fullfile(fmridir,TaskList{i},copelist{m},sublist{k},'zstat1.txt'));
%             
%             for j=1:num.roi210list              
%                 yt210{i}{m}{j}{k} = y1(roimask210{j}{k}); 
%                 %yz210{i}{m}{j}{k} = y2(roimask210{j}{k}); 
%             end
%             
%             for j=1:num.roi380list              
%                 yt380{i}{m}{j}{k} = y1(roimask380{j}{k}); 
%                 %yz380{i}{m}{j}{k} = y2(roimask380{j}{k}); 
%             end      
%             
%         end    
%     end
% end
% %save('reorganize_dti_data_surf.mat','xe210','xl210','xe380','xl380','-v7.3')
% %save('reorganize_task_data_surf.mat','yt210','yz210','yt380','yz380','-v7.3')
% save('reorganize_task_data_surf_compact.mat','yt210','yt380','-v7.3')

