
subdir='/DATA/236/dywu/HCP1200/data';
%subdir='/DATA/249/xli/HCP_DTI/data_40';
scriptroot='/DATA/235/dywu/HCP1200/script';
roi210dir=fullfile(subdir,'100307','MNINonLinear','ROI_surf210');
roi380dir=fullfile(subdir,'100307','MNINonLinear','ROI_surf380');

addpath /DATA/235/dywu/gifti

sublist      = struct2cell(dir(subdir))';  % list folder content
sublist      = char(sublist(:,1));              % convert to string
sublist(sublist(:,1)=='.',:) = [];              % find hidden folders/files (starting with '.') and delete
num.sublist = size(sublist,1);                 % # of sublists
sublist      = cellstr(sublist);                % make cell array (for convenience) 


roi210list      = struct2cell(dir(fullfile(roi210dir,'*.func.gii')))';  % list folder content
roi210list      = char(roi210list(:,1));              % convert to string
roi210list(roi210list(:,1)=='.',:) = [];              % find hidden folders/files (starting with '.') and delete
num.roi210list = size(roi210list,1);                 % # of sublists
roi210list      = cellstr(roi210list);                % make cell array (for convenience) 

roi380list      = struct2cell(dir(fullfile(roi380dir,'*.func.gii')))';  % list folder content
roi380list      = char(roi380list(:,1));              % convert to string
roi380list(roi380list(:,1)=='.',:) = [];              % find hidden folders/files (starting with '.') and delete
num.roi380list = size(roi380list,1);                 % # of sublists
roi380list      = cellstr(roi380list);                % make cell array (for convenience) 


%%
fprintf('load roi\n')
for k=1:num.roi210list
    
    t=gifti(fullfile(roi210dir,roi210list{k}));
    roi210{k}=logical(t.cdata);
end

for k=1:num.roi380list
   
    t=gifti(fullfile(roi380dir,roi380list{k}));
    roi380{k}=logical(t.cdata);
end

%%
for i=1:num.sublist
    
    fprintf('calculating distance of %s\n',sublist{i})
    coo_left=gifti(fullfile(subdir,sublist{i},'MNINonLinear/ROI_surf2/left_coordinate.func.gii')); 
    cl = coo_left.cdata;
    coo_right=gifti(fullfile(subdir,sublist{i},'MNINonLinear/ROI_surf2/right_coordinate.func.gii'));
    cr = coo_right.cdata;
    
    for k=1:num.roi210list
        
        if mod(k,2)==1
            cm210(k,:) = mean(cl(roi210{k},:));
        else
            cm210(k,:) = mean(cr(roi210{k},:));
        end
                                                          
    end
    for k=1:num.roi380list
        
        if mod(k,2)==1
            cm380(k,:) = mean(cl(roi380{k},:));
        else
            cm380(k,:) = mean(cr(roi380{k},:));
        end
                                                          
    end
    
    
    for k=1:num.roi210list
        
        if mod(k,2)==1
            ct = cl(roi210{k},:);
            for j=1:210
                xdis210{k}{i}(:,j) = sqrt(sum( (ct - repmat(cm210(j,:),size(ct,1),1)).^2 , 2));
            end
            
        else
            ct = cr(roi210{k},:);
            for j=1:210
                xdis210{k}{i}(:,j) = sqrt(sum( (ct - repmat(cm210(j,:),size(ct,1),1)).^2 , 2));
            end
        end
                                                          
    end
    for k=1:num.roi380list
        
        if mod(k,2)==1
            ct = cl(roi380{k},:);
            for j=1:num.roi380list
                xdis380{k}{i}(:,j) = sqrt(sum( (ct - repmat(cm380(j,:),size(ct,1),1)).^2 , 2));
            end
        else
            ct = cr(roi380{k},:);
            for j=1:num.roi380list
                xdis380{k}{i}(:,j) = sqrt(sum( (ct - repmat(cm380(j,:),size(ct,1),1)).^2 , 2));
            end
        end
                                                          
    end
    
end

save('distance.mat','xdis210','xdis380','-v7.3')
