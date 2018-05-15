% clear

% load result_task_variation210
% [ task_variation_reshape ] = reshape_cope_compact( task_variation );
% 
% load result_dti_task210val.mat
% [ result_persub_reshape_dti ] = reshape_cope_compact( result_persub );
% [ result_reshape_dti ] = reshape_cope_compact( result );
% 
% load result_resting_4merge_task210val.mat
% [ result_persub_reshape_resting ] = reshape_cope_compact( result_persub );
% [ result_reshape_resting ] = reshape_cope_compact( result );
% 
% load connectivity_variation210

%load lookuptable
rowx=1;
rowx2=3;
rowy=1;

TaskList={ 'EMOTION';'GAMBLING';'LANGUAGE';'MOTOR' ;'RELATIONAL'; 'SOCIAL'; 'WM'} ;
ContrastList = { {'FACES','SHAPES','FACES-SHAPES'},{'PUNISH','REWARD','PUNISH-REWARD'},{'MATH','STORY','STORY-MATH'},...
    {'CUE','LF','LH','RF','RH','T','AVG','CUE-AVG','LF-AVG','LH-AVG','RF-AVG','RH-AVG','T-AVG'},...
    {'MATCH','REL','REL-MATCH'},{'RANDOM','TOM','TOM-RANDOM'},{'2BK_BODY','2BK_FACE','2BK_PLACE','2BK_TOOL','0BK_BODY',...
    '0BK_FACE','0BK_PLACE','0BK_TOOL','2BK','0BK','2BK-0BK','BODY','FACE','PLACE','TOOL','BODY-AVG','FACE-AVG','PLACE-AVG','TOOL-AVG'} };
cope=[1 2 3 6 1 2 9];
%cope=[3 3 3 6 3 3 11];

%% find difference

% xx=[];yy=[];
% for i=1:7%num.task
%     num.copelist=length(result_persub_reshape_dti{i});
%     for m=1:num.copelist
%         
%         x1 = fisherz(result_persub_reshape_resting{i}{m}{1});
%         x2 = fisherz(result_persub_reshape_dti{i}{m}{1});
%         %     x1 = (result_persub_reshape_resting{i}{m}{1});
%         %     x2 = (result_persub_reshape_dti{i}{m}{1});
%         
%         [h_dti{i}{m},p_dti{i}{m},ci_dti{i}{m},stats_dti{i}{m}] = ttest(x2,0,'Alpha',0.01,'Tail','right');
%         [h_resting{i}{m},p_resting{i}{m},ci_resting{i}{m},stats_resting{i}{m}] = ttest(x1,0,'Alpha',0.01,'Tail','right');
%         [h_pair{i}{m},p_pair{i}{m},ci_pair{i}{m},stats_pair{i}{m}] = ttest(x1,x2,'Alpha',1e-4,'Tail','right');
%         
%         %     [~,index2] = sort(stats_pair{i}{m}.tstat,'descend');
%         
%         x = result_reshape_resting{i}{m}(1,:);  xx=[xx;x];
%         y = result_reshape_dti{i}{m}(1,:);    yy=[yy;y];
%         diff = x-y;
%         small=(x>0.34)&(y<0.34);
%         %diff = diff.*h_pair{i}{m};
%         [~,index2] = sort(diff,'descend');
%         outliers{i}{m} = zeros(size(h_pair{i}{m}));
%         outliers{i}{m}(index2(1:18))=1;
%         
%         %outliers{i}{m} = outliers{i}{m}.*h_pair{i}{m};
%         outliers{i}{m}=outliers{i}{m}.*small;
%         
% %         x = result_reshape_resting{i}{m}(1,:)';  xx=[xx;x];
% %         y = result_reshape_dti{i}{m}(1,:)';      yy=[yy;y];
% %         yold=y;xold=x;
% %         %intercept=mean(y-x);
% %         y(index2(1:18))=[];x(index2(1:18))=[];
% %         [b,bint,r,rint,stats] = regress( y,[x ones(size(y,1),1)] );
% %         y=yold;x=xold;
% %         yfit=[x ones(size(y,1),1)]*b;
% %         res=y-yfit;
% %         outlier = find(res < min(rint(:,1)));
% %         outliers{i}{m}=zeros(length(y),1);outliers{i}{m}(outlier)=1;
%         
%         %sum(h_pair{i}{m})
%         
%     end
% end
% 
% %save fc_minus_ac210.mat h_pair2
% save outliers36_210_5k.mat outliers

%% permutation analysis

% load result_dti_task210val5k.mat
load result_dti-distance_task210_5k.mat
load result_dti_task_permutation210.mat


%load result_resting_4merge_task210val.mat
% load result_resting-distance_task210_5k.mat
% load result_resting_4merge_task_permutation210.mat

% [ result_persub_permutation_reshape_dti ] = reshape_cope_compact( result_persub_permutation );
% [ result_permutation_reshape_dti ] = reshape_cope_compact( result_permutation );

% load result_resting_4merge_task_permutation210
% [ result_persub_permutation_reshape_resting ] = reshape_cope_compact( result_persub_permutation );
% [ result_permutation_reshape_resting ] = reshape_cope_compact( result_permutation );

[ result_persub_reshape ] = reshape_cope_compact( result_persub );
[ result_reshape ] = reshape_cope_compact( result );

for k=1:100
          result_permutation_reshape{k}=reshape_cope_compact(result_permutation{k});
          result_persub_permutation_reshape{k}=reshape_cope_compact(result_persub_permutation{k});
