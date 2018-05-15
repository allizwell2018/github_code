%%
%clear

load result_task_variation210
[ task_variation_reshape ] = reshape_cope_compact( task_variation );

load result_dti_task210val5k.mat
[ result_reshape_dti ] = reshape_cope_compact( result );

load result_resting_4merge_task210val.mat
[ result_reshape_resting ] = reshape_cope_compact( result );

load connectivity_variation210

%load fc_minus_ac210.mat
load outliers36_210_5k.mat


TaskList={ 'EMOTION';'GAMBLING';'LANGUAGE';'MOTOR' ;'RELATIONAL'; 'SOCIAL'; 'WM'} ;
ContrastList = { {'FACES','SHAPES','FACES-SHAPES'},{'PUNISH','REWARD','PUNISH-REWARD'},{'MATH','STORY','STORY-MATH'},...
    {'CUE','LF','LH','RF','RH','T','AVG','CUE-AVG','LF-AVG','LH-AVG','RF-AVG','RH-AVG','T-AVG'},...
    {'MATCH','REL','REL-MATCH'},{'RANDOM','TOM','TOM-RANDOM'},{'2BK_BODY','2BK_FACE','2BK_PLACE','2BK_TOOL','0BK_BODY',...
    '0BK_FACE','0BK_PLACE','0BK_TOOL','2BK','0BK','2BK-0BK','BODY','FACE','PLACE','TOOL','BODY-AVG','FACE-AVG','PLACE-AVG','TOOL-AVG'} }; 
cope=[1 1 3 6 2 2 9];
%%cope=[2 1 2 4 2 1 11];

result_path = '/DATA/236/dywu/HCP1200/prediction_fmri/visualization210_outlier5k';
mkdir(result_path)

roidir = '/DATA/235/dywu/script/ROI_surf210';
num.chars    = 2;                               % # of characters to consider
roilist      = struct2cell(dir(roidir))';       % list folder content
roilist      = char(roilist(:,1));              % convert to string
roilist(roilist(:,1)=='.',:) = [];              % find hidden folders/files (starting with '.') and delete
num.roilist = size(roilist,1);                 % # of roilists
roilist      = cellstr(roilist);                % make cell array (for convenience)   

% for j=1:num.roilist
%     
%      mask{j}=load(fullfile('/DATA/235/dywu/script/ROI_surf210',roilist{j}));
% 
% end

%%

% dti_variation=0*mask{1};
% resting_variation=0*mask{1};
% for k=1:num.roilist
%     dti_variation=dti_variation+mask{k}*variation(k,1);
%     resting_variation=resting_variation+mask{k}*variation(k,2);
% end
% 
% dlmwrite(fullfile(result_path,'dti_variation.txt'),dti_variation,'delimiter',' ','newline', 'pc','-append')
% dlmwrite(fullfile(result_path,'resting_variation.txt'),resting_variation,'delimiter',' ','newline', 'pc','-append')

%%

for i=1:7
  num.copelist=length(result_reshape_dti{i});
  
  dtiall=[]; restingall=[]; activationall=[]; tvariationall=[]; fc_ac_all=[];diffall=[]; 
  for m=1:num.copelist
      dti=0*mask{1};
      resting=0*mask{1};
      activation=0*mask{1};
      tvariation=0*mask{1};
      fc_ac = 0*mask{1};
      diff=0*mask{1};
      
      for k=1:num.roilist
          dti=dti+mask{k}*result_reshape_dti{i}{m}(1,k);
          resting=resting+mask{k}*result_reshape_resting{i}{m}(1,k);
          activation=activation+mask{k}*result_reshape_dti{i}{m}(3,k);
          tvariation=tvariation+mask{k}*task_variation_reshape{i}{m}(1,k);
          %fc_ac=fc_ac+mask{k}*h_pair2{i}{m}(1,k);
          fc_ac=fc_ac+mask{k}*outliers{i}{m}(k)*k;
          diff=diff+mask{k}*(result_reshape_resting{i}{m}(1,k)-result_reshape_dti{i}{m}(1,k));
                  
      end
      thresh(m,i) = prctile(result_reshape_dti{i}{m}(3,:),30);
      mask2=activation > thresh(m,i);  
      tvariation=tvariation.*mask2; %activation=activation.*mask2;

%       dlmwrite(fullfile('visualization_brain',[ContrastList{i}{m},'_dti.txt']),dti,'delimiter',' ','newline', 'pc','-append')
%       dlmwrite(fullfile('visualization_brain',[ContrastList{i}{m},'_resting.txt']),resting,'delimiter',' ','newline', 'pc','-append')
%       dlmwrite(fullfile('visualization_brain',[ContrastList{i}{m},'_activation.txt']),activation,'delimiter',' ','newline', 'pc','-append')
%       dlmwrite(fullfile('visualization_brain',[ContrastList{i}{m},'_group.txt']),tvariation,'delimiter',' ','newline', 'pc','-append')
      dtiall=[dtiall dti]; restingall=[restingall resting]; 
      activationall=[activationall activation]; tvariationall=[tvariationall tvariation];
      fc_ac_all = [fc_ac_all fc_ac]; diffall=[diffall diff]; 
  end
%       dlmwrite(fullfile(result_path,[TaskList{i},'_dti.txt']),dtiall,'delimiter',' ','newline', 'pc','-append')
%       dlmwrite(fullfile(result_path,[TaskList{i},'_resting.txt']),restingall,'delimiter',' ','newline', 'pc','-append')
%       dlmwrite(fullfile(result_path,[TaskList{i},'_diff.txt']),diffall,'delimiter',' ','newline', 'pc','-append')
%       dlmwrite(fullfile(result_path,[TaskList{i},'_activation.txt']),activationall,'delimiter',' ','newline', 'pc','-append')
%       dlmwrite(fullfile(result_path,[TaskList{i},'_task_variation.txt']),tvariationall,'delimiter',' ','newline', 'pc','-append')
      dlmwrite(fullfile(result_path,[TaskList{i},'_fc_ac.txt']),fc_ac_all,'delimiter',' ','newline', 'pc','-append')
      
  
end