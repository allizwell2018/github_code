% clear
%
load result_task_variation210
[ task_variation_reshape ] = reshape_cope_compact( task_variation );

load result_dti_task210val.mat
[ result_reshape_dti ] = reshape_cope_compact( result );

load result_resting_4merge_task210val.mat
[ result_reshape_resting ] = reshape_cope_compact( result );

% load permutation_analysis_dti.mat
% [ h_pair_dti ] = reshape_cope_compact( h_pair );
%
% load permutation_analysis_resting.mat
% [ h_pair_resting ] = reshape_cope_compact( h_pair );

load fc_minus_ac210.mat

%load lookuptable
rowx=1;
rowx2=3;
rowy=1;

TaskList={ 'EMOTION';'GAMBLING';'LANGUAGE';'MOTOR' ;'RELATIONAL'; 'SOCIAL'; 'WM'} ;
ContrastList = { {'FACES','SHAPES','FACES-SHAPES'},{'PUNISH','REWARD','PUNISH-REWARD'},{'MATH','STORY','STORY-MATH'},...
    {'CUE','LF','LH','RF','RH','T','AVG','CUE-AVG','LF-AVG','LH-AVG','RF-AVG','RH-AVG','T-AVG'},...
    {'MATCH','REL','REL-MATCH'},{'RANDOM','TOM','TOM-RANDOM'},{'2BK_BODY','2BK_FACE','2BK_PLACE','2BK_TOOL','0BK_BODY',...
    '0BK_FACE','0BK_PLACE','0BK_TOOL','2BK','0BK','2BK-0BK','BODY','FACE','PLACE','TOOL','BODY-AVG','FACE-AVG','PLACE-AVG','TOOL-AVG'} };
%cope=[1 1 3 6 2 2 9];
%cope=[1 2 3 6 1 2 9];
cope=[1 1 3 6 2 2 11];
%cope=[2 2 2 5 1 1 9];

mm=0;
qq=7;
figure
for i=1:7
    num.copelist=length(result_reshape_resting{i});
    for m=cope(i):cope(i)%1:num.copelist%
        mm=mm+1;
        result_reshape_resting_temp = result_reshape_resting{i}{m};
        result_reshape_dti_temp = result_reshape_dti{i}{m};
        
        %     y=task_variation_reshape{i}{m}(1,:)';
        %     x=result_reshape_resting_temp(3,:)';
        x = result_reshape_resting{i}{m}(1,:)';
        y = result_reshape_dti{i}{m}(1,:)';
        
        diff = x-y;
        
        small=(x>0.34)&(y<0.34);
        %small=(x>mean(x))&(y<mean(y)); 
       

        [~,index2] = sort((diff),'descend');
       
        %%
        subplot(2,4,mm)
        hold on
        %scatter(x,y,25,'fill')
        yold=y;xold=x;
        
        %if m==6 & i==4
        numout=20;
        y(index2(1:numout))=[];x(index2(1:numout))=[];
        %end
        
        %small=(x>0.3)|(y>0.3); %y=y(small);x=x(small);
        %scatter(x,y,25,'r','fill')
        intercept=mean(y-x);
        [b,bint,r,rint,stats] = regress( y,[x ones(size(y,1),1)] ,0.05);
        %yfit=[x ones(size(y,1),1)]*b;
        %plot(x,yfit,'k-')
        %figure
        
        bold=[0;0];
        iter=50;
        %%
