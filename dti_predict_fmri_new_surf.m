
% clc
% clear
% load reorganize_task_data_surf.mat
% load reorganize_dti_data_surf.mat
% load roimask.mat

fmridir = '/DATA/236/dywu/HCP1200/dti_predict_fmri_surf/fmri';
subdir='/DATA/236/dywu/HCP1200/data';
scriptroot='/DATA/235/dywu/HCP1200/script';
roi210dir=fullfile(subdir,'100307','MNINonLinear','ROI_surf210');

roidir=roi210dir;

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

TaskList={ 'EMOTION';'GAMBLING';'LANGUAGE';'MOTOR' ;'RELATIONAL'; 'SOCIAL'; 'WM'} ;
%TaskList={ 'EMOTION';'GAMBLING';'LANGUAGE';'RELATIONAL'; 'SOCIAL'; 'WM'} ;
%TaskList={'MOTOR'} ;
num.task=length(TaskList);

num.trainall = 80;
num.train = 60;
num.val = num.trainall-num.train;
num.test = num.sublist-num.trainall;
streamlines = 5000;
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
        surface_mask=0*roimask210{1}{1};
        for j=1:num.roilist  
         
            fprintf('Prediction of %s %s %s\n',TaskList{i},copelist{m},roilist{j})
            Xe = xe210{j};
            Xl = xl210{j};
            Y = yt210{i}{m}{j};
            %Y = yz{i}{m}{j};
            %Ygroup = ygroup{i}{m}{j};
            roi = roimask210{j};
            surface_mask = surface_mask+roi{1};
            
%             for k=1:40
%                 sumc=mean(Xe{k},1);
%                 sumr=mean(Xe{k},2);
%                 sumall=repmat(sumc,size(Xe{k},1),1)+repmat(sumr,1,size(Xe{k},2));
%                 Xe{k}=Xe{k}./sumall;
%             end
            
            Xetrain_temp = Xe(subperm(1:num.trainall));
            Xltrain_temp = Xl(subperm(1:num.trainall));
            Ytrain_temp = Y(subperm(1:num.trainall));
            Xetest_temp = Xe(subperm(num.trainall+1 : end));
            Xltest_temp = Xl(subperm(num.trainall+1 : end));
            Ytest_temp = Y(subperm(num.trainall+1 : end));
            %Ygroup_temp = Ygroup(:,num.train+1 : end);
            
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
            %Ytest = Ytest_temp(:);
            %Ytest = (Ytest-mean(Ytest))/std(Ytest);
%             Ygroup_stan = cat(2,Ygroup_temp{:});
%             Ygroup_stan = (Ygroup_stan - repmat(mean(Ygroup_stan),size(Ygroup_stan,1),1))./(repmat(std(Ygroup_stan),size(Ygroup_stan,1),1));
%             Ygroup = Ygroup_stan(:);

            %Ygroup = cat(1,Ygroup_temp{:});
            %Ygroup = Ygroup_temp(:);
            clear Xetrain_temp Xitrain_temp Xetest_temp Xitest_temp Ytrain_temp Ytest_temp Ygroup_temp Ytrain_stan Ytest_stan Ygroup_stan
            
            Xetrain_mean = mean(Xetrain);
            [~,feature_index{j}] = sort(Xetrain_mean);           
            feature_index{j} = feature_index{j}(ceil(length(feature_index{j})*0.90):end);
            %feature_index{j} = find(Xetrain_mean > 10);
            
            Xetrain = (Xetrain - repmat(mean(Xetrain),size(Xetrain,1),1))./(repmat((std(Xetrain)+1e-9),size(Xetrain,1),1));
            Xetest = (Xetest - repmat(mean(Xetrain),size(Xetest,1),1))./(repmat((std(Xetrain)+1e-9),size(Xetest,1),1));
            Xetrain(:,j) = 1; Xetest(:,j) = 1;
            
            Xetrain = Xetrain(:,feature_index{j});
            
            
            Xetest = Xetest(:,feature_index{j});
            
            
            Xltrain = Xltrain(:,feature_index{j});
            Xltest = Xltest(:,feature_index{j});
%             Xltrain = [ ones(size(Xltrain,1),1)  Xltrain];
%             Xltest = [ ones(size(Xltest,1),1)  Xltest];


            %%
            
            [be,binte,re,rinte,statse] = regress(Ytrain,Xetrain);
            Ypredicte=Xetest*be;
            ta{i}{m}(j)=sqrt(statse(1));
            
