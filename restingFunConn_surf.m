%dbstop at 74 in restingFunConn

subdir='/DATA/236/dywu/HCP1200/data';
%subdir='/DATA/249/xli/HCP_DTI/data_40';
scriptroot='/DATA/235/dywu/HCP1200/script';
roi210dir=fullfile(subdir,'100307','MNINonLinear','ROI_surf210');
roi380dir=fullfile(subdir,'100307','MNINonLinear','ROI_surf380');

%addpath /home/dywu/spm12

sublist      = struct2cell(dir(subdir))';  % list folder content
sublist      = char(sublist(:,1));              % convert to string
sublist(sublist(:,1)=='.',:) = [];              % find hidden folders/files (starting with '.') and delete
num.sublist = size(sublist,1);                 % # of sublists
sublist      = cellstr(sublist);                % make cell array (for convenience) 


roi210list      = struct2cell(dir(fullfile(roi210dir,'*.txt')))';  % list folder content
roi210list      = char(roi210list(:,1));              % convert to string
roi210list(roi210list(:,1)=='.',:) = [];              % find hidden folders/files (starting with '.') and delete
num.roi210list = size(roi210list,1);                 % # of sublists
roi210list      = cellstr(roi210list);                % make cell array (for convenience) 

roi380list      = struct2cell(dir(fullfile(roi380dir,'*.txt')))';  % list folder content
roi380list      = char(roi380list(:,1));              % convert to string
roi380list(roi380list(:,1)=='.',:) = [];              % find hidden folders/files (starting with '.') and delete
num.roi380list = size(roi380list,1);                 % # of sublists
roi380list      = cellstr(roi380list);                % make cell array (for convenience) 


%%
fprintf('load roi\n')
for k=1:num.roi210list
    tr = load(fullfile(roi210dir,roi210list{k}));
    for i=1:num.sublist
        %roimask_temp{k}{i} = logical(tr(:)'); 
        roimask210{k}{i} = logical(tr);
    end
end

for k=1:num.roi380list
    tr = load(fullfile(roi380dir,roi380list{k}));
    for i=1:num.sublist
        %roimask_temp{k}{i} = logical(tr(:)'); 
        roimask380{k}{i} = logical(tr);
    end
end


for i=1:num.sublist
    
    %V = spm_vol(fullfile(subdir,sublist{i},'MNINonLinear/Results/rfMRI_REST1_RL/rfMRI_REST1_RL_hp2000_clean.nii'));
    tdata1 = load(fullfile(subdir,sublist{i},'MNINonLinear/Results/rfMRI_REST1_LR/rfMRI_REST1_LR_Atlas_MSMAll_hp2000_clean.txt'));
    tdata2 = load(fullfile(subdir,sublist{i},'MNINonLinear/Results/rfMRI_REST1_RL/rfMRI_REST1_RL_Atlas_MSMAll_hp2000_clean.txt'));
    tdata3 = load(fullfile(subdir,sublist{i},'MNINonLinear/Results/rfMRI_REST2_LR/rfMRI_REST2_LR_Atlas_MSMAll_hp2000_clean.txt'));
    tdata4 = load(fullfile(subdir,sublist{i},'MNINonLinear/Results/rfMRI_REST2_RL/rfMRI_REST2_RL_Atlas_MSMAll_hp2000_clean.txt'));
    
    tdata1 = tdata1-repmat(mean(tdata1,2),1,1200);
    std1 = std(tdata1,0,2);
    std1(std1==0)=1;
    tdata1 = tdata1./repmat(std1,1,1200);
    
    tdata2 = tdata2-repmat(mean(tdata2,2),1,1200);
    std2 = std(tdata2,0,2);
    std2(std2==0)=1;
    tdata2 = tdata2./repmat(std2,1,1200);
    
    tdata3 = tdata3-repmat(mean(tdata3,2),1,1200);
    std3 = std(tdata3,0,2);
    std3(std3==0)=1;
    tdata3 = tdata3./repmat(std3,1,1200);
    
    tdata4 = tdata4-repmat(mean(tdata4,2),1,1200);
    std4 = std(tdata4,0,2);
    std4(std4==0)=1;
    tdata4 = tdata4./repmat(std4,1,1200);
    
    tdata = [tdata1 tdata2 tdata3 tdata4];


%     tdata(1,tdata(1,:)==0)=nan;
%     tdata(1201,tdata(1201,:)==0)=nan;
%     tdata(2401,tdata(2401,:)==0)=nan;
%     tdata(3601,tdata(3601,:)==0)=nan;
%     for k=1:num.roi210list
% 	tdata_roi = tdata(roimask_temp{k}{i},:);
% % 	index_notnan1 = ~isnan(tdata2(1,:));
% % 	index_notnan2 = ~isnan(tdata2(1201,:));
% % 	index_notnan3 = ~isnan(tdata2(2401,:));
% % 	index_notnan4 = ~isnan(tdata2(3601,:));
% % 	index_notnan{k}{i} = logical(index_notnan1.*index_notnan2.*index_notnan3.*index_notnan4);
%     end
    clear tdatam210 tdatam380
    for k=1:num.roi210list
            tdatamt = tdata(roimask210{k}{i},:);
	        %tdatam = tdatam(:,index_notnan{k}{i});
            tdatam210(k,:) = mean(tdatamt,1);
                                                          
    end
    for k=1:num.roi380list
            tdatamt = tdata(roimask380{k}{i},:);
	        %tdatam = tdatam(:,index_notnan{k}{i});
            tdatam380(k,:) = mean(tdatamt,1);
                                                          
    end
    
    for j=1:num.roi210list
        fprintf('calculating FunConn of %s %s\n',sublist{i},roi210list{j})
        tdata_roi = tdata(roimask210{j}{i},:);
        %index_notnan{j}{i} = ~isnan(tdata2(1,:));
        %tdata2 = tdata2(:,index_notnan{j}{i});
        
%         tdata_temp = tdata(1,:).*tdata(1201,:).*tdata(2401,:).*tdata(3601,:).*roimask{j}{i};
%         tdata_temp(tdata_temp==0)=nan;
%         roimask{j}{i} = ~isnan(tdata_temp);
        xr210{j}{i} = corr(tdata_roi',tdatam210');      
    end    
    
    for j=1:num.roi380list
        fprintf('calculating FunConn of %s %s\n',sublist{i},roi380list{j})
        tdata_roi = tdata(roimask380{j}{i},:);
        %index_notnan{j}{i} = ~isnan(tdata2(1,:));
        %tdata2 = tdata2(:,index_notnan{j}{i});
        
%         tdata_temp = tdata(1,:).*tdata(1201,:).*tdata(2401,:).*tdata(3601,:).*roimask{j}{i};
%         tdata_temp(tdata_temp==0)=nan;
%         roimask{j}{i} = ~isnan(tdata_temp);
        xr380{j}{i} = corr(tdata_roi',tdatam380');      
    end    
    
end

save('restingFunConnData_4merge_surf.mat','xr210','xr380','roimask210','roimask380','-v7.3')
