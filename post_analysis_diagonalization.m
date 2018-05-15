%clear
%load connectivity_variation
%close all
%load result_temp_diagonalization
% load result_diagonalization_resting
% load result_temp_diagonalization_dti
% result_all_temp_dti_reshape = reshape_cope(result_all_temp_dti1);
% result_all_temp_resting_reshape = reshape_cope(result_all_temp_resting);
% result_temp_dti_reshape = reshape_cope(result_temp_dti1);
% result_temp_resting_reshape = reshape_cope(result_temp_resting);

% load result_resting_4merge_task2
% reshape_column_cope
% result_reshape_resting = result_reshape;
% 
% load result_dti_task2
% reshape_column_cope
% result_reshape_dti = result_reshape;

%load result_dti_task210val5k.mat
load result_dti-distance_task210_5k.mat
%load result_dti_task210length_correction.mat
%load result_dti-distance_task210.mat
[ result_temp_dti_reshape ] = reshape_cope_compact( result_temp_dti );
[ result_all_temp_dti_reshape ] = reshape_cope_compact( result_all_temp_dti );


% load result_resting_4merge_task210val.mat
% [ result_temp_resting_reshape ] = reshape_cope_compact( result_temp_resting );
% [ result_all_temp_resting_reshape ] = reshape_cope_compact( result_all_temp_resting );

load result_resting-distance_task210.mat
[ result_temp_resting_reshape ] = reshape_cope_compact( result_temp_dti );
[ result_all_temp_resting_reshape ] = reshape_cope_compact( result_all_temp_dti );

% load result_distance_task210.mat
% [ result_all_temp_resting_reshape ] = reshape_cope_compact( result_all_temp_dti );


trueid = 1:20;
%%

TaskList={ 'EMOTION';'GAMBLING';'LANGUAGE';'MOTOR' ;'RELATIONAL'; 'SOCIAL'; 'WM'} ;
ContrastList = { {'FACES','SHAPES','FACES-SHAPES'},{'PUNISH','REWARD','PUNISH-REWARD'},{'MATH','STORY','STORY-MATH'},...
    {'CUE','LF','LH','RF','RH','T','AVG','CUE-AVG','LF-AVG','LH-AVG','RF-AVG','RH-AVG','T-AVG'},...
    {'MATCH','REL','REL-MATCH'},{'RANDOM','TOM','TOM-RANDOM'},{'2BK_BODY','2BK_FACE','2BK_PLACE','2BK_TOOL','0BK_BODY',...
    '0BK_FACE','0BK_PLACE','0BK_TOOL','2BK','0BK','2BK-0BK','BODY','FACE','PLACE','TOOL','BODY-AVG','FACE-AVG','PLACE-AVG','TOOL-AVG'} }; 
%cope=[1 2 3 6 1 2 9];
cope=[1 1 3 6 2 2 9];
%cope=[1 1 2 6 2 2 9];

mm=0;
qq=2;
figure

%k=0;
yyy=[];xxx=[];vvv=[];ooo=[];
for i=5:7%num.task
  num.copelist=length(result_all_temp_resting_reshape{i});
  k=0;
  clear x x2 xr
  for m=cope(i):cope(i)%1:num.copelist%
    mm=mm+1;
    