end

for i=1:7%num.task
  num.copelist=length(result{i});
  for j=1:num.copelist

      xx{i}{j}(1,:)=result_reshape{i}{j}(1,:);
      sub{i}{j}=result_persub_reshape{i}{j}{1};
      for k=1:100
          yy(k,:)=result_permutation_reshape{k}{i}{j}(1,:);
          sub_p{i}{j}(:,:,k)=result_persub_permutation_reshape{k}{i}{j}{1};
      end


      [quartile,~] = sort(yy,1);
      quartile = quartile(100,:);
      h_pair_mean{i}{j} = xx{i}{j} > quartile;
      perm_num(j,i) = sum(xx{i}{j} > quartile);
    
      act1{i}{j} = result_reshape{i}{j}(3,h_pair_mean{i}{j});
      act2{i}{j} = result_reshape{i}{j}(3,~h_pair_mean{i}{j});
      [h_pair(j,i),p_pair(j,i)] = ttest2(act1{i}{j},act2{i}{j},'Alpha',1e-3,'Tail','right');

      
%       [quartile_index_x,~] = sort(sub_p{i}{j},3);
%       quartile_index_x = quartile_index_x(:,:,1:95);
%       sub3{i}{j} =  max(quartile_index_x,[],3);
%       
%       [h_pair{i}{j},p_pair{i}{j},ci_pair{i}{j},stats_pair{i}{j}] = ttest(sub{i}{j},sub3{i}{j},'Alpha',1e-3,'Tail','right');
%       %h_pair{i}{j}(2,:) = result{i}{j}(1,:);
%       
%       perm_num2(j,i) = sum(h_pair{i}{j});
      

  end
end
% %save permutation_num_dti.mat perm_num
% %save permutation_analysis_resting.mat h_pair

%% variance explaining Y: prediction performance, X1: activation, X2: task variation
% 
% for i=1:7%num.task
%   num.copelist=length(result_reshape_dti{i});
%   for m=1:num.copelist
% 
%     x2=task_variation_reshape{i}{m}(1,:)';
%     x1=result_reshape_resting{i}{m}(3,:)';
%     intercept=[ones(length(x1),1)];
% 
%     y2=result_reshape_dti{i}{m}(1,:)';
%     y1=result_reshape_resting{i}{m}(1,:)';
% 
%     y=y1;
%     [~,~,~,~,stats1{i}{m}]=regress(y,[x1 x2 intercept]);
%     [~,~,residual1{i}{m},~,stats2{i}{m}]=regress(y,[x1 intercept]);
%     [~,~,residual2{i}{m},~,stats3{i}{m}]=regress(y,[x2 intercept]);
%     [~,~,~,~,stats4{i}{m}]=regress(residual1{i}{m},[x2 intercept]);
%     [~,~,~,~,stats5{i}{m}]=regress(residual2{i}{m},[x1 intercept]);
% 
%     variance1(m,i)=roundn(stats1{i}{m}(1),-2) ;
%     variance2(m,i)=roundn(stats2{i}{m}(1),-2);
%     variance3(m,i)=roundn(stats3{i}{m}(1),-2);
%     variance4(m,i)=roundn(stats4{i}{m}(1),-2);
%     variance5(m,i)=roundn(stats5{i}{m}(1),-2);
% 
%   end
% end

%% variance explaining Y: task variation, X1: activation, X2: connectivity variation
% 
% % load result_diagonalization210.mat
% yyy=[];xxx=[];ooo=[];
% for i=1:7%num.task
%   num.copelist=length(result_reshape_dti{i});
%   for m=1:num.copelist
% 
%     y0=task_variation_reshape{i}{m}(1,:)';
% %     y1=rec_resting{i}{m}';
% %     y2=rec_dti{i}{m}';
% 
%     y=y0;
%     
%     %x1=result_reshape_resting{i}{m}(1,:)';
%     x1=result_reshape_dti{i}{m}(3,:)';
%     
% 
%     xe2=variation(:,1);
%     xr2=variation(:,2);
% 
%     x2 = xr2;
%     
%     %yyy=[yyy;y0]; xxx=[xxx;x2]; ooo=[ooo; intercept];
% %     thresh(m,i) = prctile(x1,10);
% %     mask2=x1 > thresh(m,i); y=y(mask2);x1=x1(mask2); x2=x2(mask2); 
%     
%     intercept=[ones(length(x1),1)];
%     [~,~,~,~,stats1{i}{m}]=regress(y,[x1 x2 intercept]);
%     [~,~,residual1{i}{m},~,stats2{i}{m}]=regress(y,[x1 intercept]);
%     [~,~,residual2{i}{m},~,stats3{i}{m}]=regress(y,[x2 intercept]);
%     [~,~,~,~,stats4{i}{m}]=regress(residual1{i}{m},[x2 intercept]);
%     [~,~,~,~,stats5{i}{m}]=regress(residual2{i}{m},[x1 intercept]);
%     
%     variance1(m,i)=roundn(stats1{i}{m}(1),-2) ;
%     variance2(m,i)=roundn(stats2{i}{m}(1),-2);
%     variance3(m,i)=roundn(stats3{i}{m}(1),-2);
%     variance4(m,i)=roundn(stats4{i}{m}(1),-2);
%     variance5(m,i)=roundn(stats5{i}{m}(1),-2);
% 
%   end
% end
% %[~,~,~,~,stats]=regress(yyy,[xxx ooo]);