%             [be,binte,re,rinte,statse] = regress(Ytrain,Xltrain);
%             Ypredicte=Xltest*be;
            
            %be = ridge(Ytrain,Xetrain,30,0); be(1)=[];
            %lme{i} = fitlm(Xetrain,Ytrain,'linear');
 
            
            
            
            Ytest = reshape(Ytest,[],num.test);             
            Ypredicte = reshape(Ypredicte,[],num.test);
            %Ygroup = reshape(Ygroup,[],num.test);
%             Ytrain = reshape(Ytrain,[],num.train);
%             Yfite = reshape(Yfite,[],num.train);
%             Yfiti = reshape(Yfiti,[],num.train);
%             Yfitei = reshape(Yfitei,[],num.train);
            
%             result{i}{m}(1,j) = corr(Yfite,Ytrain);
%             result{i}{m}(2,j) = mean(abs(Yfite-Ytrain)); 
%             result{i}{m}(4,j) = mean(abs(Ypredicte-Ytest));        
%             result{i}{m}(5,j) = corr(Yfiti,Ytrain);
%             result{i}{m}(6,j) = mean(abs(Yfiti-Ytrain));
%             result{i}{m}(8,j) = mean(abs(Ypredicti-Ytest));          
%             result{i}{m}(9,j) = corr(Yfitei,Ytrain);
%             result{i}{m}(10,j) = mean(abs(Yfitei-Ytrain));
%             result{i}{m}(12,j) = mean(abs(Ypredictei-Ytest));

            result_temp_dti{i}{m}{j} = corr(Ypredicte,Ytest);
            result_persub{i}{m}{1}(:,j) = diag(result_temp_dti{i}{m}{j});     
            %result_persub{i}{m}{2}(:,j) = diag(corr(Ygroup,Ytest));
     
            
            result{i}{m}(1,j) = mean(result_persub{i}{m}{1}(:,j));% 1/num.test*trace(corr(Ypredicte,Ytest));      
            %result{i}{m}(2,j) = mean(result_persub{i}{m}{2}(:,j));% 1/num.test*trace(corr(Ypredicti,Ytest));
            result{i}{m}(2,j) = std(result_persub{i}{m}{1}(:,j));
            %result{i}{m}(8,j) = std(result_persub{i}{m}{2}(:,j));
  
%             result{i}{m}(3,j) = mean(abs(Ygroup(:,1)));
%             result{i}{m}(4,j) = mean(Ygroup(:,1));          
%             quartile = Ygroup(:,1);
%             [~,quartile_index] = sort(abs(Ygroup(:,1)));
%             quartile = quartile(quartile_index);
%             quartile = quartile(ceil(length(quartile)*0.75):end);
%             result{i}{m}(5,j) = mean(abs(quartile));
%             result{i}{m}(6,j) = mean(quartile);
            result{i}{m}(3,j) = mean(abs(Ytrain(:,1)));
            result{i}{m}(4,j) = mean(Ytrain(:,1));   
            
                                   
            for n = 1:num.test
                Ypredicte_all{i}{m}(roi{1},n) = Ypredicte(:,n);
                Ytest_all{i}{m}(roi{1},n) = Ytest(:,n);
                %Ygroup_all{i}{m}(roi{1},n) = Ygroup(:,n);
            end
            

        end
%         surface_mask = logical(surface_mask);
%         Ypredicte_all{i}{m} = Ypredicte_all{i}{m}(surface_mask,:);
%         %Ygroup_all{i}{m} = Ygroup_all{i}{m}(surface_mask,:);
%         Ytest_all{i}{m} = Ytest_all{i}{m}(surface_mask,:);
        
        result_all_temp_dti{i}{m} = corr(Ypredicte_all{i}{m},Ytest_all{i}{m});
        
        result_all_persub{i}{m}(:,1) = diag(result_all_temp_dti{i}{m});    
        %result_all_persub{i}{m}(:,2) = diag(corr(Ygroup_all{i}{m},Ytest_all{i}{m}));
        
        result_all{i}(1,m) = mean(result_all_persub{i}{m}(:,1));% 1/num.test*trace(corr(Ypredicte_all{i}{m},Ytest_all{i}{m}));
        %result_all{i}(2,m) = mean(result_all_persub{i}{m}(:,2));% 1/num.test*trace(corr(Ygroup_all{i}{m},Ytest_all{i}{m}));
        result_all{i}(3,m) = std(result_all_persub{i}{m}(:,1));
        %result_all{i}(4,m) = std(result_all_persub{i}{m}(:,2));        
        
    end
end

%save result_dti_task210.mat result result_all result_persub result_all_persub result_temp_dti result_all_temp_dti