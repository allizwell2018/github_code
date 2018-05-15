
% clc
% clear
% load reorganize_task_data_surf_compact.mat
% load restingFunConnData_4merge_surf
% load roimask.mat

clear val pindex feature_index result* 
addpath /home/dywu/libsvm-3.21/matlab
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
%         for k=1:num.test
%             Ytest_all{i}{m}{k}=zeros(dimension,1);
%             Ypredictr_all{i}{m}{k}=zeros(dimension,1);    
%             %Ygroup_all{i}{m}{k}=zeros(dimension,1);
%             surface_mask{k}=0*roimask{1}{1};
%         end
        
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
            %Ygroup_temp = Ygroup(num.train+1 : end);
            %%%Ygroup_temp = repmat(Ygroup(1),1,num.test);
            
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
            %Ygroup = cat(1,Ygroup_temp{:});
            %clear Xrtrain_temp  Xrtest_temp  Ytrain_temp Ytest_temp Ygroup_temp
            
            
%             feature_corr = corr(Ytrain,Xrtrain);
%             [~,feature_index{j}] = sort(feature_corr');
%%            
            Xrtrain_mean = mean(abs(Xrtrain));
            [~,feature_index{i}{m}{j}] = sort(Xrtrain_mean); 
            
            
            plist=[0.6 0.7 0.75 0.8 0.85 0.9 0.95];
            %plist=[0.6 0.7 0.75 0.8 0.85 0.87 0.9 0.92 0.95 0.97];
            %plist=[0.6 0.7 0.73 0.75 0.77 0.8 0.85 0.9 0.95];
            for p = 1:length(plist)
                 feature_temp = feature_index{i}{m}{j}(ceil(length(feature_index{i}{m}{j})*plist(p)):end);
                 Xt = Xrtrain(:,feature_temp);             
                 Xt = [ones(size(Xt,1),1) Xt];
                 kk=length(Ytrain)*num.train/num.trainall;
                 [b,bint,r,rint,stats] = regress(Ytrain(1:kk),Xt(1:kk,:));
                 Yp=Xt(kk+1:end,:)*b;
                 val{i}{m}(j,p)=corr(Ytrain(kk+1:end),Yp);               
            end
            
            [~,pindex{i}{m}(j)]=max(val{i}{m}(j,:));  
            feature_index{i}{m}{j} = feature_index{i}{m}{j}(ceil(length(feature_index{i}{m}{j})*plist(pindex{i}{m}(j))):end);
            %%
            
            Xrtrain = Xrtrain(:,feature_index{i}{m}{j});
            Xrtest = Xrtest(:,feature_index{i}{m}{j});
            Xrtrain = [ones(size(Xrtrain,1),1) Xrtrain];
            Xrtest = [ones(size(Xrtest,1),1) Xrtest];
            
            [br,bintr,rr,rintr,statsr] = regress(Ytrain,Xrtrain);
            Ypredictr=Xrtest*br;
            ta{i}{m}(j)=sqrt(statsr(1));
            
            
%             lme = fitlm(Xrtrain,Ytrain,'linear');
%             pv = lme.Coefficients.pValue(2:end);
%             feature_index{j} = pv<0.01;
%             Xrtrain = Xrtrain(:,feature_index{j});
            %a=[ta{1}{1};result{1}{1}(1,:)]
            %be = ridge(Ytrain,Xetrain,10,0); be(1)=[];
            %%
          
%             svmoptions='-s 4 -t 0  -c 0.1 -nu 0.99 -h 0'; 
%             model=svmtrain(Ytrain,Xrtrain,svmoptions);
%             [~,accuracy1,~]=svmpredict(Ytrain,Xrtrain,model);
%             ta{i}{m}(1,j)=sqrt(accuracy1(3));
%             [Ypredictr,accuracy2,~]=svmpredict(Ytest,Xrtest,model);
%             ta{i}{m}(2,j)=sqrt(accuracy2(3));
            %%
                    
            Ytest = reshape(Ytest,[],num.test);             
            Ypredictr = reshape(Ypredictr,[],num.test);
            
            result_temp_resting{i}{m}{j} = corr(Ypredictr,Ytest);
            result_persub{i}{m}{1}(:,j) = diag(result_temp_resting{i}{m}{j});
            %result_persub{i}{m}{2}(:,j) = diag(corr(Ygroup,Ytest));
            
            result{i}{m}(1,j) = mean(result_persub{i}{m}{1}(:,j));     
            %result{i}{m}(2,j) = mean(result_persub{i}{m}{2}(:,j));
            result{i}{m}(2,j) = std(result_persub{i}{m}{1}(:,j));
            %result{i}{m}(4,j) = std(result_persub{i}{m}{2}(:,j));
            result{i}{m}(3,j) = mean(abs(Ytrain(:,1)));
            result{i}{m}(4,j) = mean(Ytrain(:,1));   
            
%             result{i}{m}(5,j) = mean(abs(Ygroup(:,1)));
%             result{i}{m}(6,j) = mean(Ygroup(:,1));          
%             quartile = Ygroup(:,1);
%             [~,quartile_index] = sort(abs(Ygroup(:,1)));
%             quartile = quartile(quartile_index);
%             quartile = quartile(ceil(length(quartile)*0.75):end);
%             result{i}{m}(7,j) = mean(abs(quartile));
%             result{i}{m}(8,j) = mean(quartile);
            
            for n = 1:num.test
                Ypredictr_all{i}{m}(roi{1},n) = Ypredictr(:,n);
                Ytest_all{i}{m}(roi{1},n) = Ytest(:,n);
                %Ygroup_all{i}{m}(roi{1},n) = Ygroup(:,n);
            end
                                    
            
        end
        
%         surface_mask = logical(surface_mask);
%         Ypredictr_all{i}{m} = Ypredictr_all{i}{m}(surface_mask,:);
%         %Ygroup_all{i}{m} = Ygroup_all{i}{m}(surface_mask,:);
%         Ytest_all{i}{m} = Ytest_all{i}{m}(surface_mask,:);
        
        result_all_temp_resting{i}{m} = corr(Ypredictr_all{i}{m},Ytest_all{i}{m});
        
        result_all_persub{i}{m}(:,1) = diag(result_all_temp_resting{i}{m});    
        %result_all_persub{i}{m}(:,2) = diag(corr(Ygroup_all{i}{m},Ytest_all{i}{m}));

        
        result_all{i}(1,m) = mean(result_all_persub{i}{m}(:,1));
        %result_all{i}(2,m) = mean(result_all_persub{i}{m}(:,2));
        result_all{i}(3,m) = std(result_all_persub{i}{m}(:,1));
        %result_all{i}(4,m) = std(result_all_persub{i}{m}(:,2));
     
        
    end
end

save result_resting_4merge_task380val2.mat result result_all result_persub ...
     result_all_persub result_temp_resting result_all_temp_resting pindex feature_index