%     for j=1:210
%         
%         tdti=result_temp_dti_reshape{i}{m}{j}-diag(diag(result_temp_dti_reshape{i}{m}{j}));
%         tresting=result_temp_resting_reshape{i}{m}{j}-diag(diag(result_temp_resting_reshape{i}{m}{j}));
%         rec_dti2{i}{m}(1,j)=mean(diag(result_temp_dti_reshape{i}{m}{j}))/( mean(diag(result_temp_dti_reshape{i}{m}{j}))+mean(tdti(tdti~=0)) );
%         rec_resting2{i}{m}(1,j)=mean(diag(result_temp_resting_reshape{i}{m}{j}))/( mean(diag(result_temp_resting_reshape{i}{m}{j}))+mean(tresting(tresting~=0)) );
% 
%         
%         result_temp_dti_reshape{i}{m}{j}=(result_temp_dti_reshape{i}{m}{j}-repmat(mean(result_temp_dti_reshape{i}{m}{j},2),1,20))./repmat(std(result_temp_dti_reshape{i}{m}{j},0,2),1,20);
%         result_temp_resting_reshape{i}{m}{j}=(result_temp_resting_reshape{i}{m}{j}-repmat(mean(result_temp_resting_reshape{i}{m}{j},2),1,20))./repmat(std(result_temp_resting_reshape{i}{m}{j},0,2),1,20);
%         result_temp_dti_reshape{i}{m}{j}=(result_temp_dti_reshape{i}{m}{j}-repmat(mean(result_temp_dti_reshape{i}{m}{j}),20,1))./repmat(std(result_temp_dti_reshape{i}{m}{j}),20,1);
%         result_temp_resting_reshape{i}{m}{j}=(result_temp_resting_reshape{i}{m}{j}-repmat(mean(result_temp_resting_reshape{i}{m}{j}),20,1))./repmat(std(result_temp_resting_reshape{i}{m}{j}),20,1);
%         
%         
%         [~,diag_dti{i}{m}{j}]=max(result_temp_dti_reshape{i}{m}{j},[],2); 
%         [~,diag_resting{i}{m}{j}]=max(result_temp_resting_reshape{i}{m}{j},[],2);
%  
%         rec_dti{i}{m}(1,j) = sum((diag_dti{i}{m}{j}'-trueid)==0)/20;
%         rec_resting{i}{m}(1,j) = sum((diag_resting{i}{m}{j}'-trueid)==0)/20;
%         
%     end
    
    
%%     
    
%     k=k+1;
%     x(k,:)=rec_dti{i}{m}(1,:);
%     x2(k,:)=rec_resting{i}{m}(1,:);
%     xr(k,:)=result_reshape_resting{i}{m}(1,:);
%     
%     result_temp = result_reshape_resting{i}{m};
%     %result_temp = result_reshape_dti{i}{m};
%     xx=(result_temp(5,:));
%     %yy=rec_dti{i}{m}(1,:);
%     yy=rec_resting{i}{m}(1,:);
%     
%     yyy=[yyy;yy'];xxx=[xxx;xx'];vvv=[vvv;variation(2,:)'];ooo=[ooo; ones(360,1)];
%     [b,~,~,~,stats]=regress(yy',[xx' variation(2,:)' ones(360,1)]);
%     [r,p]=partialcorr(variation(2,:)' ,yy', xx');
    
% 
%     subplot(2,4,mm)
%     %figure
%     %plot(x,y,'b.')
%     %scatter(act,rec_resting{i}{m}(1,:),23,'k','fill')
%     scatter(xx,yy,23,'k','fill')
%     hold on
%     [p s]=polyfit(xx,yy,1);
%     yfit=polyval(p,xx);
%     %R2_1 = norm(yfit -mean(y1))^2/norm(y1 - mean(y1))^2
%     %plot(xx,yfit,'k-')
%     cc(i,m)=corr(xx',yy');
%     
%     title([TaskList{i} ['  ',ContrastList{i}{m}]],'FontName','Times New Roman','FontSize',15)     
%     xlabel('Resting prediction accuracy','FontName','Times New Roman','FontSize',15)
%     ylabel('percentage of best matches','FontName','Times New Roman','FontSize',15)
%     text(0.5,0.25,['correlation = ',num2str(cc(i,m),2)],'FontName','Times New Roman','FontSize',15);
%     axis([-0.1,0.8,0,1]);
    
%%

% %     [~,diag_all_dti{i}{m}]=max(result_all_temp_dti_reshape{i}{m}); 
% %     [~,diag_all_resting{i}{m}]=max(result_all_temp_resting_reshape{i}{m});

    tdti=result_all_temp_dti_reshape{i}{m}-diag(diag(result_all_temp_dti_reshape{i}{m}));
    tresting=result_all_temp_resting_reshape{i}{m}-diag(diag(result_all_temp_resting_reshape{i}{m}));
    
    %offdti=tdti(tdti~=0);offresting=tresting(tdti~=0);
    offdti=mean(tdti,2)*20/19; offresting=mean(tresting,2)*20/19;
    diagdti=diag(result_all_temp_dti_reshape{i}{m});
    diagresting=diag(result_all_temp_resting_reshape{i}{m});
    
    dd_dti=diagdti./offdti;  dd_resting=diagresting./offresting;
    [h_d(m,i),p_d(m,i),ci_d{i}{m},stats_d{i}{m}] = ttest(dd_resting,dd_dti,'Alpha',1e-4,'Tail','right');
    %[h_d(m,i),p_d(m,i),ci_d{i}{m},stats_d{i}{m}] = ttest(dd_dti,dd_resting,'Alpha',1e-4,'Tail','right');
    
    %[h_o(m,i),p_o(m,i),ci_o{i}{m},stats_o{i}{m}] = ttest(offdti,offresting,'Alpha',1e-4,'Tail','right');
    %[h_o(m,i),p_o(m,i),ci_o{i}{m},stats_o{i}{m}] = ttest(offresting,offdti,'Alpha',1e-4,'Tail','right');

        
    result_all_temp_dti_reshape{i}{m}=(result_all_temp_dti_reshape{i}{m}-repmat(mean(result_all_temp_dti_reshape{i}{m},2),1,20))./repmat(std(result_all_temp_dti_reshape{i}{m},0,2),1,20);
    result_all_temp_resting_reshape{i}{m}=(result_all_temp_resting_reshape{i}{m}-repmat(mean(result_all_temp_resting_reshape{i}{m},2),1,20))./repmat(std(result_all_temp_resting_reshape{i}{m},0,2),1,20);
    result_all_temp_dti_reshape{i}{m}=(result_all_temp_dti_reshape{i}{m}-repmat(mean(result_all_temp_dti_reshape{i}{m}),20,1))./repmat(std(result_all_temp_dti_reshape{i}{m}),20,1);
    result_all_temp_resting_reshape{i}{m}=(result_all_temp_resting_reshape{i}{m}-repmat(mean(result_all_temp_resting_reshape{i}{m}),20,1))./repmat(std(result_all_temp_resting_reshape{i}{m}),20,1);
    

    
    [~,diag_all_dti{i}{m}]=max(result_all_temp_dti_reshape{i}{m},[],2); 
    [~,diag_all_resting{i}{m}]=max(result_all_temp_resting_reshape{i}{m},[],2);
 
    rec_all_dti{i}(m) = sum((diag_all_dti{i}{m}'-trueid)==0)/20;
    rec_all_resting{i}(m) = sum((diag_all_resting{i}{m}'-trueid)==0)/20;
    
    
    subplot(4,2,(mm-1)*2+1)    
    %imagesc(result_all_temp_dti_reshape{i}{m}-repmat(mean(result_all_temp_dti_reshape{i}{m}),20,1))
    imagesc(result_all_temp_dti_reshape{i}{m})
    title({[TaskList{i} ['  ',ContrastList{i}{m}] ' AC'];['PBM: ' num2str(rec_all_dti{i}(m))]},'FontName','Times New Roman','FontSize',10,'FontWeight','bold')
    %title({[TaskList{i} ['  ',ContrastList{i}{m}] ' AC']},'FontName','Times New Roman','FontSize',10,'FontWeight','bold')
    xlabel('Actual','FontName','Times New Roman','FontSize',10,'FontWeight','bold')
    ylabel('Predicted','FontName','Times New Roman','FontSize',10,'FontWeight','bold')
    axis([1 20 1 20])
    caxis([-3 3])
    %axis tight   
    %colormap(pmkmp(100,'CubicL'))
    %colorbar
    
    subplot(4,2,(mm-1)*2+2)    
    %imagesc(result_all_temp_resting_reshape{i}{m}-repmat(mean(result_all_temp_resting_reshape{i}{m}),20,1))
    imagesc(result_all_temp_resting_reshape{i}{m})
    title({[TaskList{i} ['  ',ContrastList{i}{m}] ' Resting'];['PBM: ' num2str(rec_all_resting{i}(m))]},'FontName','Times New Roman','FontSize',10,'FontWeight','bold')
    %title({[TaskList{i} ['  ',ContrastList{i}{m}] ' Distance']},'FontName','Times New Roman','FontSize',10,'FontWeight','bold')
    xlabel('Actual','FontName','Times New Roman','FontSize',10,'FontWeight','bold')
    ylabel('Predicted','FontName','Times New Roman','FontSize',10,'FontWeight','bold')
    axis([1 20 1 20])
    caxis([-3 3])
    %axis tight   
    %colormap(pmkmp(100,'CubicL'))
    %colorbar
    colormap(jet)
    
  end  
    
%     figure
% 
%     subplot(2,1,1)    
%     imagesc(x2)
%     title([TaskList{i} ' rec resting'])
%     xlabel('Brain regions')
%     ylabel('Contrasts')
%     axis([1 360 1 num.copelist])
%     axis tight   
%     colormap(fmri_activation_colormap)
%     caxis([0,1]);
%     colorbar
%     
%     subplot(2,1,2)    
%     imagesc(x)
%     title([TaskList{i} ' rec dti'])
%     xlabel('Brain regions')
%     ylabel('Contrasts')
%     axis([1 360 1 num.copelist])
%     axis tight   
%     colormap(fmri_activation_colormap)
%     caxis([0,1]);
%     colorbar

%     subplot(2,1,2)
%     imagesc(xr)
%     title([TaskList{i} ' resting prediction'])
%     xlabel('Brain regions')
%     ylabel('Contrasts')
%     axis([1 360 1 num.copelist])
%     axis tight
%     colormap(fmri_activation_colormap)
%     caxis([-0.1,0.65]);
%     colorbar
end

% [b,~,~,~,stats]=regress(yyy,[xxx vvv ooo ])
% [r,p]=partialcorr(vvv ,yyy, xxx)
set(gcf,'color','white');