%                 for o=1:iter
%         
%                     %plot(x,y,'b.')
%         
%                     %     xx=[x;y]';
%                     %     [xxwh, mu, invMat, whMat] = whiten(xx);
%                     %     x=xxwh(:,1)';
%                     %     y=xxwh(:,2)';
%         
%                     %     size1 = h_pair_resting{i}{m}-h_pair_dti{i}{m};
%                     %     size1(size1==-1)=0;
%                     size1 = h_pair2{i}{m};
%                     size0 = 10;
%                     size0 = size0 + size1*50;
%         
%                     %scatter(x,y,size0,x2,'fill')
%                     %scatter(x,y,size0,[x2;x3;ones(1,360)]','fill')
%                     %colormap(jet)
%         
%                     %scatter(x,y,25,'fill')
%                     hold on
%                     [b,bint,r,rint,stats] = regress( y,[x ones(size(y,1),1)] );
%         
%                     %     [p,s] = polyfit(x,y,1);
%                     %     [yfit,dy] = polyconf(p,x,s,'predopt','curve');
%         
%                     yfit=[x ones(size(y,1),1)]*b;
%                     R2 = norm(yfit -mean(y))^2/norm(y - mean(y))^2;
%                     ch{i}{m}(o)=norm(b-bold);
% %                     if norm(b-bold)<1e-3
% %                                 plot(x,yfit,'k-')
% %                                 line(x,yfit,'color','r')
% %                                 line(x,yfit-dy,'color','r','linestyle',':')
% %                                 line(x,yfit+dy,'color','r','linestyle',':')
% %                         break
% %                     end
%                     bold=b;
%                     %[~,outlier]=max(r);
%                     [~,outlier]=min(r);
%         
%                     %rint(outlier,:)
% %                     if rint(outlier,1)>0
% %                         plot(x,yfit,'k-')
% %                         break
% %                     end
%         
%                     %     index=ones(length(y),1);index(outlier)=2;
%                     %     scatter(x,y,25,index,'fill')
%                     %      colormap(jet)
%         
% %                     if o==iter
% %                         plot(x,yfit,'k-')
% %                         %line(x,yfit,'color','k')
% %                     end
%         
%                     y(outlier)=[];x(outlier)=[];
%                     %y(outlier)=mean(y);x(outlier)=mean(x);
%         
%                     %xlabel('FC prediction','FontName','Times New Roman','FontSize',15,'FontWeight','bold')
%                     %ylabel('AC prediction','FontName','Times New Roman','FontSize',15,'FontWeight','bold')
%         
%                     %text(3.5,0,['correlation = ',num2str(corr(x',y'),2)],'FontName','Times New Roman','FontSize',15,'FontWeight','bold');
%                     %text(1,0.6,['r = ',num2str(corr(x',y'),2)],'FontName','Times New Roman','FontSize',15,'FontWeight','bold');
%                     %     plot([-0.1 0.8],[-0.1 0.8],'k-')
%                     %     axis([-0.1,0.8,-0.1,0.8]);
%                     %axis square
%                     %set(gca,'XTick',-0.1:0.1:0.7, 'YTick',-0.1:0.1:0.7);
%         
%                 end

        %%
        y=yold;x=xold;
        
%         yfit=[x ones(size(y,1),1)]*b;plot(x,yfit,'k-')
        
        yfit=x+intercept;plot(x,yfit,'k-')
        res=y-yfit;
        %outlier = find(res > abs(min(rint(:,1))));
        %outlier = find(res > abs(2*min(r(:,1))));
        %outlier = find(res > max(res)*1/2);
        %outlier = find(res <= min(r(:,1)));
        %outlier{i}{m} = find(res < min(rint(:,2)));
        outlier{i}{m} = find(res < -1*max(res)*1);
        %outlier{i}{m} = find(res < min(res)*1/2);
        
        outliers{i}{m}=zeros(length(y),1);outliers{i}{m}(outlier{i}{m})=1; outliers{i}{m}=outliers{i}{m}.*small;
        
        scatter(x,y,25,outliers{i}{m},'fill')        
        axis([-0.1,0.85,-0.1,0.85])
        axis square
        colormap(jet)
        title([TaskList{i} ['  ',ContrastList{i}{m}]],'FontName','Times New Roman','FontSize',15,'FontWeight','bold');
        xlabel('Absolute activation','FontName','Times New Roman','FontSize',15,'FontWeight','bold')
        ylabel('Task variation','FontName','Times New Roman','FontSize',15,'FontWeight','bold')
        
        
        
    end
end
save outliers36_210.mat outliers
%set(gcf,'color','white');