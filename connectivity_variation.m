%% connectivity variation

%% variation between subjects
% 
% for i=1:210
%     Xe=xe{i};
%     Xr=xr{i};
%     clear ce cr
%     mask=1|index_notnan{i}{1};
%     for j=1:40
%         mask=mask&index_notnan{i}{j};
%     end
%     
%     for j=1:40
%        tr=0*Xe{j};
%         
%        te=Xe{j}(mask',:)/1000;
%        
%        tr(index_notnan{i}{j}',:)=Xr{j};
%        tr=tr(mask',:);
%        ce(:,j)=te(:);
%        cr(:,j)=tr(:);
%        
% %        sse2 = svd(te,'econ');
% %        ssr2 = svd(tr,'econ');
% %        variation_within1(j,i) = sse2(1)/sum(sse2);
% %        variation_within2(j,i) = ssr2(1)/sum(ssr2);
%         
%     end
%     sse{i} = svd(ce,'econ');
%     ssr{i} = svd(cr,'econ');
%     
%     variation(1,i) = sse{i}(1)/sum(sse{i});
%     variation(2,i) = ssr{i}(1)/sum(ssr{i});
%     
% %     fe=ce(:); fe=fe(randperm(length(fe)));fe=reshape(fe,size(ce,1),size(ce,2));%rand(size(ce,1),size(ce,2));%,'like',ce);
% %     fr=cr(:); fr=fr(randperm(length(fr)));fr=reshape(fr,size(cr,1),size(cr,2));%rand(size(cr,1),size(cr,2));%,'like',cr);
% %     
% %     ssef = svd(fe,'econ');
% %     ssrf = svd(fr,'econ');
% %     
% %     variationf(1,i) = ssef(1)/sum(ssef);
% %     variationf(2,i) = ssrf(1)/sum(ssrf);
%     fprintf('roi %d\n',i)
% end

%% method 2

% load reorganize_dti_data_surf5k.mat
% load restingFunConnData_4merge_surf
% load roimask.mat 
 
roidir = '/DATA/235/dywu/script/ROI_surf210';
num.chars    = 2;                               % # of characters to consider
roilist      = struct2cell(dir(roidir))';       % list folder content
roilist      = char(roilist(:,1));              % convert to string
roilist(roilist(:,1)=='.',:) = [];              % find hidden folders/files (starting with '.') and delete
num.roilist = size(roilist,1);                 % # of roilists
roilist      = cellstr(roilist);                % make cell array (for convenience)   

load subperm 
for i=1:num.roilist 
    Xe=xe210{i};
    Xe = Xe(subperm(1:80));
    Xr=xr210{i};
    Xr = Xr(subperm(1:80));
    clear ce cr

%     Xetrain = cat(1,Xe{:});
%     Xetrain_mean = mean(Xetrain);
%     [~,feature_indexe{i}] = sort(Xetrain_mean);           
%     feature_indexe{i} = feature_indexe{i}(ceil(length(feature_indexe{i})*0.001):end);
%     
%     Xrtrain = cat(1,Xr{:});
%     Xrtrain_mean = mean(Xrtrain);
%     [~,feature_indexr{i}] = sort(Xrtrain_mean);           
%     feature_indexr{i} = feature_indexr{i}(ceil(length(feature_indexr{i})*0.001):end);
    
    for j=1:80

        
%        te=Xe{j}(:,feature_indexe{i})/5000;
%        tr=Xr{j}(:,feature_indexr{i});
        te=Xe{j}/5000;
        tr=Xr{j};
        te(:,i)=[];tr(:,i)=[];
        
%         te=(te-repmat(mean(te,2),1,size(te,2)))./repmat(std(te,1,2)+1e-6,1,size(te,2));
%         tr=(tr-repmat(mean(tr,2),1,size(tr,2)))./repmat(std(tr,1,2)+1e-6,1,size(tr,2));

        
        ce(:,j)=te(:);
        cr(:,j)=tr(:);
        
   
    end
    
    %vertexnum(i,1)=size(ce,1)/80;
    corre=corr(ce); corre=triu(corre,1);  variation(i,1) = 1-mean(corre(corre~=0));
    corrr=corr(cr); corrr=triu(corrr,1);  variation(i,2) = 1-mean(corrr(corrr~=0));

    fprintf('roi %d\n',i)
end
figure()
boxplot(variation)
variation2=variation(:);
xnumber(:,1:2)={'AC','FC'};
xnumber = repmat(xnumber,size(variation,1),1);
xnumber = xnumber(:);
color=repmat([1,2],size(variation,1),1); color=color(:);
g=gramm('x',xnumber,'y',variation2,'color',color);
g.geom_point();
g.stat_violin('fill','transparent','normalization','width');
g.draw();



dti_variation=0*roimask210{1}{1};
resting_variation=0*roimask210{1}{1};
for k=1:num.roilist
    dti_variation=dti_variation+roimask210{k}{1}*variation(k,1);
    resting_variation=resting_variation+roimask210{k}{1}*variation(k,2);
end

result_path = '/DATA/236/dywu/HCP1200/prediction_fmri/connectivity_variation210';
mkdir(result_path)
dlmwrite(fullfile(result_path,'dti_variation_region.txt'),dti_variation,'delimiter',' ','newline', 'pc','-append')
dlmwrite(fullfile(result_path,'resting_variation_region.txt'),resting_variation,'delimiter',' ','newline', 'pc','-append')


% save connectivity_variation210.mat variation

%% method 3 

% % load reorganize_dti_data_surf.mat
% % load restingFunConnData_4merge_surf
% % load roimask.mat 
% 
% roidir = '/DATA/235/dywu/script/ROI_surf210';
% num.chars    = 2;                               % # of characters to consider
% roilist      = struct2cell(dir(roidir))';       % list folder content
% roilist      = char(roilist(:,1));              % convert to string
% roilist(roilist(:,1)=='.',:) = [];              % find hidden folders/files (starting with '.') and delete
% num.roilist = size(roilist,1);                 % # of roilists
% roilist      = cellstr(roilist);                % make cell array (for convenience)   
% 
% load subperm
% variatione_all=0*roimask210{1}{1};
% variationr_all=0*roimask210{1}{1};
% 
% for i=16%:num.roilist
%     
%     Xe=xe210{i};
%     Xe = Xe(subperm(1:80));
%     Xr=xr210{i};
%     Xr = Xr(subperm(1:80));
%     clear ce cr variatione variationr
% 
% %     Xetrain = cat(1,Xe{:});
% %     Xetrain_mean = mean(Xetrain);
% % %     [~,feature_indexe{i}] = sort(Xetrain_mean);           
% % %     feature_indexe{i} = feature_indexe{i}(ceil(length(feature_indexe{i})*0.001):end);
% %     feature_indexe{i} = find(Xetrain_mean > 10);
% %     
% %     Xrtrain = cat(1,Xr{:});
% %     Xrtrain_mean = mean(abs(Xrtrain));
% % %     [~,feature_indexr{i}] = sort(Xrtrain_mean);           
% % %     feature_indexr{i} = feature_indexr{i}(ceil(length(feature_indexr{i})*0.001):end);
% %     feature_indexr{i} = find(Xrtrain_mean > 0.1);
%     
%     for j=1:80
% 
%         
% %        te=Xe{j}(:,feature_indexe{i})/100;
% %        tr=Xr{j}(:,feature_indexr{i});
%         te=Xe{j}/100;
%         tr=Xr{j};
%         ce(:,j,:)=te;
%         cr(:,j,:)=tr;
%    
%     end
%   ce(:,:,i)=0;
%   cr(:,:,i)=0;
%     for k=1:size(ce,1)
%         cce=squeeze(ce(k,:,:))'; ccr=squeeze(cr(k,:,:))';
%         corre=corr(cce); corre=triu(corre,1);  variatione(k) = 1-nanmean(corre(corre~=0));
%         corrr=corr(ccr); corrr=triu(corrr,1);  variationr(k) = 1-nanmean(corrr(corrr~=0));
%     end
%     
%     variatione_all(roimask210{i}{1})=variatione;
%     variationr_all(roimask210{i}{1})=variationr;
%     
%     variation(i,1) = mean(variatione); variation(i,2) = mean(variationr);
%     fprintf('roi %d\n',i)
% end
% % figure()
% % boxplot(variation)
% % 
% % dti_variation=0*roimask210{1}{1};
% % resting_variation=0*roimask210{1}{1};
% % for k=1:num.roilist
% %     dti_variation=dti_variation+roimask210{k}{1}*variation(k,1);
% %     resting_variation=resting_variation+roimask210{k}{1}*variation(k,2);
% % end
% % 
% % result_path = '/DATA/236/dywu/HCP1200/prediction_fmri/connectivity_variation210';
% % mkdir(result_path)
% % dlmwrite(fullfile(result_path,'dti_variation_region.txt'),dti_variation,'delimiter',' ','newline', 'pc','-append')
% % dlmwrite(fullfile(result_path,'resting_variation_region.txt'),resting_variation,'delimiter',' ','newline', 'pc','-append')
% % dlmwrite(fullfile(result_path,'dti_variation_vertex.txt'),variatione_all,'delimiter',' ','newline', 'pc','-append')
% % dlmwrite(fullfile(result_path,'resting_variation_vertex.txt'),variationr_all,'delimiter',' ','newline', 'pc','-append')
% % 
% % %save connectivity_variation210.mat variation

%% 4

% % load reorganize_dti_data_surf.mat
% % load restingFunConnData_4merge_surf
% % load roimask.mat 
% 
% roidir = '/DATA/235/dywu/script/ROI_surf210';
% num.chars    = 2;                               % # of characters to consider
% roilist      = struct2cell(dir(roidir))';       % list folder content
% roilist      = char(roilist(:,1));              % convert to string
% roilist(roilist(:,1)=='.',:) = [];              % find hidden folders/files (starting with '.') and delete
% num.roilist = size(roilist,1);                 % # of roilists
% roilist      = cellstr(roilist);                % make cell array (for convenience)   
% 
% load subperm
% variatione_all=0*roimask210{1}{1};
% variationr_all=0*roimask210{1}{1};
% 
% for i=1:num.roilist
%     
%     Xe=xe210{i};
%     Xe = Xe(subperm(1:80));
%     Xr=xr210{i};
%     Xr = Xr(subperm(1:80));
%     clear ce cr variatione variationr
% 
% %     Xetrain = cat(1,Xe{:});
% %     Xetrain_mean = mean(Xetrain);
% % %     [~,feature_indexe{i}] = sort(Xetrain_mean);           
% % %     feature_indexe{i} = feature_indexe{i}(ceil(length(feature_indexe{i})*0.001):end);
% %     feature_indexe{i} = find(Xetrain_mean > 10);
% %     
% %     Xrtrain = cat(1,Xr{:});
% %     Xrtrain_mean = mean(abs(Xrtrain));
% % %     [~,feature_indexr{i}] = sort(Xrtrain_mean);           
% % %     feature_indexr{i} = feature_indexr{i}(ceil(length(feature_indexr{i})*0.001):end);
% %     feature_indexr{i} = find(Xrtrain_mean > 0.1);
%     
%     for j=1:80
% 
%         
% %        te=Xe{j}(:,feature_indexe{i})/100;
% %        tr=Xr{j}(:,feature_indexr{i});
%         te=Xe{j}/100;
%         tr=Xr{j};
%         ce(:,j,:)=te;
%         cr(:,j,:)=tr;
%    
%     end
% %   ce(:,:,i)=0;
% %   cr(:,:,i)=0;
%     for k=1:size(ce,3)
%         cce=squeeze(ce(:,:,k)); ccr=squeeze(cr(:,:,k));
%         corre=corr(cce); corre=triu(corre,1);  variatione(k) = 1-nanmean(corre(corre~=0));
%         corrr=corr(ccr); corrr=triu(corrr,1);  variationr(k) = 1-nanmean(corrr(corrr~=0));
%     end
%     
%     
%     variation(i,1) = mean(variatione); variation(i,2) = mean(variationr);
%     fprintf('roi %d\n',i)
% end
% figure()
% boxplot(variation)
% 
% dti_variation=0*roimask210{1}{1};
% resting_variation=0*roimask210{1}{1};
% 
% for k=1:num.roilist
%     dti_variation=dti_variation+roimask210{k}{1}*variation(k,1);
%     resting_variation=resting_variation+roimask210{k}{1}*variation(k,2);
% end
% 
% result_path = '/DATA/236/dywu/HCP1200/prediction_fmri/connectivity_variation210';
% mkdir(result_path)
% dlmwrite(fullfile(result_path,'dti_variation_region.txt'),dti_variation,'delimiter',' ','newline', 'pc','-append')
% dlmwrite(fullfile(result_path,'resting_variation_region.txt'),resting_variation,'delimiter',' ','newline', 'pc','-append')
% 
% %save connectivity_variation210.mat variation