% clear
% load result_resting_4merge_task2
% reshape_column_cope
% result_reshape_resting = result_reshape;
% 
% clear result_reshape result_all_reshape
% load result_dti_task
% reshape_column_cope

load result_dti_task210val.mat
[ result_reshape_dti ] = reshape_cope_compact( result );

load result_resting_4merge_task210val.mat
[ result_reshape_resting ] = reshape_cope_compact( result );

%load colormap.mat
%k=0;
for i=7:7%num.task
  num.copelist=length(result_reshape_dti{i});
  k=0;
  clear x y x2 x3 xr
  for m=1:num.copelist
   
    k=k+1;
    x(k,:)=result_reshape_dti{i}{m}(1,:);%/max(result_temp(rowx,:));
%     x2(k,:)=result_reshape_dti{i}{m}(rowx2,:);
%     x3(k,:)=result_reshape_dti{i}{m}(rowx3,:);
    y(k,:)=result_reshape_dti{i}{m}(3,:);%/max(result_temp(rowy,:));
    xr(k,:)=result_reshape_resting{i}{m}(1,:);
    %%
    

%     %subplot(3,3,m)
%     %subplot(2,3,(i-5)*3+m)
%     subplot(3,1,(i-3)*3+m)
%     %figure
%     imagesc([x;y])
%    
%     title([TaskList{i} ' Contrast ' num2str(m)])     
%     xlabel('Brain regions')
%     %ylabel('Prediction result(Extrinsic)')
%     axis([1 210 1 2 ])
%     colorbar
%     
    
  end  
    figure
    
    subplot(3,1,1)    
    imagesc(x)
    title([TaskList{i} ' connectivity prediction result'])
    xlabel('Brain regions')
    ylabel('Contrasts')
    axis([1 210 1 num.copelist])
    axis tight   
    colormap(jet)
    %caxis([-0.1,0.65]);
    colorbar
    
%     subplot(5,1,2)    
%     imagesc(x2)
%     title([TaskList{i} ' intrinsic prediction result'])
%     xlabel('Brain regions')
%     ylabel('Contrasts')
%     axis([1 210 1 num.copelist])
%     axis tight   
%     colormap(fmri_activation_colormap)
%     colorbar
%     
%     subplot(5,1,3)    
%     imagesc(x3)
%     title([TaskList{i} ' group prediction result'])
%     xlabel('Brain regions')
%     ylabel('Contrasts')
%     axis([1 210 1 num.copelist])
%     axis tight   
%     colormap(fmri_activation_colormap)
%     colorbar
    
    subplot(3,1,2)
    imagesc(xr)
    title([TaskList{i} ' resting prediction'])
    xlabel('Brain regions')
    ylabel('Contrasts')
    axis([1 210 1 num.copelist])
    axis tight
    colormap(jet)
    %caxis([-0.1,0.65]);
    colorbar
    
    subplot(3,1,3)
    imagesc(y)
    title([TaskList{i} ' activation'])
    xlabel('Brain regions')
    ylabel('Contrasts')
    axis([1 210 1 num.copelist])
    axis tight
    colormap(jet)
    colorbar
    
    
end

% imagesc(x)
% axis([1 210 1 47])
% colormap(fmri_activation_colormap)
% figure
% imagesc(y)
% axis([1 210 1 47])