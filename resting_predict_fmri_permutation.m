
% clc
% clear
% load reorganize_task_data_surf_compact.mat
% load restingFunConnData_4merge_surf
% load roimask.mat

load result_resting_4merge_task380val.mat feature_index
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
        Ypredictr_all{i}{m}=zeros(dimension,num.test);
        %Ygroup_all{i}{m}=zeros(dimension,num.test);
        surface_mask=0*roimask380{1}{1};     
        
        for j=1:num.roilist  
            
            fprintf('Prediction of %s %s %s\n',TaskList{i},copelist{m},roilist{j})
            Xr = xr380{j};
            Y = yt380{i}{m}{j};
            %Ygroup = ygroup{i}{m}{j};
            %%%Ygroup = y{i}{m}{j};
            roi = roimask380{j};
            surface_mask = surface_mask+roi{1};
                        
            Xrtrain_temp = Xr(subperm(1:num.trainall));         
            Ytrain_temp = Y(subperm(1:num.trainall));
            Xrtest_temp = Xr(subperm(num.trainall+1 : end));
            Ytest_temp = Y(subperm(num.trainall+1 : end));
            
            
            Xrtrain = cat(1,Xrtrain_temp{:});
            %Xrtrain(:,j) = 1; %streamlines;
 
            %Ytrain_stan = cat(2,Ytrain_temp{:});
            %Ytrain_stan = (Ytrain_stan - repmat(mean(Ytrain_stan),size(Ytrain_stan,1),1)).\(repmat(std(Ytrain_stan),size(Ytrain_stan,1),1));
            %Ytrain = Ytrain_stan(:);
            Ytrain = cat(1,Ytrain_temp{:});
            %Ytrain = (Ytrain-mean(Ytrain))/std(Ytrain);
            Xrtest = cat(1,Xrtest_temp{:});
            %Xrtest(:,j) = 1; %streamlines;
            
            %Ytest_stan = cat(2,Ytest_temp{:});
            %Ytest_stan = (Ytest_stan - repmat(mean(Ytest_stan),size(Ytest_stan,1),1)).\(repmat(std(Ytest_stan),size(Ytest_stan,1),1));
            %Ytest = Ytest_stan(:);
            Ytest = cat(1,Ytest_temp{:});
            %Ytest = (Ytest-mean(Ytest))/std(Ytest);
            
            %clear Xrtrain_temp  Xrtest_temp  Ytrain_temp Ytest_temp Ygroup_temp
            
            %%

             Xrtrain = Xrtrain(:,feature_index{i}{m}{j});
            Xrtest = Xrtest(:,feature_index{i}{m}{j});
            
            Xrtrain = [ones(size(Xrtrain,1),1) Xrtrain];
            Xrtest = [ones(size(Xrtest,1),1) Xrtest];
            
            %%%%%%%%
            for p=1:100
                Ytrain = Ytrain(randperm(length(Ytrain)));
                [br,bintr,rr,rintr,statsr] = regress(Ytrain,Xrtrain);
                 Ypredictr=Xrtest*br;

                Ytest = reshape(Ytest,[],num.test);             
                Ypredictr = reshape(Ypredictr,[],num.test);

                result_temp_resting{i}{m}{j} = corr(Ypredictr,Ytest);
                result_persub_permutation{p}{i}{m}{1}(:,j) = diag(result_temp_resting{i}{m}{j});
                %result_persub{i}{m}{2}(:,j) = diag(corr(Ygroup,Ytest));

                result_permutation{p}{i}{m}(1,j) = mean(result_persub_permutation{p}{i}{m}{1}(:,j));     
                %result{i}{m}(2,j) = mean(result_persub{i}{m}{2}(:,j));
                result_permutation{p}{i}{m}(2,j) = std(result_persub_permutation{p}{i}{m}{1}(:,j));
                %result{i}{m}(4,j) = std(result_persub{i}{m}{2}(:,j));
                                    
            
            end 
        end  
        
    end
end

save result_resting_4merge_task_permutation380.mat result_permutation  result_persub_permutation 
