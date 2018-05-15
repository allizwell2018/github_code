
% clc
% clear
% load reorganize_task_data_surf_compact.mat
% load reorganize_dti_data_surf.mat
% load roimask.mat

load result_dti_task380val.mat feature_index
fmridir = '/DATA/236/dywu/HCP1200/dti_predict_fmri_surf/fmri';
subdir='/DATA/236/dywu/HCP1200/data';
scriptroot='/DATA/235/dywu/HCP1200/script';
roi210dir=fullfile(subdir,'100307','MNINonLinear','ROI_surf210');
roi380dir=fullfile(subdir,'100307','MNINonLinear','ROI_surf380');
roidir=roi380dir;

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

num.trainall = 80;
num.train = 60;
num.val = num.trainall-num.train;
num.test = num.sublist-num.trainall;
streamlines = 100;
dimension=91282;
%%
for i=1:num.task
    
     copedir=fullfile(fmridir,TaskList{i}); 
     copelist      = struct2cell(dir(copedir))';  % list folder content
     copelist      = char(copelist(:,1));              % convert to string
     copelist(copelist(:,1)=='.',:) = [];              % find hidden folders/files (starting with '.') and delete
     num.copelist = size(copelist,1);                 % # of sublists
     copelist      = cellstr(copelist);                % make cell array (for convenience)   
    
    for m=1:num.copelist
        
        Ytest_all{i}{m}=zeros(dimension,num.test);
        Ypredicte_all{i}{m}=zeros(dimension,num.test);
        %Ygroup_all{i}{m}=zeros(dimension,num.test);
        surface_mask=0*roimask380{1}{1};
        for j=1:num.roilist 
            
            fprintf('Prediction of %s %s %s\n',TaskList{i},copelist{m},roilist{j})
            Xe = xe380{j};
            Xl = xl380{j};
            Y = yt380{i}{m}{j};
            %Y = yz{i}{m}{j};
            %Ygroup = ygroup{i}{m}{j};
            roi = roimask380{j};
            surface_mask = surface_mask+roi{1};
            
            Xetrain_temp = Xe(subperm(1:num.trainall));
            Xltrain_temp = Xl(subperm(1:num.trainall));
            Ytrain_temp = Y(subperm(1:num.trainall));
            Xetest_temp = Xe(subperm(num.trainall+1 : end));
            Xltest_temp = Xl(subperm(num.trainall+1 : end));
            Ytest_temp = Y(subperm(num.trainall+1 : end));
            
            Xetrain = cat(1,Xetrain_temp{:});
            Xetrain(:,j) = streamlines;
            Xetrain = Xetrain/streamlines;
            Xltrain = cat(1,Xltrain_temp{:});
%             Ytrain_stan = cat(2,Ytrain_temp{:});
%             Ytrain_stan = (Ytrain_stan - repmat(mean(Ytrain_stan),size(Ytrain_stan,1),1))./(repmat(std(Ytrain_stan),size(Ytrain_stan,1),1));
%             Ytrain = Ytrain_stan(:);
            Ytrain = cat(1,Ytrain_temp{:});
            %Ytrain = Ytrain_temp(:);
            %Ytrain = (Ytrain-mean(Ytrain))/std(Ytrain);
            Xetest = cat(1,Xetest_temp{:});
            Xetest(:,j) = streamlines;
            Xetest = Xetest/streamlines;
            Xltest = cat(1,Xltest_temp{:});
%             Ytest_stan = cat(2,Ytest_temp{:});
%             Ytest_stan = (Ytest_stan - repmat(mean(Ytest_stan),size(Ytest_stan,1),1))./(repmat(std(Ytest_stan),size(Ytest_stan,1),1));
%             Ytest = Ytest_stan(:);
            Ytest = cat(1,Ytest_temp{:});
            
            clear Xetrain_temp Xitrain_temp Xetest_temp Xitest_temp Ytrain_temp Ytest_temp Ygroup_temp Ytrain_stan Ytest_stan Ygroup_stan
            
           %%
            Xetrain = Xetrain(:,feature_index{i}{m}{j});
            Xetest = Xetest(:,feature_index{i}{m}{j});          
           
                
            %%%%%%%%
            for p=1:100
                Ytrain = Ytrain(randperm(length(Ytrain)));
                [be,binte,re,rinte,statse] = regress(Ytrain,Xetrain);

                Ypredicte=Xetest*be;

                Ytest = reshape(Ytest,[],num.test);             
                Ypredicte = reshape(Ypredicte,[],num.test);

                result_temp_dti{i}{m}{j} = corr(Ypredicte,Ytest);
                result_persub_permutation{p}{i}{m}{1}(:,j) = diag(result_temp_dti{i}{m}{j});    

                result_permutation{p}{i}{m}(1,j) = mean(result_persub_permutation{p}{i}{m}{1}(:,j));   

                result_permutation{p}{i}{m}(2,j) = std(result_persub_permutation{p}{i}{m}{1}(:,j));
                
                                   
          
            
            end   
        end
    end
end

save result_dti_task_permutation380.mat result_permutation  result_persub_permutation 