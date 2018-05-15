% clear
% 
% load result_task_variation380
% [ task_variation_reshape ] = reshape_cope_compact( task_variation );
% 
% load result_dti_task380.mat
% [ result_reshape_dti ] = reshape_cope_compact( result );
% 
% load result_resting_4merge_task380.mat
% [ result_reshape_resting ] = reshape_cope_compact( result );

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
mm=0;
qq=7;
figure
for i=1:qq%num.task
  num.copelist=length(result{i});
  for m=cope(i):cope(i)%1:num.copelist
    mm=mm+1;
   
    y=task_variation_reshape{i}{m}(1,:);
    %x2=result_reshape_dti{i}{m}(1,:);   
    x2=result_reshape_resting{i}{m}(1,:);
    %x2=result_reshape_resting{i}{m}(1,:)-result_reshape_dti{i}{m}(1,:);
    x=result_reshape_resting{i}{m}(3,:);

%     [~,quartile_index_x] = sort(x);
%     [~,quartile_index_y] = sort(y);
%     temp_x = zeros(size(quartile_index_x));
%     temp_y = zeros(size(quartile_index_y));
%     quartile_index_x = quartile_index_x(ceil(length(quartile_index_x)*0.95):end);
%     quartile_index_y = quartile_index_y(ceil(1:length(quartile_index_y)*0.75));
%     temp_x(quartile_index_x)=1;
%     temp_y(quartile_index_y)=1;
% %     temp_x=logical(temp_x);
% %     temp_y=logical(temp_y);
%     temp_xy=temp_x.*temp_y;
% %    temp_xy=reshape(temp_xy,num.copelist,[]);
%     
%     index_result{i}{m}(1,:)=find(temp_xy>0);
%     index_result{i}{m}(2,:)=x(temp_xy>0);
%     index_result{i}{m}(3,:)=y(temp_xy>0);
%     index_result{i}{m}(4,:)=x2(temp_xy>0);
    
    
%%  
    %subplot(3,3,m)
    %subplot(2,3,(i-5)*3+m)
    subplot(2,4,mm)
    %figure
    %plot(x,y,'b.')
   
%     xx=[x;y]';
%     [xxwh, mu, invMat, whMat] = whiten(xx);
%     x=xxwh(:,1)';
%     y=xxwh(:,2)';
    
    %scatter(x,y,23,'k','fill')
    scatter(x,y,23,x2,'fill')
    colormap(jet)
 
%     load colormap.mat
%     colormap(fmri_activation_colormap)
    hold on
    p=polyfit(x,y,1);
    yfit=polyval(p,x);
    R2 = norm(yfit -mean(y))^2/norm(y - mean(y))^2;
  
    %plot(x,yfit,'k-')
    title([TaskList{i} ['  ',ContrastList{i}{m}]],'FontName','Times New Roman','FontSize',15,'FontWeight','bold');
    xlabel('Absolute activation','FontName','Times New Roman','FontSize',15,'FontWeight','bold')
    %ylabel('Task variation','FontName','Times New Roman','FontSize',15,'FontWeight','bold')
    %xlabel('FC prediction','FontName','Times New Roman','FontSize',15,'FontWeight','bold')
    ylabel('AC prediction','FontName','Times New Roman','FontSize',15,'FontWeight','bold')

    %text(3.5,0,['correlation = ',num2str(corr(x',y'),2)],'FontName','Times New Roman','FontSize',15,'FontWeight','bold');
    text(1,0.6,['r = ',num2str(corr(x',y'),2)],'FontName','Times New Roman','FontSize',15,'FontWeight','bold');
%     plot([-0.1 0.8],[-0.1 0.8],'k-')
%     axis([-0.1,0.8,-0.1,0.8]);
    axis square
    %set(gca,'XTick',-0.1:0.1:0.7, 'YTick',-0.1:0.1:0.7);
    
    
    %%
%     scatter3(x,x2,y)
%     xlabel('Absolute activation','FontName','Times New Roman','FontSize',15,'FontWeight','bold')
%     ylabel('Task variation','FontName','Times New Roman','FontSize',15,'FontWeight','bold')
%     zlabel('FC prediction','FontName','Times New Roman','FontSize',15,'FontWeight','bold')
%%  
    
%     subplot(4,2,(mm-1)*2+1)
%     index1 = x>0;
%     index2 = x<0;
%     x1=x(index1);
%     y1=y(index1);
%     x2=x(index2);
%     y2=y(index2);
%     %plot(x1,y1,'b.')
%     %scatter(x1,y1,23,lookup(index1),'fill')
%     scatter(x1,y1,23,'k','fill')
%     hold on
%     [p1,s1]=polyfit(x1,y1,1);
%     yfit1=polyval(p1,x1);
%     R2_1 = norm(yfit1 -mean(y1))^2/norm(y1 - mean(y1))^2
%     plot(x1,yfit1,'k-')
%     title([TaskList{i} ['  ',ContrastList{i}{m}]],'FontName','Times New Roman','FontSize',15);
%     xlabel('Activation','FontName','Times New Roman','FontSize',15)
%     ylabel('Prediction','FontName','Times New Roman','FontSize',15)
% 
%     text(0.05,0.7,['correlation = ',num2str(corr(x1',y1'),2)]);
%     %axis([[],[],-0.1,0.8]);
%     
%     subplot(4,2,(mm-1)*2+2)
%     %plot(x2,y2,'b.')
%     %scatter(x2,y2,[],lookup(index2),'fill')
%     scatter(x2,y2,23,'k','fill')
%     hold on
%     [p2,s2]=polyfit(x2,y2,1);
%     yfit2=polyval(p2,x2);
%     R2_2 = norm(yfit2 -mean(y2))^2/norm(y2 - mean(y2))^2
%     plot(x2,yfit2,'k-') 
%     title([TaskList{i} ['  ',ContrastList{i}{m}]],'FontName','Times New Roman','FontSize',15);
%     xlabel('De-activation','FontName','Times New Roman','FontSize',15)
%     ylabel('Prediction','FontName','Times New Roman','FontSize',15)
%     text(0.05,0.7,['correlation = ',num2str(corr(x2',y2'),2)]);
%     %axis([[],[],-0.1,0.8]);
    
  end  
end
set(gcf,'color','white');